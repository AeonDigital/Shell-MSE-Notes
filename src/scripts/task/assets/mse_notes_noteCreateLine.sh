#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Prepara uma linha de dados que representa as meta informações necessárias
# para iniciar uma nova nota.
#
# @param string $1
# Id da nota.
# Se definido, a mesma precisa existir de fato.
# Se não for definido, irá utilizar o próximo Id previsto na variável
# "MSE_NOTES_DIRECTORY["nextNoteId"]" e usará as mesmas regras de
# validação exigidas para a insersão de uma nova nota.
#
# @param string $2
# Id de um item de tópico ao qual a nota será vinculada.
#
# @param time $3
# [opcional]
# Horário de início desta atividade.
# Se definido, use o formato "HH:MM".
# Se não for definido, usará o horário atual do sistema.
#
# @param time $4
# [opcional]
# Horário de encerramento desta atividade.
# Se definido, use o formato "HH:MM".
#
# @param bool $5
# [opcional]
# Use "1" para usar a hora "cheia", convertendo assim qualquer
# fração de horário em zero minutos.
#
# @param date $6
# [opcional]
# Por padrão, usa sempre a data do dia de hoje para alocar a nota
# fisicamente no sistema de arquivos.
# Se definido, use o formato "YYYY-MM-DD"
# Um valor inválido forçará o uso do dia de hoje.
mse_notes_noteCreateLine() {
  local mseNewLine=""
  local mseFeedBackMsg=""
  MSE_NOTES_NOTE_ERROR_MSG=""


  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    MSE_NOTES_NOTE_ERROR_MSG="${lbl_err_hasNoDirectoryOpened}"
  else
    mse_notes_topicItemMainSearch "${2}" "" "" "" "" "" "" "" "10010000" "1"

    if [ "${#MSE_NOTES_SEARCH[@]}" == 0 ]; then
      MSE_NOTES_NOTE_ERROR_MSG="${lbl_info_addNote_notFound}"
    else
      local mseCheckTime=""

      local mseDayPeriod=""
      local mseIniTime="${3}"
      local mseEndTime="${4}"
      local mseFullHour="${5}"
      local mseTotalMinute=0
      local mseTotalHour=0
      local mseUseDate="${6}"


      if [ "${mseIniTime}" == "" ]; then
        mseIniTime=$(date "+%H:%M")
      else
        mseCheckTime=$(date -d"${mseIniTime}" "+%H:%M" 2> /dev/null)
        if [ "${mseCheckTime}" != "${mseIniTime}" ]; then
          mseIniTime=$(date "+%H:%M")
        fi
      fi

      if [ "${mseEndTime}" != "" ]; then
        mseCheckTime=$(date -d"${mseEndTime}" "+%H:%M" 2> /dev/null)
        if [ "${mseCheckTime}" != "${mseEndTime}" ]; then
          mseEndTime="     "
        fi
      else
        mseEndTime="     "
      fi

      if [ "${mseFullHour}" == "1" ]; then
        mseIniTime="${mseIniTime:0:2}:00"

        if [ "${mseEndTime}" != "" ]; then
          mseEndTime="${mseEndTime:0:2}:00"
        fi
      fi

      if [ "${mseUseDate}" == "" ]; then
        mseUseDate=$(date "+%Y-%m-%d")
      else
        mseCheckDate=$(date -d"$mseUseDate" "+%Y-%m-%d" 2> /dev/null)
        if [ "${mseCheckDate}" != "${mseUseDate}" ]; then
          mseUseDate=$(date "+%Y-%m-%d")
        fi
      fi

      if [ "${mseIniTime}" != "" ] && [ "${mseEndTime}" != "" ]; then
        local mseIniTS=$(date -d"2000-01-01 ${mseIniTime}:00" "+%s" 2> /dev/null)
        local mseEndTS=$(date -d"2000-01-01 ${mseEndTime}:00" "+%s" 2> /dev/null)

        if [ "${mseIniTS}" != "" ] && [ "${mseEndTS}" != "" ]; then
          if [ "${mseEndTS}" -lt "${mseIniTS}" ]; then
            mseEndTS=$(date -d"2000-01-02 ${mseEndTime}:00" "+%s" 2> /dev/null)
          fi

          #
          # Calcula o total de minutos passados
          ((mseTotalMinute = (mseEndTS - mseIniTS) / 60))
          #
          # Calcula o total de horas que serão efetivamente
          # contabilizadas... neste caso sempre usa hora cheia.
          # Qualquer minuto extra conta como uma hora extra.
          ((mseTotalHour = (mseTotalMinute + 59) / 60))
        fi
      fi





      #
      # Identifica o local onde a nota deve ser armazenada
      local isLocalExists="1"
      local mseStrYear="${mseUseDate:0:4}"
      local mseYearDir="${MSE_NOTES_DIRECTORY["notesDir"]}/${mseUseDate:0:4}"

      local mseIntMonth="${mseUseDate:5:2}"
      ((mseIntMonth = mseIntMonth + 0))
      local mseStrMonth="${MSE_GLOBAL_LABEL_MONTH[${mseIntMonth}],,}"
      local mseMonthDir="${mseYearDir}/${mseUseDate:5:2}_${mseStrMonth}"

      local mseStrMonthDay="${mseUseDate:8:2}"
      local mseIntWeekDay=$(date -d"$mseUseDate" "+%u")
      local mseStrWeekDay="${MSE_GLOBAL_LABEL_WEEKDAY[${mseIntWeekDay}],,}"

      local mseNoteId=${MSE_NOTES_DIRECTORY["nextNoteId"]}
      if [ "${1}" != "" ]; then
        mseNoteId="${1}"
      fi
      local msePadId=$(mse_str_pad "${mseNoteId}" "0" "6" "l")
      local mseStrId=$(mse_str_pad "${mseNoteId}" " " "6" "r")
      local mseNoteFile="${mseMonthDir}/${mseStrMonthDay}_${mseStrWeekDay}_${msePadId}"



      local mseIsOk="1"
      if [ ! -d "${mseYearDir}" ]; then
        mkdir "${mseYearDir}"

        if [ $? != 0 ]; then
          mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_cannotCreateNewDirectoryIn}" "LOCAL" "${mseYearDir}")
          MSE_NOTES_NOTE_ERROR_MSG="${mseFeedBackMsg}"

          mseIsOk="0"
        fi
      fi

      if [ "${mseIsOk}" == "1" ] && [ ! -d "${mseMonthDir}" ]; then
        mkdir "${mseMonthDir}"

        if [ $? != 0 ]; then
          mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_cannotCreateNewDirectoryIn}" "LOCAL" "${mseMonthDir}")
          MSE_NOTES_NOTE_ERROR_MSG="${mseFeedBackMsg}"

          mseIsOk="0"
        fi
      fi



      if [ "${mseIsOk}" == "1" ]; then
        #
        # Identifica o período do dia
        local mseHour=$(expr "${mseIniTime:0:2}" + 0)
        local msePeriodIndex=0
        local mseRoundUpAdjust=5
        ((msePeriodIndex = (mseHour + mseRoundUpAdjust) / 6))
        mseDayPeriod=$(mse_str_pad "${MSE_GLOBAL_LABEL_DAYPERIOD[${msePeriodIndex}]}" " " "10" "r")
        mseIniTime=$(mse_str_pad "${mseIniTime}" " " "8" "r")
        mseEndTime=$(mse_str_pad "${mseEndTime}" " " "8" "r")

        mseTotalHour=$(mse_str_pad "${mseTotalHour}" "0" "2" "l")
        mseTotalHour=$(mse_str_pad "${mseTotalHour}" " " "10" "r")


        local mseSep="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"
        mseNewLine="${MSE_NOTES_SEARCH[1]}${mseSep}${mseStrId}${mseSep}${mseDayPeriod}${mseSep}${mseIniTime}${mseSep}${mseEndTime}${mseSep}${mseTotalHour}${mseSep}${mseUseDate}${mseSep}${mseNoteFile}"
      fi
    fi
  fi


  printf "${mseNewLine}"
}