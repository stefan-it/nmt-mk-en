#!/bin/bash

LINES_NUMBER=$(wc -l $1 | cut -d" " -f1)

DEV_NUMBER=${DEV_NUMBER:-1000}
TEST_NUMBER=${TEST_NUMBER:-1000}

dev_test_number=$(($DEV_NUMBER+$TEST_NUMBER))

TRAIN_NUMBER=$(($LINES_NUMBER-$dev_test_number))

TRAIN_SOURCE=train.mk
TRAIN_TARGET=train.en

DEV_SOURCE=test.mk
DEV_TARGET=test.en

TEST_SOURCE=dev.mk
TEST_TARGET=dev.en

SOURCE=$1
TARGET=$2

head -n ${TRAIN_NUMBER} ${SOURCE} > $TRAIN_SOURCE
head -n ${TRAIN_NUMBER} ${TARGET} > $TRAIN_TARGET

tail -n $dev_test_number ${SOURCE} > dev_test_source
tail -n $dev_test_number ${TARGET} > dev_test_target

head -n ${DEV_NUMBER} dev_test_source > $DEV_SOURCE
head -n ${DEV_NUMBER} dev_test_target > $DEV_TARGET

tail -n ${TEST_NUMBER} dev_test_source > $TEST_SOURCE
tail -n ${TEST_NUMBER} dev_test_target > $TEST_TARGET

# Unittest

> source_combined
> target_combined

cat $TRAIN_SOURCE $DEV_SOURCE $TEST_SOURCE >> source_combined
cat $TRAIN_TARGET $DEV_TARGET $TEST_TARGET >> target_combined

diff -u source_combined ${SOURCE}
diff -u target_combined ${TARGET}

rm -f dev_test_source dev_test_target source_combined target_combined
