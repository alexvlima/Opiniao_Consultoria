library(tidyverse)
library(readxl)

df <- read_excel('Basico_PE.xls')
glimpse(df)

df_urb <- 
  df %>%
  filter(Cod_municipio == 2611606,
         Situacao_setor == 1)

glimpse(df_urb)

flag <- sample(1:nrow(df_urb), size = 38)

setores <- df_urb[flag,]

write.csv2(setores, 'setores.csv', 
           row.names = FALSE)

flag2 <- sample(1:nrow(df_urb), size = 50)
reposicao <- df_urb[flag2,]

write.csv2(reposicao, 'reposicao.csv', 
           row.names = FALSE)
