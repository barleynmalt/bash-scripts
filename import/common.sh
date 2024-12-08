#!/bin/bash -e

common_func() {
   echo "${FUNCNAME} started"
   echo "common_func()"
   echo "${FUNCNAME} ended"
}

another_func() {
   echo "${FUNCNAME} started"
   echo "${FUNCNAME} ended"
}
