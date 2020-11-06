library(tidyverse)
library(readr)
library(janitor)


icpms <- read_csv("~/Chem313/313_IPCMS_Lab/Data/ICPMS_Data.csv", skip = 1, na = "N/A") %>%
  select(-X)

key <- read_csv("~/Chem313/313_IPCMS_Lab/Data/Sample_Key.csv", skip = 0) %>%
  rename(Sample_Key = "Sample Key")

RSD_data <- icpms %>%
  select(Cr52 = CPS.RSD,
         Cr53 = CPS.RSD.1,
         As75 = CPS.RSD.2, 
         Cd111 = CPS.RSD.3,
         Cd114 = CPS.RSD.4, 
         Pb208 = CPS.RSD.5, 
         Ge_RSD = CPS.RSD.7,
         Sample_Key = Sample.Key) %>%
  pivot_longer(1:6, names_to = "metal",
               values_to = "RSD")

icpms_tidy <- icpms %>%
  select(Cr52 = CPS.RSD,
         Cr53 = CPS.RSD.1,
         As75 = CPS.RSD.2, 
         Cd111 = CPS.RSD.3,
         Cd114 = CPS.RSD.4, 
         Pb208 = CPS.RSD.5, 
         Ge72 = CPS.RSD.7,
         Sample_Key = Sample.Key) %>%
  pivot_longer(1:6, names_to = "metal",
               values_to = "CPS") %>%
  mutate(RSD = RSD_data$RSD/RSD_data$Ge_RSD,
         CPS = CPS/Ge72) %>% #ISTD correction
    select(-Ge72)

all(RSD_data$Sample_Key==icpms_tidy$Sample_Key, RSD_data$metal==icpms_tidy$metal)

icpms_merge <- merge(icpms_tidy, key)%>%
  clean_names()
write_csv(icpms_merge, "~/Chem313/313_IPCMS_Lab/Data/icpms_merge.csv")
