#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Efetua uma busca entre todas as notas que correspondem às informações de
# consulta passadas.
# O resultado será adicionado no array "MSE_NOTES_NOTE_SEARCH".
#
# Os dados da amostragem serão as linhas de meta-informações das notas
# que forem encontradas.
#
#
# @param string $1
# [opcional]
# Id da nota sendo procurada.
#
# @param date $2
# [opcional]
# Data inicial a partir da qual a consulta será feita.
# Use o formato "YYYY-MM-DD" para indicar um valor válido.
# Se não for definida, usará a data do dia de hoje.
# Se não for definida mas o parametro $1 for, usará como data o valor
# "2000-01-01" como data inicial.
#
# @param date $3
# [opcional]
# Data final até a qual a consulta será feita.
# Use o formato "YYYY-MM-DD" para indicar um valor válido.
# Se não for definida, usará a data do dia de hoje.
#
# @param string $4
# [opcional]
# Nome total ou parcial do/s tópico/s aos quais as notas
# devem pertencer.
#
# @param int $5
# [opcional]
# Id do item ao qual as notas devem estar correlacionadas.
#
# @param string $6
# [opcional]
# Período do dia.
#
# @param string $7
# [opcional]
# Palavra chave que deve estar no corpo das notas.
#
# @param bool $8
# [opcional]
# Quando "1", retornará os dados com uma coluna extra, adicionada ao fim
# que trará o nome do respectivo arquivo daquela nota.
#
# @param bool $9
# Quando "1", retornará as linhas de dados de cada nota que deu match com o
# valor da palavra chave indicada.
mse_notes_noteMainSearch() {
  local mseFeedBackMsg=""

  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseCheckDate=""
    local mseNow=$(date "+%Y-%m-%d")



    local mseDateFrom=$(mse_str_trim "${2}")
    if [ "${mseDateFrom}" == "" ]; then
      mseDateFrom=$(date -d"${mseNow}" "+%s")
    else
      mseCheckDate=$(date -d"$mseDateFrom" "+%Y-%m-%d" 2> /dev/null)
      if [ "${mseCheckDate}" != "${mseDateFrom}" ]; then
        mseDateFrom=$(date -d"${mseNow}" "+%s")
      else
        mseDateFrom=$(date -d"$mseDateFrom" "+%s")
      fi
    fi


    local mseDateTo=$(mse_str_trim "${3}")
    if [ "${mseDateTo}" == "" ]; then
      mseDateTo=$(date -d"${mseNow}" "+%s")
    else
      mseCheckDate=$(date -d"$mseDateTo" "+%Y-%m-%d" 2> /dev/null)
      if [ "${mseCheckDate}" != "${mseDateTo}" ]; then
        mseDateTo=$(date -d"${mseNow}" "+%s")
      else
        mseDateTo=$(date -d"$mseDateTo" "+%s")
      fi
    fi


    #
    # Ajusta as datas
    if [ "${mseDateFrom}" -gt "${mseDateTo}" ]; then
      local mseTmpTo="${mseDateTo}"
      mseDateTo="${mseDateFrom}"
      mseDateFrom="${mseTmpTo}"
    fi



    declare -A mseSearchBy
    mseSearchBy["TopicName"]=0
    mseSearchBy["ItemId"]=0
    mseSearchBy["DayPeriod"]=0
    mseSearchBy["KeyWord"]=0

    local mseTotalMatch=0



    local mseNoteId="${1}"
    if [ "${mseNoteId}" != "" ]; then
      mseNoteId=$(mse_str_pad "${1}" "0" "6" "l")

      if [ "${2}" == "" ]; then
        mseDateFrom=$(date -d"2000-01-01" "+%s")
      fi
    fi


    local mseTopicName=$(mse_notes_normalizeTopicName "${4}")
    if [ "${mseTopicName}" != "" ]; then
      mseSearchBy["TopicName"]=1
    fi


    local mseItemId=$(mse_str_trim "${5}")
    if [ "${mseItemId}" != "" ]; then
      ((mseTotalMatch = mseTotalMatch + 1))
      mseSearchBy["ItemId"]=1
    fi


    local mseDayPeriod=$(mse_str_trim "${6}")
    if [ "${mseDayPeriod}" != "" ]; then
      ((mseTotalMatch = mseTotalMatch + 1))
      mseSearchBy["DayPeriod"]=1
    fi


    local mseKeyWord=$(mse_str_trim "${7}")
    if [ "${mseKeyWord}" != "" ]; then
      ((mseTotalMatch = mseTotalMatch + 1))
      mseSearchBy["KeyWord"]=1
    fi


    local mseRetrieveFilePath="${8}"
    if [ "${mseRetrieveFilePath}" != "1" ]; then
      mseRetrieveFilePath=""
    fi


    local mseShowMatchLines="${9}"
    if [ "${mseShowMatchLines}" != "1" ]; then
      mseShowMatchLines=""
    fi







    #
    # Identifica todos os arquivos que devem entrar na pesquisa
    # usando o critério das datas de início e de fim da consulta.
    declare -a mseAllNoteFiles=()
    IFS=$'\n'
    if [ "${mseNoteId}" == "" ]; then
      mseAllNoteFiles=($(find "${MSE_NOTES_DIRECTORY["notesDir"]}" -type f 2> /dev/null | sort))
    else
      mseAllNoteFiles=($(find "${MSE_NOTES_DIRECTORY["notesDir"]}" -type f -name "*_${mseNoteId}" 2> /dev/null | sort))
    fi
    IFS=$' \t\n'



    local mseMatch="0"
    declare -a mseSelectedNoteFiles=()
    declare -a mseSelectedNoteMetaData=()

    unset MSE_NOTES_NOTE_SEARCH
    declare -ga MSE_NOTES_NOTE_SEARCH=()


    local mseFileYearMonth=""
    local mseFileDay=""
    local mseFileDate=""
    local mseFileData=""
    local mseSep="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"


    for mseFilePath in "${mseAllNoteFiles[@]}"; do
      #
      # Identifica o timestamp referente à data do arquivo
      mseFileYearMonth=$(mse_str_replace "${MSE_NOTES_DIRECTORY["notesDir"]}/" "" "${mseFilePath}")
      mseFileYearMonth=$(mse_str_replace "/" "-" "${mseFileYearMonth:0:7}")
      mseFileDay="${mseFilePath##*/}"
      mseFileDay="${mseFileDay%%_*}"
      mseFileDate="${mseFileYearMonth}-${mseFileDay}"

      #
      # Apenas se foi possível identificar uma data válida
      mseCheckDate=$(date -d"$mseFileDate" "+%Y-%m-%d" 2> /dev/null)
      if [ "${mseCheckDate}" == "${mseFileDate}" ]; then
        mseFileDate=$(date -d"$mseFileDate" "+%s")

        #
        # Estando entre os interválidos definidos
        if [ "${mseFileDate}" -ge "${mseDateFrom}" ] && [ "${mseFileDate}" -le "${mseDateTo}" ]; then
          mseSelectedNoteFiles+=("${mseFilePath}")
          mseFileData="$(head -n 1 "${mseFilePath}")"
          if [ "${mseRetrieveFilePath}" == "1" ]; then
            mseSelectedNoteMetaData+=("${mseFileData}${mseSep}${mseFilePath}")
          else
            mseSelectedNoteMetaData+=("${mseFileData}")
          fi
        fi

        if [ "${mseFileDate}" -gt "${mseDateTo}" ]; then
          break
        fi
      fi
    done





    if [ "${#mseSelectedNoteFiles[@]}" != "0" ]; then
      local mseIndex=0
      local mseCountMatch=0
      local mseSelectedItens=("${MSE_NOTES_NOTE_META_COLUMNS}")

      local mseLineTopicName=""
      local mseLineItemId=""
      local mseLineDayPeriod=""
      local mseTmpFileContent=""

      local mseFileDate=""
      local mseRelativePath=""
      local mseRelativePathSplited


      for mseFilePath in "${mseSelectedNoteFiles[@]}"; do
        mseCountMatch=0

        local mseLineRaw="${mseSelectedNoteMetaData[${mseIndex}]}"
        mse_str_split "${mseSep}" "${mseLineRaw}" "" "1"

        if [ "${#MSE_GLOBAL_MODULE_SPLIT_RESULT[@]}" == "8" ] || [ "${#MSE_GLOBAL_MODULE_SPLIT_RESULT[@]}" == "9" ]; then
          mseLineTopicName=$(mse_notes_normalizeTopicName "${MSE_GLOBAL_MODULE_SPLIT_RESULT[0]}")
          mseLineItemId="${MSE_GLOBAL_MODULE_SPLIT_RESULT[1]}"
          mseLineDayPeriod="${MSE_GLOBAL_MODULE_SPLIT_RESULT[2]}"
          mseTmpFileContent=""

          if [ ${mseSearchBy["TopicName"]} == 0 ] || [[ "${mseLineTopicName}" =~ "${mseTopicName}" ]]; then

            if [ ${mseSearchBy["ItemId"]} == 1 ] || [[ "${mseItemId}" == "${mseLineItemId}" ]]; then
              ((mseCountMatch = mseCountMatch + 1))
            fi

            if [ ${mseSearchBy["DayPeriod"]} == 1 ] || [[ "${mseDayPeriod}" == "${mseLineDayPeriod}" ]]; then
              ((mseCountMatch = mseCountMatch + 1))
            fi

            if [ ${mseSearchBy["KeyWord"]} == 1 ]; then
              mseTmpFileContent=$(cat "${mseFilePath}" | grep -i "$mseKeyWord" 2> /dev/null)
              if [ "${mseTmpFileContent}" != "" ]; then
                ((mseCountMatch = mseCountMatch + 1))
              fi
            fi


            if [ "${mseCountMatch}" == "${mseTotalMatch}" ]; then
              mseSelectedItens+=("${mseLineRaw}")

              if [ "${mseShowMatchLines}" == "1" ] && [ "${mseTmpFileContent}" != "" ]; then
                mseSelectedItens+=("${mseTmpFileContent}")
                mseSelectedItens+=("")
              fi

              #
              # Se a pesquisa foi por Id, encerra
              if [ ${mseSearchBy["ItemId"]} == 1 ]; then
                break;
              fi
            fi
          fi
        fi

        ((mseIndex = mseIndex + 1))
      done


      if [ "${#mseSelectedItens[@]}" -gt 1 ]; then
        MSE_NOTES_NOTE_SEARCH=("${mseSelectedItens[@]}")
      fi
    fi
  fi
}