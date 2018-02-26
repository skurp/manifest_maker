## William Connell
## 2017-08
## GuideSeq manifest YAML maker

## Hoffman2 dependencies:
## module load python/2.7.3
## module load bwa
## module load bedtools/2.23.0

# Check if packages are installed, if not, install ------------------------
list.of.packages <- c("yaml", "data.table", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# ------------------------------------------------------------------------
library(yaml)
library(data.table)
library(dplyr)

csv_path <- readline("What is the path and filename of the csv containing samples and indices?")
index <- read.csv(csv_path, col.names = c('name', 'p5_index','p7_index','target'))

# Method ----------------------------------------------------------------
index.df <- data.frame(name = as.character(index$name),
                       target = as.character(index$target),
                       barcode1 = as.character(index$p7_index),
                       barcode2 = as.character(index$p5_index),
                       description = as.character(index$name))
index.df$target <- as.character(index.df$target)
index.df$target <- ifelse(index.df$target != '', paste0(index.df$target, 'NGG'), '')

out <- as.yaml(list(samples=split(replace(index.df, "name", NULL), index.df$name)))
cat(out)

# header -----------------------------------------------------------------
reference_head <- c('reference_genome: /u/project/dkohn/wconnell/kohn/projects/guideseq/run/reference/Homo_sapiens_assembly19.fasta\n')

# get the output file location from user
output_loc <- readline('What is the output folder name of this experiment?     ')
output_head <- paste0('output_folder: ./output/', output_loc, '\n')

# get the location of fastq files from user
undemultiplexed_path <- c('/u/project/dkohn/wconnell/kohn/globus/')
forward <- paste0('/u/project/dkohn/wconnell/kohn/globus/', readline('What is the folder and file name of the forward (R1) read fastq? (e.g. MiSeq4/K562-Guideseq-VEGF-EMX1_S1_L001_R1_001.fastq.gz)     '))
rev <- paste0('/u/project/dkohn/wconnell/kohn/globus/', readline('What is the folder and file name of the reverse (R2) read fastq? (e.g. MiSeq4/K562-Guideseq-VEGF-EMX1_S1_L001_R2_001.fastq.gz)     '))
index1 <- paste0('/u/project/dkohn/wconnell/kohn/globus/', readline('What is the folder and file name of the index1 (I1) read fastq? (e.g. MiSeq4/K562-Guideseq-VEGF-EMX1_S1_L001_I1_001.fastq.gz)     '))
index2 <- paste0('/u/project/dkohn/wconnell/kohn/globus/', readline('What is the folder and file name of the index2 (I2) read fastq? (e.g. MiSeq4/K562-Guideseq-VEGF-EMX1_S1_L001_I2_001.fastq.gz)     '))

# paste the header together
header <- paste0(reference_head,
                 output_head,
                 '\nbwa: bwa\nbedtools: bedtools\n\ndemultiplexed_min_reads: 1000',
                 '\n\nundemultiplexed:\n    forward: ', forward, '\n',
                 '    reverse: ', rev, '\n',
                 '    index1: ', index1, '\n',
                 '    index2: ', index2, '\n',
                 '\n'
                 )

# concatenate the header
cat(header)
# paste the header and samples together
final <- paste0(header, out)
# concatenate the final yaml
cat(final)
# write it out to location
filename <- readline('What would you like to call this file?     ')
write(final, filename)
