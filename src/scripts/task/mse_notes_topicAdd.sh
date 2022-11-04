#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Adiciona um novo tópico de notas.
#
# @param string $1
# Nome do tópico a ser adicionado.
mse_notes_topicAdd() {
  local mseFeedBackMsg=""

  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseNaturalTopicName="${1}"

    if [ "${#mseNaturalTopicName}" -gt 32 ]; then
      mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_topicAdd_maxLengthExceeded}" "TOPIC" "${mseTopicName}")
      mse_inter_showError "ERR::${mseFeedBackMsg}"
    else
      mseTopicName=$(mse_notes_normalizeTopicName "${mseNaturalTopicName}")

      if [ "${mseTopicName}" == "" ]; then
        mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_paramA_HasInvalidValue}" "PARAM_A" "\$1")
        mse_inter_showError "ERR::${mseFeedBackMsg}"
      else
        local mseTopicFile="${MSE_NOTES_DIRECTORY["topicsDir"]}/${mseTopicName}"

        if [ -f "${mseTopicFile}" ]; then
          mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_topicAdd_alreadExist}" "TOPIC" "${mseTopicFile}")
          mse_inter_showError "ERR::${mseFeedBackMsg}"
        else
          local mseInitialFile="${mseNaturalTopicName}\n${MSE_NOTES_ITEM_DATA_COLUMNS}\n"
          printf "${mseInitialFile}" > "${mseTopicFile}"

          if [ $? != 0 ]; then
            mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_topicAdd_cannotCreate}" "TOPIC" "${mseTopicFile}")
            mse_inter_showError "ERR::${mseFeedBackMsg}"
          else
            #
            # Redefine a lista de tópicos
            mse_notes_redefineTopicList

            mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_success_topicAdd}" "TOPIC" "${mseTopicName}")
            mse_inter_showAlert "s" "${mseFeedBackMsg}"
          fi
        fi
      fi
    fi
  fi
}
MSE_GLOBAL_CMD["notes topic add"]="mse_notes_topicAdd"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_topicAdd_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=1
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="TopicName :: r :: string :: :: 32"
}
