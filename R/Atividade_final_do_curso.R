
# Carrega library

library(tidyverse)
library(ggplot2)

# Carrega a base pokemon

pokemon <- readr::read_rds("data/pokemon.rds")

# Objetivo; Identificar a evolução dos pokemons ao longo das gerações para ver se
# estão sendo criados pokemons mais OPs conforme o tempo passa
# Será utilizado três atributos para medir isso hp, defesa, ataque
# Para realizar tal comparação será feita a media desses casos e depois eles comparados por meio de um grafico


pokemon_1 <- pokemon %>%
  filter(!is.na(id_geracao), tipo_1 %in% list("fogo", "grama", "água", "elétrico", "pedra")) %>%
  select(-tipo_2) %>%
  rename ( tipo = tipo_1)

pokemon_2 <- pokemon %>%
  filter(!is.na(id_geracao), tipo_2 %in% list("fogo", "grama", "água", "elétrico", "pedra")) %>%
  select(-tipo_1) %>%
  rename ( tipo = tipo_2)


pokemon_3 <- pokemon_1 %>%
  bind_rows(pokemon_2) %>%
  group_by(id_geracao, tipo) %>%
  summarise(across(
    .cols = c(hp, ataque, defesa),
    .fns = mean
      )) %>%
  ungroup() %>%
  pivot_longer(names_to = "Atributos",
               cols = c(hp, ataque, defesa))

save(pokemon_3, file = "data/pokemon_3.rda")

load("data/pokemon_3.rda")

ggplot(data = pokemon_3, aes(x = id_geracao, y = value, color = tipo),
       xlab = "Geração", title = "Média dos Atributos por Geração") +
  geom_line() +
  geom_point(size = 1.5) +
  scale_color_manual(values=c("blue", "#ede732","red", "#029e04", "#75440b")) +
  facet_wrap(~Atributos) +
  labs(
    title = "Atributos por Geração",
    x = "Geração",
    y = "Valores dos Atributos",
    color = "Tipo"
  ) +
  scale_x_continuous(breaks = c(1, 2, 3, 4 ,5 ,6 ,7))+
  theme(
        legend.position = "bottom",
    panel.background = element_rect(fill = "grey"),
    panel.grid.minor.x = element_blank(),
    panel.grid.minor.y = element_blank())


