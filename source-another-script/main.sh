#!/bin/bash -e

# Note:
# This script is intended to be called within the path
# where it is located and the path must not start with
# a / (forward slash)
# The find command in the 'require' function can have a
# performance impact if the script is called from a path
# that has too many sub folders.

import() {
   # Designed to run in the folder specified in argument $1 or from
   # its immediate parent folder
   echo "${FUNCNAME} started"
   local this_script=$0
   local required_script=$1
   local folder=$2

   # THe path of the current folder
   local curr_path=$PWD 

   # Current folder this script is called from and
   # where the required script is located
   local curr_folder=$(basename ${curr_path})
   if [ $curr_folder == $folder ]; then
      . ./${required_script}
   fi

   if [ $curr_folder != $folder ]; then
      require $folder $required_script
   fi
   echo "${FUNCNAME} ended"
}


require() {
   echo "${FUNCNAME} started"

   local folder=$1
   local required_script=$2
   local curr_path=$PWD

   # Determine the number of folders in the value of PWD and
   # save the position of the last folder
   # last_position=$(echo $curr_path | sed 's/\//-/g' | grep -o '-' | wc -l | xargs)
   # echo "last_position=${last_position}"

   # Get the name of the last folder in the value of PWD
   # last_folder=$(echo $curr_path | sed 's/\//-/g' | awk -v "column=${last_position}" '{print $column}')
   # echo "last_folder=${last_folder}"

   # From the current folder where this script is executed from, 
   # find the required folder
   folder_path=$(find . -type d -name ${folder})
   echo "folder_path=${folder_path}"
   echo $folder_path | grep $folder
   status=$?
   if [ $status -eq 0 ]; then
      # ${folder} is found in the path but we are not in it
      . ${folder_path}/${required_script}
   else
      echo "curr_path=${curr_path}"
      echo "folder=${folder}"
      if [ $(basename $curr_path) == $folder ]; then
         # We are already in the ${folder}
         . "${curr_path}/${required_script}"
      else
         echo "The required script ${required_script} could not be found"
         exit 1
      fi
   fi
   echo "${FUNCNAME} ended"

}

# Tests - from_folder is the name of the folder where the required script is in
from_folder='import'
lib='common.sh'
import $lib $from_folder

from_folder='import'
lib='third-party.sh'
import $lib $from_folder

common_func
another_func
run
