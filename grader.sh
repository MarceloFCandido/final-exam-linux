#!/bin/bash

usage() {
  echo "Usage: $0 -c <class> -t <semester> -r <student-registry>"
}

while getopts "hc:t:r:" o; do
  case "${o}" in
  "h")
    usage
    exit 0
    ;;
  "c")
    class=${OPTARG}
    ;;
  "t")
    semester=${OPTARG}
    ;;
  "r")
    registry=${OPTARG}
    ;;
  *)
    echo "Invalid argument: $o"
    usage 1>&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

if [[ -z "$class" || -z "$semester" || -z "$registry" ]]; then
  usage 1>&2
  exit 1
fi

echo "Getting grades..."
response=$(curl -s -X POST -H "Accept: application/xml" http://rimsa.com.br/services/grading.php\?lecture=$class\&term=$semester\&registry=$registry)

echo
echo "Parsing..."
IFS=$'\r\n ' name=$(echo "$response" | grep '<name>' | sed 's:[[:space:]]*<name>\(.*\)</name>:\1:')
IFS=$'\r\n ' link=$(echo "$response" | grep '<link>' | sed 's:[[:space:]]*<link>\(.*\)</link>:\1:')
IFS=$'\r\n ' grades_arr=($(echo "$response" | grep '<grade' | sed 's:[[:space:]]*<grade .*>\(.*\)</grade>:\1:'))

grades_length=${#grades_arr[@]}

tests_total=${grades_arr[0]}
extras=${grades_arr[((grades_length - 2))]}
total=${grades_arr[((grades_length - 1))]}
tests_arr=(${grades_arr[@]:1:((grades_length - 3))})

echo "Student: $name"
echo "Folder link: $link"
