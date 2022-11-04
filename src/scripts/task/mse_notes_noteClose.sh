#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Permite "encerrar" (adicionar o horário de encerramento)
# em uma nota existente.
#
# @param string $1
# Id da nota alvo que será encerrada.
mse_notes_noteClose() {
  local mseEndHour="${2}"
  if [ "${mseEndHour}" == "" ]; then
    mseEndHour=$(date "+%H:%M")
  fi

  mse_notes_noteEdit "${1}" "" "${mseEndHour}"
}
MSE_GLOBAL_CMD["notes note close"]="mse_notes_noteClose"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_noteClose_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=2
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="NoteId :: r :: int"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="EndHour :: o :: string"
}
