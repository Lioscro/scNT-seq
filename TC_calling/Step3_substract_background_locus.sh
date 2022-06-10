#!/bin/bash

## This script excludes the locus which has T->C mutations in control sample

## Pre-install requirment: sam2tsv, samtools, perl

sample_tsv_dir=$1 # tsv file folder including tsv files which was generated in step2
control_tsv_dir=$2
sample=$3 # sample name with TFEA treatment
control=$4 # sample name without TFEA treatment
num_barcodes=$5
bam_dir=$6 # bam file folder including bam file which was generated in step1
out_dir=$7

scripts_root=$8

############ 1. Substract mutations from control samples
perl ${scripts_root}/background_correction.pl -bg ${control_tsv_dir}/${control}_both_strand_all_TC.tsv_q27.tsv -in ${sample_tsv_dir}/${sample}_both_strand_all_TC.tsv_q27.tsv

mv ${sample_tsv_dir}/${sample}_both_strand_all_TC.tsv_q27.tsv_corrected.tsv ${out_dir}/${sample}_both_strand_all_TC.tsv_q27.tsv_corrected.tsv
mv ${sample_tsv_dir}/${sample}_both_strand_all_TC.tsv_q27.tsv_discard.tsv ${out_dir}/${sample}_both_strand_all_TC.tsv_q27.tsv_discard.tsv

############ 2. Add mutation information back to bam files
perl ${scripts_root}/TagIntronicRead_V5.pl -read ${out_dir}/${sample}_both_strand_all_TC.tsv_q27.tsv_corrected.tsv -bam ${bam_dir}/${sample}_starAligned.sorted.merged.GeneExonTagged.TagIntronic.clean.${num_barcodes}.bam

mv ${sample}_starAligned.sorted.merged.GeneExonTagged.TagIntronic.clean.${num_barcodes}.TagTC.corrected.bam ${out_dir}/${sample}_starAligned.sorted.merged.GeneExonTagged.TagIntronic.clean.${num_barcodes}.TagTC.corrected.bam

### In the end you will get a bam file with "GE:Z:genename--T" or "GE:Z:genename--C" tags. 
### The file format is "${sample}_starAligned.sorted.merged.GeneExonTagged.TagIntronic.clean.${num_barcodes}.TagTC.corrected.bam"



