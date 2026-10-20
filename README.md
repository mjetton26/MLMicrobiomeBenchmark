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

## Formatting Data
The next step of the project would be to format the data for each tool. Each tool expects the input data uniquely, so we must reformat the input files based on where the input data was downloaded from. Mikropml is the simplest and requires one file containing the samples as rows and the columns with the dx label and OTU abundances. The first dataset I used came from the Mikropml GitHub, titled "otu-large.csv", so I will explain how to go from this file to the other types.

DeepMicro wants two separate files in its data folder. The first one would be a CSV file where each row is the sample, and each column has the OTU abundances. The second file is the label file where each line has a 1 or 0, so for this dataset, cancer is 1 and normal is 0.
QIIME2 requires the most work to prepare the data. QIIME wants a .qza file and a TSV file containing the metadata. First, the abundance data must be transposed so OTUs are rows and samples are columns, with sample IDs added. It is then converted to a BIOM file and imported as a .qza file. The labels go in a separate file with a sample-id column and a dx column. It is required that the sample IDs match between the two files. 

The first steps of converting the file from Mikropml are done in R; the code I used is in the R script file labeled "data_prep.R". This will take you through preparing the data for DeepMicro and preparing the files for converting to a BIOM file for QIIME2. To convert to a BIOM file for QIIME2 use, I did these steps in the terminal:
```
biom convert \
  -i /YOUR DIRECTORY HERE/qiime2_feature_table.tsv \
  -o colo_feature_table.biom \
  --table-type="OTU table" \
  --to-hdf5

qiime tools import \
  --input-path colo_feature_table.biom \
  --type 'FeatureTable[Frequency]' \
  --input-format BIOMV210Format \
  --output-path feature_table.qza
```
Here is a summarized version of the workflow for converting input data formats:
### Starting with MikropML data:
Starting with an OTU Table with DX labels in R:

OTU Table -> add sample IDs -> split dx from OTU columns -> write DeepMicro features + labels -> transpose OTUs to rows and write the QIIME2 TSV + metadata -> (in terminal) biom convert -> qiime tools import to qza
