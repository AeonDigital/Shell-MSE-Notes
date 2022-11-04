#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Adiciona uma nota correlacionada a um item de um tópico.
# Abre a nota para edição ao final da insersão.
#
# @param string $1
# Id de um item de tópico ao qual a nota será vinculada.
#
# @param time $2
# [opcional]
# Horário de início desta atividade.
# Se definido, use o formato "HH:MM".
# Se não for definido, usará o horário atual do sistema.
#
# @param time $3
# [opcional]
# Horário de encerramento desta atividade.
# Se definido, use o formato "HH:MM".
#
# @param bool $4
# [opcional]
# Use "1" para usar a hora "cheia", convertendo assim qualquer
# fração de horário em zero minutos.
#
# @param date $5
# [opcional]
# Por padrão, usa sempre a data do dia de hoje para alocar a nota
# fisicamente no sistema de arquivos.
# Se definido, use o formato "YYYY-MM-DD"
# Um valor inválido forçará o uso do dia de hoje.
mse_notes_noteAdd() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseNewLine=$(mse_notes_noteCreateLine "" "${1}" "${2}" "${3}" "${4}" "${5}")

    if [ "${mseNewLine}" == "" ]; then
      mse_inter_showError "ERR::${MSE_NOTES_NOTE_ERROR_MSG}"
      MSE_NOTES_NOTE_ERROR_MSG=""
    else
      local mseSep="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"
      local mseNoteFile="${mseNewLine##*${mseSep}}"
      mseNewLine="${mseNewLine%${mseSep}*}\n\n\n"

      printf "${mseNewLine}" > "${mseNoteFile}"
      if [ $? != 0 ]; then
        mse_inter_showError "ERR::${lbl_info_noteAdd_cannotSave}"
      else
        mse_inter_showAlert "s" "${lbl_success_noteAdd}"

        mse_notes_metaDataUpdate "nextNoteId"
        mse_notes_shellNote "${mseNoteFile}"
      fi
    fi
  fi
}
MSE_GLOBAL_CMD["notes note add"]="mse_notes_noteAdd"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_noteAdd_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=5
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="Id :: r :: int"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="IniHour :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2"]="EndHour :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_3"]="FullHour :: o :: bool :: 0"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_4"]="NoteDate :: o :: string"
}
