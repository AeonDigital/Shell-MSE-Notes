#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Verifica todos os tópicos existentes para o diretório atualmente
# aberto e redefine os itens do array "MSE_NOTES_TOPICS".
mse_notes_redefineTopicList() {
  unset MSE_NOTES_TOPICS
  declare -gA MSE_NOTES_TOPICS=()

  #
  # Resgata todos os arquivos de tópicos existentes no diretório aberto
  declare -a mseTmpTopicFiles=()
  IFS=$'\n'
  mseTmpTopicFiles=($(find "${MSE_NOTES_DIRECTORY["topicsDir"]}" -maxdepth 1 -type f -not -path "*/.*" 2> /dev/null))
  IFS=$' \t\n'

  local mseKey=""
  local mseValue=""

  for mseFilePath in "${mseTmpTopicFiles[@]}"; do
    mseKey="${mseFilePath##*/}"
    mseValue=$(head -n 1 "${mseFilePath}")
    MSE_NOTES_TOPICS[${mseKey}]="${mseValue}"
  done
}
