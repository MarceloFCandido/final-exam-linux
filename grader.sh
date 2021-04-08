#!/bin/bash

IFS=$'\r\n ' grades_arr=($(cat text.xml | grep '<grade' | sed 's:[[:space:]]*<grade .*>\(.*\)</grade>:\1:'))

grades_length=${#grades_arr[@]}

tests_total=${grades_arr[0]}
extras=${grades_arr[((grades_length - 2))]}
total=${grades_arr[((grades_length - 1))]}
tests_arr=(${grades_arr[@]:1:((grades_length - 3))})
