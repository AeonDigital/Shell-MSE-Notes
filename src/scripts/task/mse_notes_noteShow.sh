#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Mostra na tela o conteúdo completo de uma nota de id indicado.
#
# @param string $1
# Id da nota alvo que será mostrada.
mse_notes_noteShow() {
  local mseNoteId=$(mse_str_pad "${1}" "0" "6" "l")

  declare -a mseAllNoteFiles=()
  IFS=$'\n'
  mseAllNoteFiles=($(find "${MSE_NOTES_DIRECTORY["notesDir"]}" -type f -name "*_${mseNoteId}" 2> /dev/null | sort))
  IFS=$' \t\n'

  if [ "${#mseAllNoteFiles[@]}" == 0 ]; then
    mse_inter_showError "ERR::${lbl_err_noteRemove_idNotFound}"
  else
    local mseNoteFilePath="${mseAllNoteFiles[0]}"

    if [ ! -f "${mseNoteFilePath}" ]; then
      mse_inter_showError "ERR::${lbl_err_noteShow_cannotFind}"
    else
      local mseNoteContent=$(< "${mseNoteFilePath}")

      eval printf "=%.0s" {1..$MSE_NOTES_INTERFACE_RULER_LENGTH}
      printf "\n${mseNoteContent}\n"
      eval printf "=%.0s" {1..$MSE_NOTES_INTERFACE_RULER_LENGTH}
      printf "\n"
    fi
  fi
}
MSE_GLOBAL_CMD["notes note show"]="mse_notes_noteShow"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_noteShow_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=1
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="NoteId :: r :: int"
}
