#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Remove um tópico.
#
# @param string $1
# Nome do tópico a ser removido.
mse_notes_topicRemove() {
  local mseFeedBackMsg=""

  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseTopicName=$(mse_notes_normalizeTopicName "${1}")


    if [ "${mseTopicName}" == "" ]; then
      mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_paramA_HasInvalidValue}" "PARAM_A" "\$1")
      mse_inter_showError "ERR::${mseFeedBackMsg}"
    else
      local mseTopicFile="${MSE_NOTES_DIRECTORY["topicsDir"]}/${mseTopicName}"

      if [ ! -f "${mseTopicFile}" ]; then
        mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_topicRemove_notExist}" "TOPIC" "${mseTopicName}")
        mse_inter_showError "ERR::${mseFeedBackMsg}"
      else
        rm "${mseTopicFile}"

        if [ $? != 0 ]; then
          mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_topicRemove_cannotRemove}" "TOPIC" "${mseTopicName}")
          mse_inter_showError "ERR::${mseFeedBackMsg}"
        else
          #
          # Redefine a lista de tópicos
          mse_notes_redefineTopicList

          mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_success_topicRemove}" "TOPIC" "${mseTopicName}")
          mse_inter_showAlert "s" "${mseFeedBackMsg}"
        fi
      fi
    fi
  fi
}
MSE_GLOBAL_CMD["notes topic remove"]="mse_notes_topicRemove"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_topicRemove_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=1
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
}
