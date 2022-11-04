#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Faz uma listagem das notas conforme o critério de amostragem.
#
# @param int $1
# Indica quantos dias para traz, incluíndo hoje que as notas devem ser
# amostradas na listagem.
# Se vazio, usará o valor "0", mostrando assim apenas o dia de hoje.
#
# @param date $2
# [opcional]
# Data inicial a partir da qual as notas serão mostradas.
# Use o formato "YYYY-MM-DD" para indicar um valor válido.
# Se o primeiro parametro for definido, este será ignorado.
#
# @param date $3
# [opcional]
# Data final até a qual a consulta será feita.
# Use o formato "YYYY-MM-DD" para indicar um valor válido.
# Se o primeiro parametro for definido, este será ignorado.
#
# @param string $4
# Nome total ou parcial do/s tópicos/s aos quais as notas
# devem pertencer.
#
# @param string $5
# [opcional]
# Palavra chave que deve estar no corpo das notas.
mse_notes_noteList() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseNow=$(date "+%Y-%m-%d")

    local mseDaysBack=$(mse_str_trim "${1}")
    local mseDateFrom="${2}"
    local mseDateTo="${3}"

    if [ "${mseDaysBack}" == "" ]; then
      if [ "${mseDateFrom}" == "" ]; then
        mseDateFrom="${mseNow}"
      fi
      if [ "${mseDateTo}" == "" ]; then
        mseDateTo="${mseNow}"
      fi
    else

      local mseCheckInteger=$(mse_check_isInteger "${mseDaysBack}")
      if [ "${mseCheckInteger}" == "0" ]; then
        mseDaysBack="0"
      fi

      mseDaysBack=$(expr "${mseDaysBack}" + 0)
      mseDateFrom=$(date --date="${mseNow} - ${mseDaysBack} day" +%Y-%m-%d)
      mseDateTo="${mseNow}"
    fi


    mse_notes_noteSearch "" "${mseDateFrom}" "${mseDateTo}" "${4}" "" "" "${5}"
  fi
}
MSE_GLOBAL_CMD["notes note list"]="mse_notes_noteList"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_noteList_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=4
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="DaysBack :: o :: int :: 0"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="DateFrom :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2"]="DateTo :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_3"]="TopicName :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_4"]="KeyWord :: o :: string"
}
