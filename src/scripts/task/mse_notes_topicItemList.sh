#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Lista os itens de um tópico conforme as configurações indicadas.
# Para uma consulta mais abrangente com maiores informações use a função
# "mse_notes_topicItemSearch".
#
# @param string $1
# [opcional]
# Nome total ou parcial do/s tópico/s alvos da listagem.
# Se não for definido, retornará itens de todos os tópicos do diretório.
#
# @param string $2
# [opcional]
# Descrição total ou parcial dos items que devem ser retornados.
#
# @param status $3
# [opcional]
# Status dos itens.
# Se não for definido, buscará por todos os status (open | closed).
#
# @param string $4
# [opcional]
# Configurar as colunas de dados que devem ser retornadas.
#
# Use as mesmas regras descritas para o parametro "$9" da função
# "mse_notes_topicItemSearch"
mse_notes_topicItemList() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseTopic="${1}"
    local mseDescription="${2}"
    local mseStatus="${3}"
    local mseShowColumns="${4}"

    if [ "${mseStatus}" == "" ]; then
      mseStatus="open"
    fi

    if [ "${mseShowColumns}" == "" ] || [ "${#mseShowColumns}" != 8 ]; then
      mseShowColumns="10011001"
    else
      if [ "${mseShowColumns:0:1}" != "1" ]; then
        mseShowColumns="1${mseShowColumns:1:7}"
      fi
    fi

    mse_notes_topicItemMainSearch "" "${mseTopic}" "${mseDescription}" "${mseStatus}" "" "" "" "" "${mseShowColumns}" ""

    if [ "${#MSE_NOTES_SEARCH[@]}" == 0 ]; then
      mse_inter_showAlert "a" "${lbl_info_itemList_emptyResult}"
    else

      local mseThemePrefix="${MSE_GLOBAL_MAIN_THEME_COLORS[${MSE_GLOBAL_THEME_NAME}]}"
      local mseUseTopicColor="${MSE_GLOBAL_MAIN_THEME_COLORS["${mseThemePrefix}_message_body"]}"
      local mseUseLineColor="${mseNONE}"

      local mseFirstColumnLength=32
      local mseMetaSeparatorLength=${#MSE_NOTES_ITEM_META_SEPARATOR}
      ((mseFirstColumnLength = mseFirstColumnLength + mseMetaSeparatorLength))
      local mseUseHeaders="${MSE_NOTES_SEARCH[0]:${mseFirstColumnLength}}"

      local mseAtualTopic=""
      local mseLineNaturalTopicName=""
      declare -a mseMsgPrintLines=()

      for mseLine in "${MSE_NOTES_SEARCH[@]:1}"; do
        mseLineNaturalTopicName=$(mse_str_trim "${mseLine:0:32}")

        if [ "${mseLineNaturalTopicName}" != "${mseAtualTopic}" ]; then
          mseAtualTopic="${mseLineNaturalTopicName}"

          if [ "${#mseMsgPrintLines[@]}" -gt 0 ]; then
            mseMsgPrintLines+=("")
          fi
          mseMsgPrintLines+=("${mseUseLineColor}${mseLineNaturalTopicName}${mseNONE}")
          mseMsgPrintLines+=("${mseUseLineColor}${mseUseHeaders}${mseNONE}")
        fi

        mseMsgPrintLines+=("${mseUseLineColor}${mseLine:${mseFirstColumnLength}}${mseNONE}")
      done

      mse_inter_showAlert "a" "${lbl_info_itemList_foundResult}" "mseMsgPrintLines"
    fi
  fi
}
MSE_GLOBAL_CMD["notes topic item list"]="mse_notes_topicItemList"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_topicItemList_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=3
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="TopicName :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="Status :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1_labels"]="a, o, c"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1_values"]="all, open, closed"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2"]="RetrieveColumns :: o :: string :: 00011001 :: 8"
}
