#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Adiciona um novo item para um tópico.
#
# @param string $1
# Nome do tópico em que o novo item será adicionado.
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
# Se não for definido, usará a data e hora do dia de hoje.
# Se definido, deve usar o formato "YYYY-MM-DD HH:MM:SS"
# Use o valor "now" para pegar a data e hora de hoje.
#
# @param datetime $5
# [opcional]
# Informa o dia e hora em que o item foi concluído.
# Se definido, deve usar o formato "YYYY-MM-DD HH:MM:SS"
# Caso o status do item não seja "closed", este valor será
# ignorado.
# Use o valor "now" para pegar a data e hora de hoje.
mse_notes_topicItemAdd() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseNewLine=$(mse_notes_topicItemCreateLine "" "${1}" "${2}" "${3}" "${4}" "${5}")

    if [ "${mseNewLine}" == "" ]; then
      mse_inter_showError "ERR::${MSE_NOTES_ITEM_ERROR_MSG}"
      MSE_NOTES_ITEM_ERROR_MSG=""
    else

      local mseTopicName=$(mse_notes_normalizeTopicName "${1}")
      local mseTargetTopicFile="${MSE_NOTES_DIRECTORY["topicsDir"]}/${mseTopicName}"


      printf "${mseNewLine}\n" >> "${mseTargetTopicFile}"
      if [ $? != 0 ]; then
        mse_inter_showError "ERR::${lbl_err_itemAdd_cannotSave}"
      else
        mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_success_itemAdd}" "TOPIC" "${mseTopicName}")
        mse_inter_showAlert "s" "${mseFeedBackMsg}"

        mse_notes_metaDataUpdate "nextItemId"
      fi

    fi
  fi
}
MSE_GLOBAL_CMD["notes topic item add"]="mse_notes_topicItemAdd"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_topicItemAdd_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=5
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="TopicName :: r :: list"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0_labels"]="-"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0_values"]="-"

  if [ "${#MSE_NOTES_TOPICS[@]}" != "0" ]; then
    declare -a mseTmpLabels=("${!MSE_NOTES_TOPICS[@]}")
    mseTmpLabels=$(mse_str_join ", " "mseTmpLabels")
    MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0_labels"]="${mseTmpLabels}"
    MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0_values"]="${mseTmpLabels}"

    unset mseTmpLabels
  fi

  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="Description :: r :: string"

  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2"]="Status :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2_labels"]="o, c"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2_values"]="open, closed"

  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_3"]="RegisterDate :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_4"]="CloseDate :: o :: string"
}
