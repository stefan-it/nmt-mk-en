# Neural Machine Translation system for Macedonian to English

This repository contains all data and documentation for building a neural
machine translation system for Macedonian to English. This work was done during
the the M.Sc. course (summer term) [Machine Translation](http://cis.lmu.de/~fraser/mt_2017/)
held [Dr. Alex Fraser](http://cis.lmu.de/~fraser/).

# Dataset

The [*SETimes corpus*](http://nlp.ffzg.hr/resources/corpora/setimes/) contains
of 207,777 parallel sentences for the Macedonian and English language pair.

For all experiments the corpus was split into training, development and
test set:

| Data set    | Sentences | Download
| ----------- | --------- | -----------------------------------------------------------------------------------------------------------------------------------------
| Training    | 205,777   | via [GitHub](https://github.com/stefan-it/nmt-mk-en/raw/master/data/setimes.mk-en.train.tgz) or located in `data/setimes.mk-en.train.tgz`
| Development |   1,000   | via [GitHub](https://github.com/stefan-it/nmt-mk-en/raw/master/data/setimes.mk-en.dev.tgz) or located in `data/setimes.mk-en.dev.tgz`
| Test        |   1,000   | via [GitHub](https://github.com/stefan-it/nmt-mk-en/raw/master/data/setimes.mk-en.test.tgz) or located in `data/setimes.mk-en.test.tgz`

