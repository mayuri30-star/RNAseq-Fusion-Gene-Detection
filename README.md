# RNAseq-Fusion-Gene-Detection
The Project is about Fusion gene detection from RNA-seq data using Bowtie2 and Arriba on GEO dataset GSE241942

# RNA-seq Fusion Gene Detection Pipeline

## Overview

This repository provides a workflow for identifying fusion genes from paired-end RNA-seq data.

Fusion genes arise due to chromosomal rearrangements such as translocations, inversions, and deletions, and are important biomarkers in many cancers.

This project demonstrates an RNA-seq based fusion detection workflow using publicly available sequencing data from GEO.

---

## Objectives

- Download RNA-seq data from GEO
- Align reads to the reference genome
- Detect fusion genes
- Summarize recurrent fusion events
- Study potential driver fusion genes

---

## Dataset

GEO Accession

GSE241942

Example RNA-seq samples

SRR25814460

SRR25814471

SRR25814475

---

## Workflow

FASTQ files

↓

Quality Control

↓

Genome Alignment (Bowtie2)

↓

SAM → BAM

↓

Sorting & Indexing

↓

Fusion Detection (Arriba)

↓

Fusion Summary

---

## Tools Used

- Bowtie2
- SAMtools
- Arriba
- SRA Toolkit

---

## Repository Structure

scripts/

FOMB_Project_Script.sh

script_TF_full.sh

results/

sample_fusion_predictions.tsv

sample_fusion_report.pdf

docs/

Project Presentation

---

## Running

Clone repository

```bash
git clone https://github.com/yourusername/RNAseq-Fusion-Gene-Detection.git
```

Run

```bash
bash scripts/FOMB_Project_Script.sh
```

---

## Expected Output

- Fusion predictions
- Fusion report
- Candidate fusion genes
- Summary tables

---

## Example Results

The pipeline detected recurrent fusion events involving several genomic regions.

Common observations

- Translocations
- Read-through events
- Intergenic fusions
- Candidate driver fusion genes

---

## Future Improvements

- Replace Bowtie2 with STAR for splice-aware alignment
- Add FastQC and MultiQC
- Automate reference genome download
- Generate interactive fusion summary reports

---

## Authors

Mayuri Dhakane
