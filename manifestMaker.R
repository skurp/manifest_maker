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


# # Method 1 ----------------------------------------------------------------
# index.table <- data.table(name = as.character(index$name),
#                           target = as.character(index$target),
#                           barcode1 = as.character(index$p5_index),
#                           barcode2 = as.character(index$p7_index),
#                           description = as.character(index$name))
# 
# index.yaml <- index.table %>%
#   split(by = "name") %>%
#   lapply(function(x) x[,name := NULL] %>% .[]) %>% 
#   list(samples = .) %>% 
#   as.yaml
# 
# cat(index.yaml)
# 
# write(index.yaml, "manifest.yaml")
# 

# Method 2 ----------------------------------------------------------------
index.df <- data.frame(name = as.character(index$name),
                       target = as.character(index$target),
                       barcode1 = as.character(index$p7_index),
                       barcode2 = as.character(index$p5_index),
                       description = as.character(index$name))
index.df$target <- as.character(index.df$target)
index.df$target <- ifelse(index.df$target != '', paste0(index.df$target, 'NGG'), NA)

out <- as.yaml(list(samples=split(replace(index.df, "name", NULL), index.df$name)))

cat(out)

write(out, "MiSeq4/guideSeq_MiSeq4.yaml")
