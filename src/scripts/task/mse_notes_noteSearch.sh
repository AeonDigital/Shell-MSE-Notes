#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Efetua uma busca entre todas as notas que correspondem às informações de
# consulta passadas e mostra o resultado na tela.
#
# @param string $1
# [opcional]
# Id da nota sendo procurada.
#
# @param date $2
# [opcional]
# Data inicial a partir da qual a consulta será feita.
# Use o formato "YYYY-MM-DD" para indicar um valor válido.
# Se não for definida, usará a data do dia de hoje.
# Se não for definida mas o parametro $1 for, usará como data o valor
# "2000-01-01" como data inicial.
#
# @param date $3
# [opcional]
# Data final até a qual a consulta será feita.
# Use o formato "YYYY-MM-DD" para indicar um valor válido.
# Se não for definida, usará a data do dia de hoje.
#
# @param string $4
# [opcional]
# Nome total ou parcial do/s tópico/s aos quais as notas
# devem pertencer.
#
# @param int $5
# [opcional]
# Id do item ao qual as notas devem estar correlacionadas.
#
# @param string $6
# [opcional]
# Período do dia.
#
# @param string $7
# [opcional]
# Palavra chave que deve estar no corpo das notas.
#
# @param bool $8
# Quando "1", retornará as linhas de dados de cada nota que deu match com o
# valor da palavra chave indicada.
mse_notes_noteSearch() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    mse_notes_noteMainSearch "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "" "${8}"

    if [ "${#MSE_NOTES_NOTE_SEARCH[@]}" == 0 ]; then
      mse_inter_showAlert "a" "${lbl_info_noteSearch_emptyResult}"
    else
      mse_inter_showAlert "a" "${lbl_info_noteSearch_foundResult}"

      printf "%s\n" "${MSE_NOTES_NOTE_SEARCH[@]}"
      printf "\n"
    fi
  fi
}
MSE_GLOBAL_CMD["notes note search"]="mse_notes_noteSearch"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_noteSearch_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=8
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="NoteId :: o :: int"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="DateFrom :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2"]="DateTo :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_3"]="TopicName :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_4"]="ItemId :: o :: int"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_5"]="DayPeriod :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_6"]="KeyWord :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_7"]="ShowMatchLines :: o :: bool"
}
