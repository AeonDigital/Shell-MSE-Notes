#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Marca o item de Id informado como encerrado.
#
# @param int $1
# Id do item que será dado como encerrado
mse_notes_topicClose() {
  mse_notes_topicItemEdit "${1}" "" "c" "" "now"
}
MSE_GLOBAL_CMD["notes topic item close"]="mse_notes_topicClose"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_topicClose_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=1
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="Id :: r :: int"
}
