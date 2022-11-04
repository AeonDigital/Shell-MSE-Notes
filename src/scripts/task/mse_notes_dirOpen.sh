#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Abre um diretório de notas.
#
# @param string $1
# Caminho até o diretório que será carregado.
mse_notes_dirOpen() {
  unset MSE_NOTES_DIRECTORY
  declare -gA MSE_NOTES_DIRECTORY
  MSE_NOTES_DIRECTORY["open"]="0"

  local mseDir=$(mse_str_replace "~" "${HOME}" "$1")
  local mseFeedBackMsg=""

  if [ ! -d "${mseDir}" ]; then
    mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_paramA_PointsToNonExistentDirectory}" "PARAM_A" "${mseDir}")
    mse_inter_showError "ERR::${mseFeedBackMsg} [${mseDir}]"
  else
    if [ "$(ls -A ${mseDir} 2> /dev/null)" == "" ]; then
      mse_notes_dirInit "${mseDir}"
    fi


    local mseNoteDir="${mseDir}/notes"
    local mseReportsDir="${mseDir}/reports"
    local mseTopicsDir="${mseDir}/topics"
    local mseMetaFile="${mseDir}/.meta"

    if [ ! -d "${mseNoteDir}" ] || [ ! -d "${mseReportsDir}" ] || [ ! -d "${mseTopicsDir}" ] || [ ! -f "${mseMetaFile}" ]; then
      mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_openDir_dirIsNotInitialized}" "DIR" "${mseDir}")
      mse_inter_showError "ERR::${mseFeedBackMsg}"
    else
      MSE_NOTES_DIRECTORY["open"]="1"
      MSE_NOTES_DIRECTORY["mainDir"]="${mseDir}"
      MSE_NOTES_DIRECTORY["notesDir"]="${mseNoteDir}"
      MSE_NOTES_DIRECTORY["reportsDir"]="${mseReportsDir}"
      MSE_NOTES_DIRECTORY["topicsDir"]="${mseTopicsDir}"
      MSE_NOTES_DIRECTORY["metaFile"]="${mseMetaFile}"

      #
      # Carrega o próximo id do próximo item a ser criado.
      declare -a mseTmpMetaContent=()
      readarray -t mseTmpMetaContent < "${mseMetaFile}"

      MSE_NOTES_DIRECTORY["nextItemId"]="${mseTmpMetaContent[0]}"
      MSE_NOTES_DIRECTORY["nextNoteId"]="${mseTmpMetaContent[1]}"

      #
      # Redefine a lista de tópicos
      mse_notes_redefineTopicList

      mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_success_openDir}" "DIR" "${mseDir}")
      mse_inter_showAlert "s" "${mseFeedBackMsg}"
    fi
  fi
}
MSE_GLOBAL_CMD["notes dir open"]="mse_notes_dirOpen"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_dirOpen_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=1
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="DirPath :: r :: dirName"
}
