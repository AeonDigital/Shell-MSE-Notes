#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Verifica o argumento 'FileName' ($1).
# que indica o arquivo alvo da edição sendo feita.
mse_notes_checkArgFileName() {
  unset MSE_NOTES_FILE_CONTENT
  declare -ga MSE_NOTES_FILE_CONTENT=()

  #
  # Identifica se é para abrir uma nova nota ou uma existente
  if [ "$1" == "" ]; then
    MSE_NOTES_INTERFACE_FILE=""
  else
    MSE_NOTES_INTERFACE_FILE=$(realpath "$1")
    if [ -f "${MSE_NOTES_INTERFACE_FILE}" ]; then
      mse_notes_loadFileContentToArray
      MSE_NOTES_FILE_CONTENT=("${MSE_TMP_NOTES_FILE_CONTENT[@]}")
    fi
  fi
}
