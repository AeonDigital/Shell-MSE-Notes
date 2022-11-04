#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Carrega o arquivo atualmente configurado para um array
# temporário 'MSE_TMP_NOTES_FILE_CONTENT'.
mse_notes_loadFileContentToArray() {
  unset MSE_TMP_NOTES_FILE_CONTENT
  declare -ga MSE_TMP_NOTES_FILE_CONTENT=()

  readarray -t MSE_TMP_NOTES_FILE_CONTENT < "${MSE_NOTES_INTERFACE_FILE}"

  local mseTotalLines="${#MSE_NOTES_FILE_CONTENT[@]}"
  if [ "${mseTotalLines}" -gt 0 ]; then
    #
    # Remove o '\n' adicionado ao final da última linha pelo comando 'readarray'
    local mseLastLineIndex="${mseTotalLines}"
    ((mseLastLineIndex = mseLastLineIndex - 1))

    MSE_TMP_NOTES_FILE_CONTENT[$mseLastLineIndex]=$(printf "${MSE_TMP_NOTES_FILE_CONTENT[$mseLastLineIndex]}" | sed 's/^\s*//g' | sed 's/\s*$//g')
  fi
}
