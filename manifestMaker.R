## William Connell
## 2017-08
## GuideSeq manifest YAML maker

## Hoffman2 dependencies:
## module load python/2.7.3
## module load bwa
## module load bedtools/2.23.0


# ------------------------------------------------------------------------
rm(list=ls())
library(yaml)
library(data.table)
library(dplyr)

index <- read.csv("MiSeq4/MiSeq4.csv", col.names = c('name', 'p5_index','p7_index','target'))

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
output_loc <- c('xxxx')
reference_head <- c('reference genome: /u/project/dkohn/wconnell/kohn/projects/guideseq/run/reference/Homo_sapiens_assembly19.fasta\n')
output_head <- paste0('output_folder: ./output/', output_loc, '\n')

undemultiplexed_path <- c('/u/project/dkohn/wconnell/kohn/globus/')
forward <- c('fff')
rev <- c('rrr')
index1 <- c('111')
index2 <- c('222')

header <- paste0(reference_head,
                 output_head,
                 '\nbwa: bwa\nbedtools: bedtools\n\ndemultiplexed_min_reads: 1000',
                 '\nundemultiplexed:\n    forward: ', forward, '\n',
                 '    reverse: ', rev, '\n',
                 '    index1: ', index1, '\n',
                 '    index2: ', index2, '\n',
                 '\n'
                 )
cat(header)

final <- paste0(header, out)

cat(final)

write(final, "MiSeq4/test.yaml")
