# MLMicrobiomeBenchmark
A project benchmarking three ML tools for microbiome analysis

## Getting Started 
For the first step, we must download all three tools to be benchmarked. For this project, I chose to use mikropml, qiime2 / q2-sample-classifier, and DeepMicro. Each has a different installation process, so it can be a little tricky.

### Installing mikropml
Since mikropml is an R package, we can simply install it by using:
```
install.packages('mikropml')
library(mikropml)
```

### Installing DeepMicro
For the next two packages, you will need to have Miniconda installed.
DeepMicro is a Python package that can be simply installed by copying their GitHub repository into your working directory:
```
~$ git clone https://github.com/minoh0201/DeepMicro
~$ cd DeepMicro
```
The next couple of steps can be followed along on their GitHub page: https://github.com/minoh0201/DeepMicro 

### Installing QIIME2 / q2-sample-classifier
QIIME2 is another Python package, but it recommends using Miniconda to install it. The steps to do that are as follows:
```
~$ conda env create \
     --name qiime2-amplicon-2026.1 \
     --file
~$ https://raw.githubusercontent.com/qiime2/distributions/refs/heads/dev/2026.1/amplicon/released/qiime2-amplicon-ubuntu-latest-conda.yml

~$ conda activate qiime2-amplicon-2026.1
~$ qiime sample-classifier --help
```
