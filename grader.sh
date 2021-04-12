#!/bin/bash

display_usage() {
  echo "Usage: $0 -c <class> -t <semester e.g.: 2020_2> -r <student-registry>"
  echo "Available classes: decom009 (Linguagens de Programação), decom035 (Linguages Formais e Autômatos) and decom042 (Linux)"
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
    display_usage 1>&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

available_classes=(decom009 decom035 decom042)
if [[ $class =~ " " || ! " ${available_classes[*]} " =~ " $class " || -z "$semester" || -z "$registry" ]]; then
  display_usage 1>&2
  exit 1
fi

echo "Getting grades..."
response=$(curl -s -X POST -H "Accept: application/xml" http://rimsa.com.br/services/grading.php\?lecture=$class\&term=$semester\&registry=$registry | sed "s:\.:,:")

echo
echo "Parsing..."

IFS=$'\r\n ' name=$(echo "$response" | grep '<name>' | sed 's:[[:space:]]*<name>\(.*\)</name>:\1:')
IFS=$'\r\n ' link=$(echo "$response" | grep '<link>' | sed 's:[[:space:]]*<link>\(.*\)</link>:\1:')

IFS=$'\r\n ' exams_arr=($(echo "$response" | grep '<grade id="exam' | sed 's:[[:space:]]*<grade id="exam.*" .*>\(.*\)</grade>:\1:' | tr ',' '.'))
IFS=$'\r\n ' tests_arr=($(echo "$response" | grep '<grade id="test' | sed 's:[[:space:]]*<grade id="test.*" .*>\(.*\)</grade>:\1:' | tr ',' '.'))

IFS=$'\r\n ' extras=$(echo "$response" | grep '<grade id="extras"' | sed 's:[[:space:]]*<grade .*>\(.*\)</grade>:\1:' | tr ',' '.')
IFS=$'\r\n ' total=$(echo "$response" | grep '<grade id="total"' | sed 's:[[:space:]]*<grade .*>\(.*\)</grade>:\1:' | tr ',' '.')

clear

if [[ -z $name ]]; then
  echo "Student with registry $registry was not found within the class $class"
  exit 1
fi

echo "Student: $name"
if [[ -z $link ]]; then
  echo "Folder link: unavailable"
else
  echo "Folder link: $(echo $link | sed 's:,:\.:')"
fi
echo

echo "Exams: "
for ((i = 1; i < ${#exams_arr[@]}; i++)); do
  printf "%3s%02d: %05.2f\n" E $i ${exams_arr[i]}
done
echo "Exams Total: ${exams_arr[0]}"
echo

echo "Tests: "
for ((i = 1; i < ${#tests_arr[@]}; i++)); do
  printf "%3s%02d: %05.2f\n" T $i ${tests_arr[i]}
done
echo "Tests Total: ${tests_arr[0]}"
echo

printf "Extra: %05.2f\n" $extras
echo

printf "Total: %05.2f\n" $total
