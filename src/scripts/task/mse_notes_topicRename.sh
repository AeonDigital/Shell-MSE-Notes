#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Renomeia um tópico existente.
#
# @param string $1
# Nome do tópico a ser renomeado.
#
# @param string $2
# Novo nome para o tópico alvo.
mse_notes_topicRename() {
  local mseFeedBackMsg=""

  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseOldTopicName=$(mse_notes_normalizeTopicName "${1}")

    if [ "${mseOldTopicName}" == "" ]; then
      mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_paramA_HasInvalidValue}" "PARAM_A" "\$1")
      mse_inter_showError "ERR::${mseFeedBackMsg}"
    else
      local mseNaturalTopicName="${2}"

      if [ "${#mseNaturalTopicName}" -gt 32 ]; then
        mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_topicRename_maxLengthExceeded}" "TOPIC" "${mseNaturalTopicName}")
        mse_inter_showError "ERR::${mseFeedBackMsg}"
      else
        local mseNewTopicName=$(mse_notes_normalizeTopicName "${mseNaturalTopicName}")

        if [ "${mseNewTopicName}" == "" ]; then
          mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_paramA_HasInvalidValue}" "PARAM_A" "\$2")
          mse_inter_showError "ERR::${mseFeedBackMsg}"
        else

          local mseOldTopicFile="${MSE_NOTES_DIRECTORY["topicsDir"]}/${mseOldTopicName}"
          local mseNewTopicFile="${MSE_NOTES_DIRECTORY["topicsDir"]}/${mseNewTopicName}"

          if [ ! -f "${mseOldTopicFile}" ]; then
            mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_topicRename_notExist}" "TOPIC" "${mseOldTopicName}")
            mse_inter_showError "ERR::${mseFeedBackMsg}"
          else
            if [ -f "${mseNewTopicFile}" ]; then
              mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_topicRename_alreadyExist}" "TOPIC" "${mseNewTopicName}")
              mse_inter_showError "ERR::${mseFeedBackMsg}"
            else

              mv "${mseOldTopicFile}" "${mseNewTopicFile}"
              if [ $? != 0 ]; then
                mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_topicRename_unespectedFail}" "TOPIC" "${mseOldTopicName}")
                mse_inter_showError "ERR::${mseFeedBackMsg}"
              else
                #
                # Altera o nome natural do tópico
                declare -a mseContent=("${mseNaturalTopicName}")
                local mseReturn=$(mse_file_write "${mseNewTopicFile}" "mseContent" "r" "1")

                if [ "${mseReturn}" != "1" ]; then
                  mse_inter_showError "ERR::${mseReturn}"
                else
                  mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_success_topicRename}" "OLD_TOPIC" "${mseOldTopicName}" "NEW_TOPIC" "${mseNewTopicName}")
                  mse_inter_showAlert "s" "${mseFeedBackMsg}"

                  #
                  # Redefine a lista de tópicos
                  mse_notes_redefineTopicList
                fi
              fi
            fi
          fi
        fi
      fi
    fi
  fi
}
MSE_GLOBAL_CMD["notes topic rename"]="mse_notes_topicRename"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_topicRename_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=2
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="OldTopicName :: r :: list"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0_labels"]="-"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0_values"]="-"

  if [ "${#MSE_NOTES_TOPICS[@]}" != "0" ]; then
    declare -a mseTmpLabels=("${!MSE_NOTES_TOPICS[@]}")
    mseTmpLabels=$(mse_str_join ", " "mseTmpLabels")
    MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0_labels"]="${mseTmpLabels}"
    MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0_values"]="${mseTmpLabels}"

    unset mseTmpLabels
  fi

  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="NewTopicName :: r :: string :: :: 32"
}
