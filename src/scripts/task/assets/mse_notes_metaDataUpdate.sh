#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Permite atualizar alguma informação contida no arquivo ".meta" do diretório
# que está atualmente sendo usado.
#
# @param string $1
# Nome do atributo que será alterado.
# Por padrão, exceto em casos excepcionais, cada linha do arquivo ".meta"
# é responsável por armazenar o valor atual de uma propriedade de controle.
#
# Os seguintes valores são opções válidas para configuração:
# - nextItemId
# - nextNoteId
#
# @param string $2
# [opcional]
# Se definido, deve indicar um valor válido para o atributo indicado.
mse_notes_metaDataUpdate() {
  local nextItemId="${MSE_NOTES_DIRECTORY["nextItemId"]}"
  local nextNoteId="${MSE_NOTES_DIRECTORY["nextNoteId"]}"


  case "$1" in
    "nextItemId")
      ((nextItemId = nextItemId + 1))
      if [ "${2}" != "" ] && [ $(mse_check_isInteger "${2}") == 1 ]; then
        nextItemId="${2}"
      fi
      MSE_NOTES_DIRECTORY["nextItemId"]="${nextItemId}"
    ;;

    "nextNoteId")
      ((nextNoteId = nextNoteId + 1))
      if [ "${2}" != "" ] && [ $(mse_check_isInteger "${2}") == 1 ]; then
        nextNoteId="${2}"
      fi
      MSE_NOTES_DIRECTORY["nextNoteId"]="${nextNoteId}"
    ;;
  esac


  local mseMetaContent="${nextItemId}\n${nextNoteId}"
  printf "${mseMetaContent}" > "${MSE_NOTES_DIRECTORY["metaFile"]}"
}