while [ -n "$1" ]; do # while loop starts
  case "$1" in
  --front)
    imagesFilter[0]=front
    ;;
  --data)
    imagesFilter[1]=data
    ;;
  --tools)
    imagesFilter[2]=tools
    ;;
  --data,front | --front,data)
    imagesFilter[0]=front
    imagesFilter[1]=data
    ;;
  --tools,front | --front,tools)
    imagesFilter[0]=front
    imagesFilter[2]=tools
    ;;
  --tools,data | --data,tools)
    imagesFilter[1]=data
    imagesFilter[2]=tools
    ;;
  -f | --from)
    if [ -z "$2" ]; then
      echo "${red}Empty value not allowed for from tag (./tagAll.sh --from tagFrom --to tagTo)${reset}"
      exit 1
    fi
    tagFrom="$2"
    shift
    ;;
  -t | --to)
    if [ -z "$2" ]; then
      echo "${red}Empty value not allowed for to tag (./tagAll.sh --from tagFrom --to tagTo)${reset}"
      exit 1
    fi
    tagTo="$2"
    shift
    ;;
  --aws-profile)
    if [ -z "$2" ]; then
      if [ -n "$AWS_PROFILE" ]; then
        awsProfile="$AWS_PROFILE"
      else
        awsProfile=""
      fi
      exit 1
    fi
    awsProfile="$2"
    shift
    ;;
  --quiet)
    assumeYes=true
    ;;
  --)
    shift # The double dash makes them parameters
    break
    ;;
  *) echo "Option $1 not recognized" ;;
  esac
  shift
done

# If no filter is passed, we plan to use all images (so wildward used).
# shellcheck disable=SC2128
if [ ${#imagesFilter[@]} == 0 ]; then
  imagesFilter[0]="*"
fi

# If no profile is passed or guessed via the .env file content don't pass a profile (rely on EC2 IAM roles or default profile).
AWS_PROFILE_CLI=""
if [ -n "$awsProfile" ]; then
  AWS_PROFILE_CLI="--profile $awsProfile"
fi

echo -e "AWS ECR Repository Tagging\n--------------------------\nImages:      ${green}${imagesFilter[*]}${reset}\nTag From:    ${green}$tagFrom${reset}\nTag To:      ${green}$tagTo${reset}\nAWS Profile: ${green}$awsProfile${reset}\n"
