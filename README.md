# Neural Machine Translation system for Macedonian to English

This repository contains all data and documentation for building a neural
machine translation system for Macedonian to English. This work was done during
the the M.Sc. course (summer term) [Machine Translation](http://cis.lmu.de/~fraser/mt_2017/)
held by [Prof. Dr. Alex Fraser](http://cis.lmu.de/~fraser/).

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

## Preprocessing

All necessary scripts can be found in the `scripts` folder of this repository.

In the first step, we need to download and extract the parallel *SETimes* corpus
for Macedonian to English:

```bash
wget http://nlp.ffzg.hr/data/corpora/setimes/setimes.en-mk.txt.tgz
tar -xf setimes.en-mk.txt.tgz
```

The `data_preparation.sh` scripts performs the following steps on the corpus:

* download of the *MOSES* tokenizer script; tokenization of the whole corpus
* download of the *BPE* scripts; learning and applying *BPE* on the corpus

```bash
./data_preparation setimes.en-mk.mk.txt setimes.en-mk.en.txt
```

After that the corpus is split into training, development and test set:

```bash
./split_dataset corpus.clean.bpe.32000.mk corpus.clean.bpe.32000.en
```

The following folder structure needs to be created:

```bash
mkdir {train,dev,test}

mv dev.* dev
mv train.* train
mv test.* test

mkdir model-data
```

After that the `fairseq` tool can be invoked to preprocess the corpus:

```bash
fairseq preprocess -sourcelang mk -targetlang en -trainpref train/train \
                   -validpref dev/dev -testpref test/test -thresholdsrc 3 \
                   -thresholdtgt 3 -destdir model-data
```

## Training

After the preprossing steps the three models can be trained.

### Standard Bi-LSTM

With the following command the bi-lstm model can be trained:

```bash
fairseq train -sourcelang mk -targetlang en -datadir model-data -model blstm \
              -nhid 512 -dropout 0.2 -dropout_hid 0 -optim adam -lr 0.0003125 \
              -savedir model-blstm
```

### CNN as encoder, LSTM as decoder

With the following command the CNN as encoder, LSTM as decoder model can be
trained:

```bash
fairseq train -sourcelang mk -targetlang en -datadir model-data -model conv \
              -nenclayer 6 -dropout 0.2 -dropout_hid 0 -savedir model-conv
```

### Fully convolutional

With the following command the fully convolutional model can be trained:

```bash
fairseq train -sourcelang mk -targetlang en -datadir model-data -model fconv \
              -nenclayer 4 -nlayer 3 -dropout 0.2 -optim nag -lr 0.25 \
              -clip 0.1 -momentum 0.99 -timeavg -bptt 0 -savedir model-fconv
```

## Decoding

### Standard Bi-LSTM

With the following command the bi-lstm model can decode the test set:

```bash
fairseq generate -sourcelang mk -targetlang en \
                 -path model-blstm/model_best.th7 -datadir model-data -beam 10 \
                 -nbest 1 -dataset test > model-blstm/system.output
```

### CNN as encoder, LSTM as decoder

With the following command the CNN as encoder, LSTM as decoder model can
decode the test set:

```bash
fairseq generate -sourcelang mk -targetlang en -path model-conv/model_best.th7 \
                 -datadir model-data -beam 10 -nbest 1 \
                 -dataset test > model-conv/system.output
```

### Fully convolutional

With the following command the fully convolutional model can decode the test set:

```bash
fairseq generate -sourcelang mk -targetlang en -path model-fconv/model_best.th7 \
                 -datadir model-data -beam 10 -nbest 1 \
                 -dataset test > model-fconv/system.output
```

## Calculating the BLEU-score

With the helper script `fairseq_bleu.sh` the BLEU-score of all models can be
calculated very easy. The script expects the system output file as command
line argument:

```bash
./fairseq_bleu.sh model-blstm/system.output
```

## Results

We use different *BPE* merge operations: 16.000 and 32.000. Here are
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

## Training (Transformer base)

The following training steps are tested with *tensor2tensor* in version *1.5.1*.

First, we create the initial directory structure:

```bash
mkdir -p t2t_data t2t_datagen t2t_train t2t_output
```

In the next step, the training and development datasets are downloaded and
prepared:

```bash
t2t-datagen --data_dir=t2t_data --tmp_dir=t2t_datagen/ --problem=translate_enmk_setimes32k
```

Then the training step can be started:

```bash
t2t-trainer --data_dir=t2t_data --problems=translate_enmk_setimes32k_rev --model=transformer --hparams_set=transformer_base --output_dir=t2t_output
```

The number of GPUs used for training can be specified with the `--worker_gpu`
option.

## Decoding

In the next step, the test dataset is downloaded and extracted:

```bash
wget "https://github.com/stefan-it/nmt-mk-en/raw/master/data/setimes.mk-en.test.tgz"
tar -xzf setimes.mk-en.test.tgz
```

Then the decoding step for the test dataset can be started:

```bash
t2t-decoder --data_dir=t2t_data --problems=translate_enmk_setimes32k_rev \
  --model=transformer --decode_hparams="beam_size=4,alpha=0.6" \
  --decode_from_file=test.mk --decode_to_file=system.output \
  --hparams_set=transformer_big --output_dir=t2t_output/
```

## Calculating the BLEU-score

The BLEU-score can be calculated with the built-in `t2t-bleu` tool:

```bash
t2t-bleu --translation=system.output --reference=test.en
```

## Results

The following results can be achieved using the Transformer model. A
character-based model was also trained and measured. A big transformer model
was also trained using *tensor2tensor* in version *1.2.9* (latest version has
a bug, see [this](https://github.com/tensorflow/tensor2tensor/issues/529) issue).

| Model                        | BLEU-Score
| ---------------------------- | ----------
| Transformer                  | **54,00** (uncased)
| Transformer (big)            | 43,74 (uncased)
| Transformer (char-based)     | 37.43 (uncased)

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
