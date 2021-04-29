############
### PATH ###
############

# getwd()
setwd("/Users/alexvlima/Downloads")

#################
### LIBRARIES ###
#################

library(sidrar)
library(tidyverse)

###############
### DATASET ###
###############

x <- c(seq(from = 6573, to = 6642, by = 1), seq(from = 6656, to = 6659, by = 1), 49110)
idade <- paste(x, collapse = ",")

api <- paste0("/t/7358/n3/all/c2/all/c287/",idade,"/c1933/49037")

pop_ibge_2021 <- get_sidra(api = api)
glimpse(pop_ibge_2021)

# rm(x, idade, api)

api <- "/t/6579/n6/all"
pop_ibge_mun_2020 <- get_sidra(api = api)
glimpse(pop_ibge_mun_2020)

# rm(api)

#################
### POPULACAO ###
#################

pop_ibge_2021 <- 
  pop_ibge_2021 %>%
  select(UF = `Unidade da Federação (Código)`, NOME_UF = `Unidade da Federação`,
         SEXO = Sexo, IDADE = Idade, POP = Valor) %>%
  filter(SEXO != "Total", IDADE != "Total")


pop_ibge_2021$REGIAO <- substr(pop_ibge_2021$UF,1,1)
pop_ibge_2021$IDADE <- as.numeric(substr(pop_ibge_2021$IDADE,1,2))
pop_ibge_2021$FAIXA_ET <- cut(pop_ibge_2021$IDADE, 
                              breaks = c(15,24,34,44,54,64,91),
                              labels = c("16 a 24 anos","25 a 34 anos","35 a 44 anos",
                                         "45 a 54 anos","55 a 64 anos","65 anos ou mais"))


populacao <- 
  pop_ibge_2021 %>%
  mutate(REGIAO = factor(REGIAO, 
                         labels = c("Norte","Nordeste","Sudeste","Sul","Centro-Oeste"))) %>%
  group_by(REGIAO,SEXO,FAIXA_ET) %>%
  summarise(N = sum(POP))

write_csv2(x = populacao, path = "populacao.csv")

pop_ibge_mun_2020 <- 
  pop_ibge_mun_2020 %>%
  select(COD_MUN = `Município (Código)`, NOME_MUN = Município, POP = Valor)

pop_ibge_mun_2020$REGIAO <- substr(pop_ibge_mun_2020$COD_MUN,1,1)
pop_ibge_mun_2020$REGIAO <- factor(pop_ibge_mun_2020$REGIAO, 
                                   labels = c("Norte","Nordeste","Sudeste",
                                              "Sul","Centro-Oeste"))

pop_ibge_mun_2020$TAM_MUN <- cut(pop_ibge_mun_2020$POP, 
                              breaks = c(0,50000,200000,500000,20000000),
                              labels = c("Ate 50 mil hab.","De 50 mil a 200 mil hab.",
                                         "De 200 mil a 500 mil hab.",
                                         "Acima de 500 mil hab."))


write_csv2(x = pop_ibge_mun_2020, path = "populacao_municipio.csv")
