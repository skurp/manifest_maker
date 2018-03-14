## Will Connell
## 2018.03.05
## Remove unnsuccessfully demultiplexed samples from sample list
## UNIX command: find . -name ".r1.fastq" >> demux.txt

# Check if packages are installed, if not, install ------------------------
list.of.packages <- c("dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# ------------------------------------------------------------------------
library(dplyr)
# ------------------------------------------------------------------------

# User input paths to files
success_demux <- readline('Provide the relative path to where the list of successfully demultiplexed samples is located:     ')
csv_path <- readline('What is the relative path to the original csv containing sample info?     ')
# Read in files
index2 <- read.csv(csv_path, col.names = c('name', 'p5_index','p7_index','target'))
demux2 <- read.table(success_demux, col.names = c('sample'))

# clean up original sample names
index2.df <- data.frame(name = as.character(index2$name),
                       p5_index = as.character(index2$p5_index),
                       p7_index = as.character(index2$p7_index),
                       target = as.character(index2$target))
index2.df$target <- as.character(index2.df$target)

# clean up sample names that were able to demultiplex
demux2$edit <- gsub(pattern = "./", replacement = "", x = demux2$sample)
demux2$name <- gsub(pattern = ".r1.fastq", replacement = "", x=demux2$edit)
demux2$sample <- NULL
demux2$edit <- NULL

# will perform join by 'name' column automatically
# saves list of successfully demultiplexed samples
revised_sample <- semi_join(index2.df, demux2)

# output a list of the samples that did not demultiplex
print('Samples that failed to demultiplex:')
fail_demux <- anti_join(index2.df, demux2)
print(fail_demux$name)

# save new sample list
new_revised_sample_csv <- readline("Provide new file path and .csv name which will contain the revised sample list:     ")
write.csv(x = revised_sample, file = new_revised_sample_csv, col.names = TRUE, row.names = FALSE)
print('Completed generating new sample csv list.')

