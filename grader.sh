#!/bin/bash

usage() {
  echo "Usage: $0 -c <class> -t <semester> -r <student-registry>"
}

# https://stackoverflow.com/a/16496491
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
response=$(curl -s -X POST -H "Accept: application/xml" http://rimsa.com.br/services/grading.php\?lecture=$class\&term=$semester\&registry=$registry | sed "s:\.:,:")

echo
echo "Parsing..."

IFS=$'\r\n ' name=$(echo "$response" | grep '<name>' | sed 's:[[:space:]]*<name>\(.*\)</name>:\1:')
IFS=$'\r\n ' link=$(echo "$response" | grep '<link>' | sed 's:[[:space:]]*<link>\(.*\)</link>:\1:')

IFS=$'\r\n ' exams_arr=($(echo "$response" | grep '<grade id="exam' | sed 's:[[:space:]]*<grade id="exam.*" .*>\(.*\)</grade>:\1:'))
IFS=$'\r\n ' tests_arr=($(echo "$response" | grep '<grade id="test' | sed 's:[[:space:]]*<grade id="test.*" .*>\(.*\)</grade>:\1:'))

IFS=$'\r\n ' extras=$(echo "$response" | grep '<grade id="extras"' | sed 's:[[:space:]]*<grade .*>\(.*\)</grade>:\1:')
IFS=$'\r\n ' total=$(echo "$response" | grep '<grade id="total"' | sed 's:[[:space:]]*<grade .*>\(.*\)</grade>:\1:')

clear
echo "Student: $name"
echo "Folder link: $link"
echo

echo "Exams: "
for ((i = 1; i < ${#exams_arr[@]}; i++)); do
  LC_NUMERIC="pt_BR.UTF-8" printf "%3s%02d: %05.2f\n" E $i ${exams_arr[i]}
done
echo "Total: ${exams_arr[0]}"
echo

echo "Tests: "
for ((i = 1; i < ${#tests_arr[@]}; i++)); do
  LC_NUMERIC="pt_BR.UTF-8" printf "%3s%02d: %05.2f\n" T $i ${tests_arr[i]}
done
echo "Total: ${tests_arr[0]}"
echo

LC_NUMERIC="pt_BR.UTF-8" printf "Extra: %05.2f\n" $extras
echo

LC_NUMERIC="pt_BR.UTF-8" printf "Total: %05.2f\n" $total
