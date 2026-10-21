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

The first steps of converting the file from Mikropml are done in R; the code I used is in the R script file labeled "data_prep.R". This will take you through preparing the data for DeepMicro and preparing the files for converting to a BIOM file for QIIME2. To convert to a BIOM file for use with QIIME2, I did these steps in the terminal:
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
### Starting with Mikropml data:
Starting with an OTU Table with DX labels in R:

OTU Table -> add sample IDs -> split dx from OTU columns -> write DeepMicro features + labels -> transpose OTUs to rows and write the QIIME2 TSV + metadata -> (in terminal) biom convert -> qiime tools import to qza

For a simple analysis, you can use the otu-small.csv file from the MikropML GitHub, which is a smaller dataset. To use that for a short analysis, copy it to your directory and change the file path in the data_prep.R file, which has the code I used to format the data for the other two tools.

## How to Run Each Tool
Now that our data is formatted correctly, we can run our analyses. I will be using the Random Forest Classifier with all of the tools, as I thought it would be best for analyzing microbiome data.
### Mikropml
The code to run an analysis with Mikropml is in the mikropml_script.R file. Again, adjust the file path to that of the otu-small.csv file and then run the file in R, or in the terminal using: Rscript mikropml/run_mikropml.R

### DeepMicro
DeepMicro recommends doing these analyses within a separate conda environment, so make sure that conda environment is active first. DeepMicro already has a Python file within its copied repository titled DM.py. The files from the data prep step will be labeled UserDataOTU.csv and UserLabelOTU.csv; move these into DeepMicro's data subdirectory. You can then run the following code in the terminal:

```
python DM.py \
    -r 5 \
    -cd UserDataOTU.csv \
    -cl UserLabelOTU.csv \
    --ae \
    -dm 32 \
    -m rf
```

-r 5 runs 5 repetitions of the analysis. --ae -dm 32 implements the autoencoders, using shallow autoencoders and reducing the dimensions to 32 learned dimensions before random forest classification.

### QIIME2

Again, make sure QIIME's conda environment is active for these analyses. Following the steps in the data formatting step should leave you with the two files needed for QIIME: one called qiime2_feature_table.qza and qiime2_metadata.csv. To run QIIME2-sample-classifier, run the following code in the terminal: 

```
qiime sample-classifier classify-samples \
    --i-table "qiime2_feature_table.qza" \
    --m-metadata-file "qiime2_metadata.tsv" \
    --m-metadata-column "$dx" \
    --p-estimator RandomForestClassifier \
    --p-n-estimators 500 \
    --p-test-size 0.20 \
    --p-cv 5 \
    --p-random-state 123 \
    --p-n-jobs 8 \
    --output-dir "YOURPATHHERE"
```

This runs the sample-classifier tool with the same parameters that we have run the rest of the tools on.
