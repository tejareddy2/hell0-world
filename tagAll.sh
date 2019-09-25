red=$(tput setaf 1)
green=$(tput setaf 2)
bold=$(tput bold)
reset=$(tput sgr0)
declare -a imagesFilter

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
if [ ${#imagesFilter[@]} == 0 ]; then
  imagesFilter[0]="*"
fi
echo -e "AWS ECR Repository Tagging\n--------------------------\nImages:      ${green}${imagesFilter[*]}${reset}\nTag From:    ${green}$tagFrom${reset}\nTag To:      ${green}$tagTo${reset}\nAWS Profile: ${green}$awsProfile${reset}\n"
