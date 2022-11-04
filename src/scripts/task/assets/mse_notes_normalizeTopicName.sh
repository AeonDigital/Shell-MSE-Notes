#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Padroniza o nome do tópico performando na string original as alterações
# necessárias para que ela mantenha um padrão válido.
#
# @param string $1
# Nome do tópico que será normalizado.
mse_notes_normalizeTopicName() {
  local mseTopicName=$(mse_str_toLower "${1}")

  mseTopicName=$(mse_str_trim "${mseTopicName:0:32}")
  mseTopicName=$(mse_str_replace " " "_" "${mseTopicName}")
  mseTopicName=$(mse_str_replace "|" "_" "${mseTopicName}")
  mseTopicName=$(mse_str_replace ":" "_" "${mseTopicName}")

  printf "${mseTopicName:0:32}"
}