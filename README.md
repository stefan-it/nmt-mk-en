# Neural Machine Translation system for Macedonian to English

This repository contains all data and documentation for building a neural
machine translation system for Macedonian to English. This work was done during
the the M.Sc. course (summer term) [Machine Translation](http://cis.lmu.de/~fraser/mt_2017/)
held by [Dr. Alex Fraser](http://cis.lmu.de/~fraser/).

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

# *fairseq* - Facebook AI Research Sequence-to-Sequence Toolkit

The first NMT system for Macedonian to English is built with [*fairseq*](https://github.com/facebookresearch/fairseq).
We trained three systems with different architectures:

* Standard Bi-LSTM
* CNN as encoder, LSTM as decoder
* Fully convolutional

Furthermore we use different *BPE* merge operations: 16.000 and 32.000. Here are
the results on the final test set:

| Model                        | *BPE* merge operations  | BLEU-Score
| ---------------------------- | ----------------------- | ----------
| Bi-LSTM                      | 32.000                  | 46,84
| Bi-LSTM                      | 16.000                  | 47,57
| CNN encoder, LSTM decoder    | 32.000                  | 19,83
| CNN encoder, LSTM decoder    | 16.000                  | 9,59
| Fully convolutional          | 32.000                  | 48,81
| Fully convolutional          | 16.000                  | **49,03**

The best bleu-score was obtained with the fully convolutional model with
16.000 merge operations.

# *tensor2tensor* - Transformer

The second NMT system for Macedonian to English is built with the [*tensor2tensor*](https://github.com/tensorflow/tensor2tensor)
library. We trained two systems: one subword-based system and one
character-based NMT system. Here are the results on the final test set:

| Model                        | BLEU-Score
| ---------------------------- | ----------
| Transformer                  | **52,70**
| Transformer (char-based)     | 34,26

# Further work

We want to train a char-based NMT system with the [dl4mt-c2c](https://github.com/nyu-dl/dl4mt-c2c)
library in near future.

Another task is to train a "big" *Transformer* model.

# Acknowledgments

We would like to thank the *Leibniz-Rechenzentrum der Bayerischen Akademie der
Wissenschaften* ([LRZ](https://www.lrz.de/english/)) for giving us access to the
NVIDIA *DGX-1* supercomputer.

# Presentations

* Short-presentation at [Deep Learning Workshop @ LRZ](https://www.lrz.de/services/compute/courses/2017-09-14_hdlw1s17/),
  can be found [here](short-presentation/stefan_schweter_dlw17.pdf).
