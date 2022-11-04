#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Lista os tópicos de notas existentes para o diretório que está
# aberto no momento.
mse_notes_topicList() {
  local mseFeedBackMsg=""

  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseTopic=()

    if [ "${#MSE_NOTES_TOPICS[@]}" == "0" ]; then
      mseFeedBackMsg="${lbl_info_topicList_empty}"
    else

      #
      # Ordena o resultado do array
      local mseStrUniqueSortTopics="$(printf "%s\n" "${MSE_NOTES_TOPICS[@]}" | sort -u)"
      IFS=$'\n'
      declare -a mseUniqueSortTopics=($(echo "${mseStrUniqueSortTopics}"))
      IFS=$' \t\n'


      for mseTopicName in "${mseUniqueSortTopics[@]}"; do
        mseTopic+=("${mseNONE}- ${mseTopicName}${mseNONE}")
      done

      mseFeedBackMsg="${lbl_info_topicList_find}"
    fi

    mse_inter_showAlert "a" "${mseFeedBackMsg}" "mseTopic"
  fi
}
MSE_GLOBAL_CMD["notes topic list"]="mse_notes_topicList"