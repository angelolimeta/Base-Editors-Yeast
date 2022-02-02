## Analysis of yeast base editors for mutagenesis
 
This repository contains scripts and data for analysis of sequencing data from **Skrekas et al. 2022**.

- Last update: 2022-02-02

This repository is administered by Angelo Limeta (@angelolimeta), Division of Systems and Synthetic Biology, Department of Biology and Biological Engineering, Chalmers University of Technology.

### NGS data processing and analysis

Illumina reads from the mutagenesis experiments have been processed through a Snakemake based pipeline in order to tally up rare variants.
In brief, the pipeline consists of the following steps:
- Merging of perfectly complimentary paired-end reads using [NGmerge](https://github.com/jsh58/NGmerge)
- Alignment to reference using the burrows-wheeler aligner
- Ultradeep pileup of reads using BCFtools

**How to re-run the pipeline:**

Clone the repository.

Activate the conda environment (**environment.yml**) file included in this repo:

```bash
conda env create -f environment.yml
conda activate BE-VCF
```

Modify the paths in the **Snakefile** and Snakemake config file (**config.yaml**).

Run the pipeline:
```bash
nohup snakemake &
```

The pipeline should produce an output file of detected variants in VCF format.

**Analysis scripts**

In case you don't want to re-run the actual pipeline, processed data and R markdown scripts for visualizing the output are available in the NGS_data and NGS_scripts folders, respectively. A knitted version of the visualization script is also available in the NGS_scripts folder.

### Sanger data processing and analysis

Data and R markdown scripts for visualizing the alignment files from sanger sequencing are available in the sanger_data and sanger_scripts folders, respectively.


