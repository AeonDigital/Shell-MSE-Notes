#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Prepara uma linha de dados que representa um item de um tópico.
#
# @param int $1
# [opcional]
# Id do item.
# Se definido, precisa existir de fato. Neste caso, irá manter todos os
# valores existentes e substituirá aqueles que forem explicitamente
# redefinidos usando os demais argumentos.
# Se não for definido, irá utilizar o próximo Id previsto na variável
# "MSE_NOTES_DIRECTORY["nextItemId"]" e usará as mesmas regras de
# validação exigidas para a insersão de um novo item.
#
# @param string $2
# [opcional]
# Nome do tópico em que o novo item será adicionado.
# Se está editando um item existente, este campo será substituído pelo
# valor original do registro original.
#
# @param string $3
# [opcional]
# Descrição do item.
#
# @param status $4
# [opcional]
# Informa o status atual do item.
# Se não for definido, por padrão, definirá este valor como
# "open". As opções válidas são apenas "open" e "closed".
#
# @param datetime $5
# [opcional]
# Informa o dia e hora em que o item foi adicionado.
# Se não for definido, usará a data e hora do dia de hoje.
# Se definido, deve usar o formato "YYYY-MM-DD HH:MM:SS"
# Use o valor "now" para pegar a data e hora de hoje.
#
# @param datetime $6
# [opcional]
# Informa o dia e hora em que o item foi concluído.
# Se definido, deve usar o formato "YYYY-MM-DD HH:MM:SS"
# Caso o status do item não seja "closed", este valor será
# ignorado.
# Use o valor "now" para pegar a data e hora de hoje.
#
# @return
# Será retornada uma linha completa de dados para ser inserida
# em um arguivo de registro de tópicos.
#
# Em caso de erro será retornada uma string vazia e a variável
# global "MSE_NOTES_ITEM_ERROR_MSG" será preenchida com a mensagem
# correspondente ao erro ocorrido.
mse_notes_topicItemCreateLine() {
  local mseNewLine=""
  local mseFeedBackMsg=""
  MSE_NOTES_ITEM_ERROR_MSG=""


  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    MSE_NOTES_ITEM_ERROR_MSG="${lbl_err_hasNoDirectoryOpened}"
  else

    local mseIsOk="1"
    local mseEditMetaData=""
    local mseLineNumber=""

    local mseTopicName=$(mse_notes_normalizeTopicName "${2}")

    local mseId=$(mse_str_trim "${1}")
    local mseStatus=$(mse_str_trim "${4}")
    local mseRegisterDateTime=$(mse_str_trim "${5}")
    local mseCloseDateTime=$(mse_str_trim "${6}")
    local mseDescription=$(mse_str_trim "${3}")


    if [ "${mseId}" == "" ]; then
      mseId="${MSE_NOTES_DIRECTORY["nextItemId"]}"
    else
      mseIsOk=$(mse_check_isInteger "${mseId}")

      if [ "${mseIsOk}" == "0" ]; then
        MSE_NOTES_ITEM_ERROR_MSG="${lbl_err_itemAdd_invalidId_NaN}"
      else
        mse_notes_topicItemMainSearch "${mseId}" "" "" "" "" "" "" "" "11111111" "1"

        if [ "${#MSE_NOTES_SEARCH[@]}" == 0 ]; then
          MSE_NOTES_ITEM_ERROR_MSG="${lbl_err_itemAdd_idNotFound}"
        else
          mse_str_split "${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}" "${MSE_NOTES_SEARCH[1]}" "0" "1"
          mseTopicName="${MSE_GLOBAL_MODULE_SPLIT_RESULT[1]}"
          mseLineNumber="${MSE_GLOBAL_MODULE_SPLIT_RESULT[2]}"

          if [ "${mseStatus}" == "" ]; then
            mseStatus="${MSE_GLOBAL_MODULE_SPLIT_RESULT[4]}"
          fi
          if [ "${mseRegisterDateTime}" == "" ]; then
            mseRegisterDateTime="${MSE_GLOBAL_MODULE_SPLIT_RESULT[5]}"
          fi
          if [ "${mseCloseDateTime}" == "" ]; then
            mseCloseDateTime="${MSE_GLOBAL_MODULE_SPLIT_RESULT[6]}"
          fi
          if [ "${mseDescription}" == "" ]; then
            mseDescription="${MSE_GLOBAL_MODULE_SPLIT_RESULT[7]}"
          fi

          mseEditMetaData="${mseTopicName}${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}${mseLineNumber}${MSE_NOTES_ITEM_META_SEPARATOR}"
        fi
      fi
    fi



    if [ "${mseIsOk}" == "1" ]; then

      local mseValidTopic=$(mse_check_hasKeyInAssocArray "${mseTopicName}" "MSE_NOTES_TOPICS")
      if [ "${mseValidTopic}" == "0" ]; then
        mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_itemAdd_invalidTopic}" "TOPIC" "${mseTopicName}")
        MSE_NOTES_ITEM_ERROR_MSG="${mseFeedBackMsg}"
      else

        local mseTargetTopicFile="${MSE_NOTES_DIRECTORY["topicsDir"]}/${mseTopicName}"
        if [ ! -f "${mseTargetTopicFile}" ]; then
          mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_itemAdd_topicFileNotFound}" "TOPIC" "${mseTopicName}")
          MSE_NOTES_ITEM_ERROR_MSG="${mseFeedBackMsg}"
        else

          mseDescription=$(mse_str_replace "${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}" "" "${mseDescription}")
          if [ "${mseDescription}" == "" ]; then
            MSE_NOTES_ITEM_ERROR_MSG="${lbl_err_itemAdd_invalidDescription}"
          else

            case "${mseStatus}" in
              "c" | "close" | "closed")
                mseStatus="closed"
              ;;

              "" | "o" | "open" | *)
                mseStatus="open"
                mseCloseDateTime=""
              ;;
            esac

            local mseCheckDate=""

            if [ "${mseRegisterDateTime}" == "" ] || [ "${mseRegisterDateTime}" == "now" ]; then
              mseRegisterDateTime=$(printf "%(%Y-%m-%d %H:%M:%S)T")
            else
              mseCheckDate=$(date -d"$mseRegisterDateTime" "+%Y-%m-%d %H:%M:%S" 2> /dev/null)
              if [ "${mseCheckDate}" != "${mseRegisterDateTime}" ]; then
                mseRegisterDateTime=""
              fi
            fi


            if [ "${mseRegisterDateTime}" == "" ]; then
              mseIsOk="0"
              MSE_NOTES_ITEM_ERROR_MSG="${lbl_err_itemAdd_invalidRegisterDate}"
            else
              if [ "${mseStatus}" == "closed" ]; then
                if [ "${mseCloseDateTime}" == "" ] || [ "${mseCloseDateTime}" == "now" ]; then
                  mseCloseDateTime=$(printf "%(%Y-%m-%d %H:%M:%S)T")
                else
                  mseCheckDate=$(date -d"$mseCloseDateTime" "+%Y-%m-%d %H:%M:%S" 2> /dev/null)
                  if [ "${mseCheckDate}" != "${mseCloseDateTime}" ]; then
                    mseCloseDateTime=""
                  fi
                fi

                if [ "${mseCloseDateTime}" == "" ]; then
                  mseIsOk="0"
                  MSE_NOTES_ITEM_ERROR_MSG="${lbl_err_itemAdd_invalidCloseDate}"
                fi
              fi
            fi



            if [ "${mseIsOk}" == "1" ]; then
              local mseSep="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"
              local msePadId=$(mse_str_pad "${mseId}" " " "6" "r")

              if [ "${mseStatus}" == "open" ]; then
                mseStatus="open  "
              fi

              if [ "${mseCloseDateTime}" == "" ]; then
                mseCloseDateTime="                   "
              fi

              mseNewLine="${mseEditMetaData}${msePadId}${mseSep}${mseStatus}${mseSep}${mseRegisterDateTime}${mseSep}${mseCloseDateTime}${mseSep}${mseDescription}"
            fi
          fi
        fi
      fi

    fi
  fi


  printf "${mseNewLine}"
}