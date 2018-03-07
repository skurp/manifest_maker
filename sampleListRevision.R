## Will Connell
## 2018.03.05
## Remove unnsuccessfully demultiplexed samples from sample list
## UNIX command: find . -name ".r1.fastq" >> demux.txt

# User input paths to files
success_demux <- readline('Provide the relative path to where the list of successfully demultiplexed samples is located:     ')
csv_path <- readline('What is the relative path to the original csv containing sample info?     ')
# Read in files
index2 <- read.csv(csv_path, col.names = c('name', 'p5_index','p7_index','target'))
demux2 <- read.table(success_demux, col.names = c('sample'))

# clean up original sample names
index2.df <- data.frame(name = as.character(index2$name),
                       target = as.character(index2$target),
                       barcode1 = as.character(index2$p7_index),
                       barcode2 = as.character(index2$p5_index),
                       description = as.character(index2$name))
index2.df$target <- as.character(index2.df$target)

# clean up sample names that were able to demultiplex
demux2$edit <- gsub(pattern = "./", replacement = "", x = demux2$sample)
demux2$name <- gsub(pattern = ".r1.fastq", replacement = "", x=demux2$edit)
demux2$sample <- NULL
demux$edit <- NULL

# will perform join by 'name' column automatically
revised_sample <- inner_join(index2, demux2)

new_revised_sample_csv <- readline("Provide new csv path and file name which will contain the revised sample list:     ")
write.csv(x = revised_sample, file = new_revised_sample_csv, col.names = TRUE)
print('Completed generating new sample csv list.')

