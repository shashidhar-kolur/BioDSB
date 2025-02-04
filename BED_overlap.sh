#!/bin/bash 

#SBATCH -p bio-ds                                   # Specifying the bio-ds partition
#SBATCH --qos=bio-ds                                # User group gives you access to bio-ds partition
#SBATCH --time=0-1                                  # Time limit of 1 hour
#SBATCH --mem=4G                                    # Memory limit of 4Gb
#SBATCH --job-name=BED_overlap                      # Job name
#SBATCH -o /gpfs/home/rpr23sxu/scratch/Teaching/BED_overlap/Output_Messages/BED_overlap.out   # Output file
#SBATCH -e /gpfs/home/rpr23sxu/scratch/Teaching/BED_overlap/Error_Messages/BED_overlap.err    # Error file
#SBATCH --mail-type=ALL                             # Send email on job start, end, and abort
#SBATCH --mail-user=rpr23sxu@uea.ac.uk              # Email address

# Load bedtools module on HPC
module load bedtools

# Define the input BED files
file1="/gpfs/home/rpr23sxu/scratch/Teaching/BED_overlap/DPure_indels_mask.bed"
file2="/gpfs/home/rpr23sxu/scratch/Teaching/BED_overlap/LPure_indels_mask.bed"

# Define the output directory
output_dir="/gpfs/home/rpr23sxu/scratch/Teaching/BED_overlap/output"

# Ensure input files are sorted for like-to-like comparison of Method 1 and Method 2
sorted_file1="$output_dir/sorted_file1.bed"
sorted_file2="$output_dir/sorted_file2.bed"
sort -k1,1 -k2,2n $file1 > $sorted_file1
sort -k1,1 -k2,2n $file2 > $sorted_file2

# Lesson 1: Finding Overlapping Regions

# Method 1a-d: Using basic Unix commands with different columns
comm -12 <(cut -f1 $sorted_file1) <(cut -f1 $sorted_file2) > $output_dir/overlapping_regions_unix_1.bed
comm -12 <(cut -f1-2 $sorted_file1) <(cut -f1-2 $sorted_file2) > $output_dir/overlapping_regions_unix_2.bed
comm -12 <(cut -f1-3 $sorted_file1) <(cut -f1-3 $sorted_file2) > $output_dir/overlapping_regions_unix_3.bed
comm -12 <(cut -f1-4 $sorted_file1) <(cut -f1-4 $sorted_file2) > $output_dir/overlapping_regions_unix_4.bed

# Method 2a: Using bedtools with default settings
bedtools intersect -a $sorted_file1 -b $sorted_file2 > $output_dir/overlapping_regions.bed

# Method 2b: Using bedtools with more restrictive settings
bedtools intersect -a $sorted_file1 -b $sorted_file2 -f 0.5 -r > $output_dir/overlapping_regions_restrictive.bed

# Generate a summary of the number of common features found by each method
echo "Number of common features found by each method:" > $output_dir/comparison_summary.txt
echo "Unix method (chromosome only): $(wc -l < $output_dir/overlapping_regions_unix_1.bed)" >> $output_dir/comparison_summary.txt
echo "Unix method (chromosome and start position): $(wc -l < $output_dir/overlapping_regions_unix_2.bed)" >> $output_dir/comparison_summary.txt
echo "Unix method (chromosome, start and end position): $(wc -l < $output_dir/overlapping_regions_unix_3.bed)" >> $output_dir/comparison_summary.txt
echo "Unix method (chromosome, start, end position, and feature name): $(wc -l < $output_dir/overlapping_regions_unix_4.bed)" >> $output_dir/comparison_summary.txt
echo "BEDTools default method: $(wc -l < $output_dir/overlapping_regions.bed)" >> $output_dir/comparison_summary.txt
echo "BEDTools restrictive method: $(wc -l < $output_dir/overlapping_regions_restrictive.bed)" >> $output_dir/comparison_summary.txt

# Supplemental annotation:
# Biology is complicated, and professional software 
# developers have spent a lot of time building 
# specialised software for us, which perform complicated 
# tasks, efficiently, and with careful regard for the 
# complexity of molecular biology. 

# It would be very challenging to design a Unix-based
# method that could replicate the functionality of
# bedtools intersect. The Unix-based methods in this
# script are simple and illustrative, but they are not
# replacements for bedtools intersect. You could 
# design increasingly more complicated Unix-based
# methods, but why? 

# Also, there's a deeper lesson in this example...

# The default BEDTools intersect method identifies that  
# position 211000022278098 (row 6 in sorted_file1.bed 
# and row 5 in sorted_file2.bed) is in common between 
# the two BED files, however, they have different 
# start and end positions (the feature in 
# sorted_file1.bed being shorter). The outcome of 
# this detail by BEDTools was to retain the shorter 
# of the two features as a common feature since it 
# represents a shared stretch of DNA sequence between 
# the two, but the outcome of our Unix-based methods 
# is to exclude that as a common feature because they 
# are, after all, different (one longer than the other). 
# Your journey has shown you that you're not quite sure 
# what you're looking for. 

# None of the methods above are necessarilyy right or 
# wrong; rather, the word "overlap" is ambiguous. 
# What do you actually want? Maybe your supervisor, 
# who asked for the "overlap" doesn't quite understand 
# what they want either. :-) Go back to them with a .txt 
# file like the one output by this script and explain it 
# to them and get on the same page before moving forward.
