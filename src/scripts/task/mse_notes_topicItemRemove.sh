#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Remove um item de Id informado.
#
# @param int $1
# Id do item que será removido
mse_notes_topicItemRemove() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    mse_notes_topicItemMainSearch "${1}" "" "" "" "" "" "" "" "01100000" ""

    if [ "${#MSE_NOTES_SEARCH[@]}" == 0 ]; then
      mse_inter_showAlert "a" "${lbl_info_itemRemove_notFound}"
    else
      local mseFirstColumnLength=32
      local mseItemSeparatorLength=${#MSE_NOTES_ITEM_COLUMNS_SEPARATOR}
      ((mseFirstColumnLength = mseFirstColumnLength + mseItemSeparatorLength))

      local mseTopicName=$(mse_str_trim "${MSE_NOTES_SEARCH[1]:0:32}")
      local mseLineNumber=$(mse_str_trim "${MSE_NOTES_SEARCH[1]:${mseFirstColumnLength}}")

      local mseNewTopicFile=${MSE_NOTES_DIRECTORY["topicsDir"]}/${mseTopicName}
      declare -a mseEmptyLine=()


      local mseReturn=$(mse_file_write "${mseNewTopicFile}" "mseEmptyLine" "d" "${mseLineNumber}")

      if [ "${mseReturn}" != "1" ]; then
        mse_inter_showError "ERR::${mseReturn}"
      else
        mse_inter_showAlert "s" "${lbl_success_itemRemove}"
      fi
    fi
  fi
}
MSE_GLOBAL_CMD["notes topic item remove"]="mse_notes_topicItemRemove"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_topicItemRemove_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=1
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="Id :: r :: int"
}
