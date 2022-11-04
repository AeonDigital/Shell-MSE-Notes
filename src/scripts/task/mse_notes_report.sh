#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Permite gerar um relatório das atividades feitas a partir dos critérios
# de seleção indicados.
#
# @param date $1
# Data inicial a partir da qual as notas serão incluídas no relatório.
# Use o formato "YYYY-MM-DD" para indicar um valor válido.
#
# @param date $2
# Data final até a qual as notas serão incluídas no relatório.
# Use o formato "YYYY-MM-DD" para indicar um valor válido.
#
# @param string $3
# Nome total ou parcial do/s tópicos/s aos quais as notas
# devem pertencer.
#
# @param string $4
# [optional]
# Nome do arquivo de report.
# Se não for definido, o resultado será printado na tela.
# Se definido, o arquivo será armazenado no diretório "/reports" referente
# ao local que está aberto no momento.
mse_notes_report() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    mse_notes_noteMainSearch "" "${1}" "${2}" "${3}" "" "" "${7}" "1"

    if [ "${#MSE_NOTES_NOTE_SEARCH[@]}" == "0" ]; then
      mse_inter_showAlert "a" "${lbl_info_report_emptyResult}"
    else

      local mseIndex=0
      local mseCheck="0"
      local mseTopicName=""
      local mseSep="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"


      unset mseTopicNamesReportCountHours
      declare -A mseTopicNamesReportCountHours
      local mseTopicNameHoursCounter=0
      local mseNoteTotalHours=0

      unset mseTopicNamesReportItems
      declare -A mseTopicNamesReportItems
      local mseItemId=""
      local mseItemDescription=""

      unset mseNoteTimeStamp
      unset mseNoteTimeStampIndex
      declare -a mseNoteTimeStamp=()
      declare -A mseNoteTimeStampIndex
      local mseNoteDate=""
      local mseDayPeriod=""
      local mseNoteIniTime=""
      local mseNoteEndTime=""
      local mseIniTimeStamp=""


      #
      # Inicia a coleta de dados
      local mseRawLine=""
      for mseRawLine in "${MSE_NOTES_NOTE_SEARCH[@]:1}"; do
        ((mseIndex = mseIndex + 1))
        mse_str_split "${mseSep}" "${mseRawLine}" "" "1"

        if [ "${#MSE_GLOBAL_MODULE_SPLIT_RESULT[@]}" == "9" ]; then
          mseTopicName="${MSE_GLOBAL_MODULE_SPLIT_RESULT[0]}"
          mseItemId="${MSE_GLOBAL_MODULE_SPLIT_RESULT[1]}"
          mseNoteDate="${MSE_GLOBAL_MODULE_SPLIT_RESULT[7]}"
          mseNoteIniTime="${MSE_GLOBAL_MODULE_SPLIT_RESULT[4]}"

          mseNoteTotalHours=$(expr "${MSE_GLOBAL_MODULE_SPLIT_RESULT[6]}" + 0)

          mseCheck=$(mse_check_hasKeyInAssocArray "${mseTopicName}" "mseTopicNamesReportCountHours")
          if [ "${mseCheck}" == "0" ]; then
            mseTopicNamesReportCountHours["${mseTopicName}"]=0
            mseTopicNamesReportItems["${mseTopicName}"]=""
          fi

          #
          # Soma o total de horas usadas neste tópico
          mseTopicNameHoursCounter=${mseTopicNamesReportCountHours["${mseTopicName}"]}
          ((mseTopicNameHoursCounter = mseTopicNameHoursCounter + mseNoteTotalHours))
          mseTopicNamesReportCountHours["${mseTopicName}"]=${mseTopicNameHoursCounter}


          #
          # Resgata e registra os itens que foram trabalhadas para cada tópico
          mse_notes_topicItemMainSearch "${mseItemId}" "" "" "" "" "" "" "" "00000001"
          mseItemDescription="${MSE_NOTES_SEARCH[1]}"
          mseTopicNamesReportItems["${mseTopicName}"]+="${mseItemDescription}${mseSep}"


          #
          # Registra o timestamp da atividade para permitir reordenar do mais antigo para
          # o mais recente.
          mseIniTimeStamp=$(date -d"${mseNoteDate} ${mseNoteIniTime}:00" "+%s")
          mseNoteTimeStamp+=(${mseIniTimeStamp})
          mseNoteTimeStampIndex[${mseIniTimeStamp}]=${mseIndex}
        fi
      done



      #
      # Inicia a montagem do relatório em si
      unset mseReportLines
      declare -a mseReportLines=()
      mseReportLines+=("### ${lbl_report_resume}")
      mseReportLines+=("--------- --------- --------- --------- ---------")
      mseReportLines+=("")

      local mseStrUniqueItems=""

      for mseTopicName in "${!mseTopicNamesReportCountHours[@]}"; do
        mseReportLines+=("  * ${mseTopicName} [ ${mseTopicNamesReportCountHours["${mseTopicName}"]} ${lbl_report_hours} ]")
        mseReportLines+=("")

        mse_str_split "${mseSep}" "${mseTopicNamesReportItems["${mseTopicName}"]}" "1" "1"
        mseStrUniqueItems="$(printf "%s\n" "${MSE_GLOBAL_MODULE_SPLIT_RESULT[@]}" | sort -u)"
        IFS=$'\n'
        MSE_GLOBAL_MODULE_SPLIT_RESULT=($(echo "${mseStrUniqueItems}"))
        IFS=$' \t\n'

        for mseItemDescription in "${MSE_GLOBAL_MODULE_SPLIT_RESULT[@]}"; do
          mseReportLines+=("    - ${mseItemDescription}")
        done

        mseReportLines+=("")
        mseReportLines+=("")
      done



      #
      # Ordena os timestamps das notas
      IFS=$'\n'
      unset mseTmpSortedTimeStamps
      declare -a mseTmpSortedTimeStamps=($(sort <<< "${mseNoteTimeStamp[*]}"))
      IFS=$' \t\n'




      local mseRawLine=""
      local mseWeekDay=""
      local mseDayMonth=""
      local mseAtualNoteDate=""
      local mseNoteContent=""
      mseDayPeriod=""
      mseNoteIniTime=""
      mseNoteEndTime=""
      mseNoteTotalHours=""
      mseNoteDate=""


      mseReportLines+=("")
      mseReportLines+=("")
      mseReportLines+=("### ${lbl_report_fullReport}")
      mseReportLines+=("--------- --------- --------- --------- ---------")
      mseReportLines+=("")



      for mseIniTimeStamp in "${!mseTmpSortedTimeStamps[@]}"; do
        mseRawLine="${MSE_NOTES_NOTE_SEARCH[${mseIniTimeStamp}]}"

        mse_str_split "${mseSep}" "${mseRawLine}" "" "1"

        if [ "${#MSE_GLOBAL_MODULE_SPLIT_RESULT[@]}" == "9" ]; then
          mseTopicName="${MSE_GLOBAL_MODULE_SPLIT_RESULT[0]}"
          mseDayPeriod="${MSE_GLOBAL_MODULE_SPLIT_RESULT[3]}"
          mseNoteIniTime="${MSE_GLOBAL_MODULE_SPLIT_RESULT[4]}"
          mseNoteEndTime="${MSE_GLOBAL_MODULE_SPLIT_RESULT[5]}"
          mseNoteTotalHours=$(expr "${MSE_GLOBAL_MODULE_SPLIT_RESULT[6]}" + 0)
          mseNoteDate="${MSE_GLOBAL_MODULE_SPLIT_RESULT[7]}"

          if [ "${mseAtualNoteDate}" != "${mseNoteDate}" ]; then
            mseAtualNoteDate="${mseNoteDate}"

            mseWeekDay=$(date -d"${mseNoteDate}" "+%u")
            mseWeekDay="${MSE_GLOBAL_LABEL_WEEKDAY[${mseWeekDay}]}"
            mseDayMonth=$(date -d"${mseNoteDate}" "${lbl_report_dayFormat}")

            mseReportLines+=("")
            mseReportLines+=("#### ${mseWeekDay} - ${lbl_report_day} ${mseDayMonth}")
            mseReportLines+=("")
          fi


          mseReportLines+=("  ${mseDayPeriod}: ${mseNoteIniTime} -> ${mseNoteEndTime} [ ${mseNoteTotalHours}h ] | ${mseTopicName}")
          mseReportLines+=("")

          IFS=$'\n'
          mseNoteContent=($(tail -n +4 "${MSE_GLOBAL_MODULE_SPLIT_RESULT[8]}"))
          IFS=$' \t\n'

          for mseCLine in "${mseNoteContent[@]}"; do
            mseReportLines+=("  ${mseCLine}")
          done

          mseReportLines+=("")
          mseReportLines+=("")
        fi
      done





      local mseReportFileName=$(mse_str_trim "${4}")
      if [ "${mseReportFileName}" == "" ]; then
        eval printf "=%.0s" {1..$MSE_NOTES_INTERFACE_RULER_LENGTH}
        printf "\n"
        printf "%s\n" "${mseReportLines[@]}"
        printf "\n"
        eval printf "=%.0s" {1..$MSE_NOTES_INTERFACE_RULER_LENGTH}
        printf "\n"
      else
        mseReportFileName="${MSE_NOTES_DIRECTORY["reportsDir"]}/${4}"

        local mseNow=$(date "+%Y-%m-%d %H:%M:%S")
        local mseIniDate=$(mse_str_pad "${1}" " " "10" "r")
        local mseEndDate=$(mse_str_pad "${2}" " " "10" "r")
        local mseTopicName=$(mse_str_trim "${3}")

        local mseStrHeader="${MSE_NOTES_REPOST_META_COLUMN}"
        local mseStrValues="${mseNow}${mseSep}${mseIniDate}${mseSep}${mseEndDate}${mseSep}${mseTopicName}"

        printf "${mseStrHeader}\n${mseStrValues}\n\n\n" > "${mseReportFileName}"
        printf "%s\n" "${mseReportLines[@]}" >> "${mseReportFileName}"

        if [ $? != 0 ]; then
          mse_inter_showError "ERR::${lbl_err_report_cannotSave}"
        else
          local mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_success_reportScreen}" "FILE" "${mseReportFileName}")
          mse_inter_showAlert "s" "${mseFeedBackMsg}"
        fi
      fi

    fi
  fi
}
MSE_GLOBAL_CMD["notes report"]="mse_notes_report"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_report_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=3
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="DateFrom :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="DateTo :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2"]="TopicName :: o :: string"
}
