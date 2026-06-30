#!/bin/bash
# RNA-seq Fusion Gene Detection Pipeline
#
# Author: Mayuri Dhakane
#
# Description:
# Detect fusion genes from paired-end RNA-seq data using
# STAR aligner and Arriba.
#
# Dataset:
# GEO: GSE241942
#
# Example Samples:
# SRR25814460
# SRR25814471
# SRR25814475

set -e
set -o pipefail

# USER SETTINGS

# Number of CPU threads
THREADS=8

# Working directory
WORKDIR=$HOME/Fusion_Project

# Input/output directories
FASTQ_DIR=${WORKDIR}/fastq
STAR_INDEX=${WORKDIR}/STAR_index
RESULTS=${WORKDIR}/results
REFERENCE=${WORKDIR}/reference

# Reference files
GENOME_FASTA=${REFERENCE}/hg38.fa
ANNOTATION_GTF=${REFERENCE}/gencode.v47.annotation.gtf
BLACKLIST=${REFERENCE}/arriba_blacklist.tsv

# RNA-seq samples
SAMPLES=(
SRR25814460
SRR25814471
SRR25814475
)

# CREATE DIRECTORIES

mkdir -p ${FASTQ_DIR}
mkdir -p ${RESULTS}
mkdir -p ${REFERENCE}
mkdir -p ${STAR_INDEX}

# CHECK SOFTWARE

echo "Checking required software..."

for tool in fasterq-dump STAR samtools arriba
do
    command -v $tool >/dev/null 2>&1 || {
        echo "$tool not found."
        exit 1
    }
done

echo "All required software found."

# DOWNLOAD FASTQ FILES

echo "Downloading RNA-seq data..."

for SAMPLE in "${SAMPLES[@]}"
do

if [ ! -f ${FASTQ_DIR}/${SAMPLE}_1.fastq ]; then

echo "Downloading ${SAMPLE}"

fasterq-dump \
${SAMPLE} \
--split-files \
--threads ${THREADS} \
--outdir ${FASTQ_DIR}

fi

done

# BUILD STAR INDEX

if [ ! -f ${STAR_INDEX}/SA ]; then

echo "Generating STAR genome index..."

STAR \
--runThreadN ${THREADS} \
--runMode genomeGenerate \
--genomeDir ${STAR_INDEX} \
--genomeFastaFiles ${GENOME_FASTA} \
--sjdbGTFfile ${ANNOTATION_GTF} \
--sjdbOverhang 100

fi

# ALIGNMENT

for SAMPLE in "${SAMPLES[@]}"
do

echo "Processing ${SAMPLE}"

STAR \
--runThreadN ${THREADS} \
--genomeDir ${STAR_INDEX} \
--readFilesIn \
${FASTQ_DIR}/${SAMPLE}_1.fastq \
${FASTQ_DIR}/${SAMPLE}_2.fastq \
--outSAMtype BAM SortedByCoordinate \
--chimOutType WithinBAM HardClip \
--chimSegmentMin 10 \
--chimJunctionOverhangMin 10 \
--chimScoreDropMax 30 \
--chimScoreJunctionNonGTAG 0 \
--chimScoreSeparation 1 \
--chimSegmentReadGapMax 3 \
--outFileNamePrefix ${RESULTS}/${SAMPLE}_

# INDEX BAM

samtools index \
${RESULTS}/${SAMPLE}_Aligned.sortedByCoord.out.bam

# RUN ARRIBA
echo "Running Arriba..."

arriba \
-x ${RESULTS}/${SAMPLE}_Aligned.sortedByCoord.out.bam \
-o ${RESULTS}/${SAMPLE}_fusion.tsv \
-O ${RESULTS}/${SAMPLE}_fusion.discarded.tsv \
-a ${GENOME_FASTA} \
-g ${ANNOTATION_GTF} \
-b ${BLACKLIST}

done

# SUMMARY

echo "Pipeline Completed"

echo "Fusion prediction files:"

ls ${RESULTS}/*fusion.tsv

echo "Done."
