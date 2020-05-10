#!/bin/bash
export SHELL_DIR=`pwd`
export TOP_DIR=$(dirname "$PWD")
export SRC_DIR=$TOP_DIR/src
export IMAGE_DIR=$TOP_DIR/images

export CPU_PHYSICAL_NUM=`cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l`
export CPU_LOGICAL_NUM=`cat /proc/cpuinfo| grep "processor"| wc -l`
#export PER_CPU_NUM=`cat /proc/cpuinfo| grep "cpu cores"| uniq`
#echo $TOP_DIR
#echo $SHELL_DIR
#echo $SRC_DIR
#echo $IMAGE_DIRi
#echo $PHYSICAL_NUM
#echo  $CPU_LOGICAL_NUM
