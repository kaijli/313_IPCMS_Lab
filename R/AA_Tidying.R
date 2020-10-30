library(tidyverse)
library(readr)
library(janitor)

aa_data <- read_csv("~/Chem313/313_IPCMS_Lab/Data/AA_Data.csv", skip = 4)

aa_tidy <- aa_data %>%
  select(Sample_Key = "Sample Key",
         Mean_Abs = "Mean Abs." ,
         RSD = "%RSD")

aa_tidy$Sample_Key[aa_tidy$Sample_Key == "check10"] <- 80
aa_tidy$Sample_Key[aa_tidy$Sample_Key == "Sample Blank"] <- 90
aa_tidy$RSD[aa_tidy$RSD == "HIGH"] <- 999.99

aa_tidy$Sample_Key<- as.numeric(aa_tidy$Sample_Key)
aa_tidy$RSD <- as.numeric(aa_tidy$RSD)

key <- read_csv("~/Chem313/313_IPCMS_Lab/Data/Sample_Key.csv", skip = 0) %>%
  rename(Sample_Key = "Sample Key")



aa_merge <- merge(key,aa_tidy)%>%
  clean_names()

saveRDS(aa_merge, file = "~/Chem313/313_IPCMS_Lab/Data/aa_merge.rds")
