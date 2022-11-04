#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Remove completamente a nota de Id indicado.
#
# @param string $1
# Id da nota alvo que será excluída.
mse_notes_noteRemove() {
  local mseNoteId=$(mse_str_pad "${1}" "0" "6" "l")

  declare -a mseAllNoteFiles=()
  IFS=$'\n'
  mseAllNoteFiles=($(find "${MSE_NOTES_DIRECTORY["notesDir"]}" -type f -name "*_${mseNoteId}" 2> /dev/null | sort))
  IFS=$' \t\n'

  if [ "${#mseAllNoteFiles[@]}" == 0 ]; then
    mse_inter_showError "ERR::${lbl_err_noteRemove_idNotFound}"
  else
    local mseNoteFilePath="${mseAllNoteFiles[0]}"
    rm "${mseNoteFilePath}"

    if [ $? != 0 ]; then
      mse_inter_showError "ERR::${lbl_err_noteRemove_cannotRemoveDate}"
    else
      mse_inter_showAlert "s" "${lbl_success_noteRemove}"
    fi
  fi
}
MSE_GLOBAL_CMD["notes note remove"]="mse_notes_noteRemove"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_noteRemove_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=1
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="NoteId :: r :: int"
}
