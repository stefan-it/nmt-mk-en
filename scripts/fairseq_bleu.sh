#!/bin/bash

INPUT=$1

MOSES_GIT_URL=${MOSES_GIT_URL:-https://github.com/moses-smt/mosesdecoder.git}
MOSES_BLEU=${MOSES_SCRIPT:-mosesdecoder/scripts/generic/multi-bleu.perl}
PERL=${PERL:-perl}

grep ^H $INPUT | cut -f3- | sed 's/@@ //g' > $1.actual
grep ^T $INPUT | cut -f2- | sed 's/@@ //g' > $1.ref

if [ ! -d "mosesdecoder" ]; then
  git clone ${MOSES_GIT_URL}
fi

${PERL} ${MOSES_BLEU} $1.ref < $1.actual
