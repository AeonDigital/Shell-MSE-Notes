#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Edita um item existente.
#
# @param string $1
# Id do item que será editado.
#
# @param string $2
# Descrição do item.
#
# @param status $3
# [opcional]
# Informa o status atual do item.
# Se não for definido, por padrão, definirá este valor como
# "open". As opções válidas são apenas "open" e "closed".
#
# @param datetime $4
# [opcional]
# Informa o dia e hora em que o item foi adicionado.
# Se não for definido, usará a data e hora pré-existente no registro.
# Se definido, deve usar o formato "YYYY-MM-DD HH:MM:SS"
# Use o valor "now" para pegar a data e hora de hoje.
#
# @param datetime $5
# [opcional]
# Informa o dia e hora em que o item foi concluído.
# Se definido, deve usar o formato "YYYY-MM-DD HH:MM:SS"
# Use o valor "now" para pegar a data e hora de hoje.
# Caso o status do item não seja "closed", este valor será
# ignorado.
mse_notes_topicItemEdit() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseNewLine=$(mse_notes_topicItemCreateLine "${1}" "" "${2}" "${3}" "${4}" "${5}")

    if [ "${mseNewLine}" == "" ]; then
      mse_inter_showError "ERR::${MSE_NOTES_ITEM_ERROR_MSG}"
      MSE_NOTES_ITEM_ERROR_MSG=""
    else
      mse_str_split "${MSE_NOTES_ITEM_META_SEPARATOR}" "${mseNewLine}"

      local mseMetaLine="${MSE_GLOBAL_MODULE_SPLIT_RESULT[0]}"
      local mseDataLine="${MSE_GLOBAL_MODULE_SPLIT_RESULT[1]}"

      mse_str_split "${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}" "${mseMetaLine}" "0" "1"
      local mseTopicName="${MSE_GLOBAL_MODULE_SPLIT_RESULT[0]}"
      local mseLineNumber="${MSE_GLOBAL_MODULE_SPLIT_RESULT[1]}"

      local mseTargetTopicFile="${MSE_NOTES_DIRECTORY["topicsDir"]}/${mseTopicName}"


      declare -a mseContent=("${mseDataLine}")
      local mseReturn=$(mse_file_write "${mseTargetTopicFile}" "mseContent" "r" "${mseLineNumber}")

      if [ "${mseReturn}" != "1" ]; then
        mse_inter_showError "ERR::${mseReturn}"
      else
        mse_inter_showAlert "s" "${lbl_success_itemEdit}"
      fi
    fi
  fi
}
MSE_GLOBAL_CMD["notes topic item edit"]="mse_notes_topicItemEdit"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_topicItemEdit_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=5
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="Id :: r :: int"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="Description :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2"]="Status :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2_labels"]="o, c"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2_values"]="open, closed"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_3"]="RegisterDate :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_4"]="CloseDate :: o :: string"
}
