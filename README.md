## Analysis of yeast base editors for mutagenesis
 
This repository contains scripts and data for analysis of sequencing data from **Skrekas et al. 2022**.

- Last update: 2022-02-14

This repository is administered by Angelo Limeta (@angelolimeta), Division of Systems and Synthetic Biology, Department of Biology and Biological Engineering, Chalmers University of Technology.

### NGS data processing and analysis

Illumina reads from the mutagenesis experiments have been processed through a [Snakemake](https://snakemake.github.io/) based pipeline in order to detect and tally up rare variants.
In brief, the pipeline consists of the following steps:
- Merging of perfectly complimentary paired-end reads using [NGmerge](https://github.com/jsh58/NGmerge)
- Alignment to reference using the burrows-wheeler aligner
- Ultradeep pileup of reads using BCFtools

The pipeline can be run locally on a computer with enough RAM / storage. The pileup step is the most resource intensive and time consuming. When running the pipeline on a 2018 MacBook Pro (16Gb RAM, 2,3 GHz Quad-Core Intel Core i5) it took approximately 2-3h in order to fully process the data included in this repository.

**How to re-run the pipeline:**

Clone the repository.

Activate the conda environment (**environment.yml**) file included in this repo:

```bash
conda env create -f environment.yml
conda activate BE-VCF
```

Modify the paths for the data (raw Illumina reads) and template sequence files in the **Snakefile** and Snakemake config file (**config.yaml**).

Navigate to the directory containing the files and run the pipeline:
```bash
cd /path/to/Base-Editors-Yeast
nohup snakemake &
```

The pipeline wiil produce an output file of detected variants across samples in VCF format.

**Analysis scripts**

In case you don't want to re-run the actual pipeline, processed data and R markdown scripts for visualizing the output are available in the NGS_data and NGS_scripts folders, respectively. A knitted version of the visualization script is also available in the NGS_scripts folder.

### Sanger data processing and analysis

Data and R markdown scripts for visualizing the alignment files from sanger sequencing are available in the sanger_data and sanger_scripts folders, respectively.


