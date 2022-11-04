#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Permite editar as meta-informações da nota de id informado.
# Abre a nota para edição ao final da alteração.
#
# @param string $1
# Id da nota alvo.
#
# @param time $2
# [opcional]
# Horário de início desta atividade.
# Se definido, use o formato "HH:MM".
# Se não for definido, manterá o valor atual.
#
# @param time $3
# [opcional]
# Horário de encerramento desta atividade.
# Se definido, use o formato "HH:MM".
# Se não for definido, manterá o valor atual.
#
# @param date $4
# [opcional]
# Data de registro desta nota.
# Se não for definido, manterá o valor atual.
mse_notes_noteEdit() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseNoteId=$(mse_str_pad "${1}" "0" "6" "l")

    declare -a mseAllNoteFiles=()
    IFS=$'\n'
    mseAllNoteFiles=($(find "${MSE_NOTES_DIRECTORY["notesDir"]}" -type f -name "*_${mseNoteId}" 2> /dev/null | sort))
    IFS=$' \t\n'

    if [ "${#mseAllNoteFiles[@]}" == 0 ]; then
      mse_inter_showError "ERR::${lbl_err_noteEdit_idNotFound}"
    else
      local mseNoteFilePath="${mseAllNoteFiles[0]}"

      local mseMetaLine=$(head -n 1 "${mseNoteFilePath}")
      mse_str_split "${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}" "${mseMetaLine}" "" "1"

      if [ "${#MSE_GLOBAL_MODULE_SPLIT_RESULT[@]}" != "8" ]; then
        mse_inter_showError "ERR::${lbl_err_noteEdit_metaLineCorrupt}"
      else
        local mseItemId="${MSE_GLOBAL_MODULE_SPLIT_RESULT[1]}"
        local mseIniTime="${MSE_GLOBAL_MODULE_SPLIT_RESULT[4]}"
        local mseEndTime="${MSE_GLOBAL_MODULE_SPLIT_RESULT[5]}"
        local mseDate="${MSE_GLOBAL_MODULE_SPLIT_RESULT[7]}"


        if [ "${2}" != "" ] && [ "${2}" != "${mseIniTime}" ]; then
          mseIniTime="${2}"
        fi
        if [ "${3}" != "" ] && [ "${3}" != "${mseEndTime}" ]; then
          mseEndTime="${3}"
        fi
        if [ "${4}" != "" ] && [ "${4}" != "${mseDate}" ]; then
          mseDate="${4}"
        fi


        local mseNewLine=$(mse_notes_noteCreateLine "${1}" "${mseItemId}" "${mseIniTime}" "${mseEndTime}" "" "${mseDate}")
        if [ "${mseNewLine}" == "" ]; then
          mse_inter_showError "ERR::${MSE_NOTES_NOTE_ERROR_MSG}"
          MSE_NOTES_NOTE_ERROR_MSG=""
        else
          local mseSep="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"
          local mseNewNoteFilePath="${mseNewLine##*${mseSep}}"
          mseNewNoteFilePath="${mseNewNoteFilePath%_*}_${mseNoteId}"
          mseNewLine="${mseNewLine%${mseSep}*}"


          #
          # Edita o arquivo original
          declare -a mseContent=("${mseNewLine}")
          local mseReturn=$(mse_file_write "${mseNoteFilePath}" "mseContent" "r" "1")

          if [ "${mseReturn}" != "1" ]; then
            mse_inter_showError "ERR::${mseReturn}"
          else
            local mseIsOk="1"

            #
            # Sendo necessário realocar a nota...
            if [ "${mseNoteFilePath}" != "${mseNewNoteFilePath}" ]; then
              #
              # Verifica se é preciso criar a estrutura de diretórios...
              local mseBasePath="${mseNewNoteFilePath%/*}"
              if [ ! -d "${mseBasePath}" ]; then
                mkdir -p "${mseBasePath}"
              fi

              if [ ! -d "${mseBasePath}" ]; then
                mse_inter_showError "ERR::${lbl_err_noteEdit_cannotCreateDirectory}"
                mseIsOk="0"
              else
                mv "${mseNoteFilePath}" "${mseNewNoteFilePath}"

                if [ $? != 0 ]; then
                  mse_inter_showError "ERR::${lbl_err_noteEdit_cannotChangeDate}"
                  mseIsOk="0"
                else
                  mseNoteFilePath="${mseNewNoteFilePath}"
                fi
              fi
            fi


            if [ "${mseIsOk}" == "1" ]; then
              mse_inter_showAlert "s" "${lbl_success_noteEdit}"
              mse_notes_shellNote "${mseNoteFilePath}"
            fi
          fi
        fi
      fi
    fi

  fi
}
MSE_GLOBAL_CMD["notes note edit"]="mse_notes_noteEdit"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_noteEdit_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=4
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="NoteId :: r :: int"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="IniHour :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2"]="EndHour :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_3"]="NoteDate :: o :: string"
}
