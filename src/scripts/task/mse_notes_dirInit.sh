#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Inicia um diretório de notas.
#
# @param string $1
# Caminho até o diretório que será iniciado.
mse_notes_dirInit() {
  local mseDir=$(mse_str_replace "~" "${HOME}" "$1")
  local mseFeedBackMsg=""

  if [ ! -d "${mseDir}" ]; then
    mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_paramA_PointsToNonExistentDirectory}" "PARAM_A" "\$1")
    mse_inter_showError "ERR::${mseFeedBackMsg} [${mseDir}]"
  else
    if [ "$(ls -A ${mseDir} 2> /dev/null)" != "" ]; then
      mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_initDir_dirIsNotEmpty}" "DIR" "${mseDir}")
      mse_inter_showError "ERR::${mseFeedBackMsg}"
    else
      local mseNoteDir="${mseDir}/notes"
      mkdir "${mseNoteDir}"

      if [ $? != 0 ]; then
        mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_cannotCreateNewDirectoryIn}" "LOCAL" "${mseNoteDir}")
        mse_inter_showError "ERR::${mseFeedBackMsg}"
      else
        local mseReportsDir="${mseDir}/reports"
        mkdir "${mseReportsDir}"

        if [ $? != 0 ]; then
          mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_cannotCreateNewDirectoryIn}" "LOCAL" "${mseReportsDir}")
          mse_inter_showError "ERR::${mseFeedBackMsg}"
        else
          local mseTopicsDir="${mseDir}/topics"
          mkdir "${mseTopicsDir}"

          if [ $? != 0 ]; then
            mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_cannotCreateNewDirectoryIn}" "LOCAL" "${mseTopicsDir}")
            mse_inter_showError "ERR::${mseFeedBackMsg}"
          else
            local mseMetaFile="${mseDir}/.meta"
            printf "1\n1" > "${mseMetaFile}"

            if [ $? != 0 ]; then
              mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_err_cannotCreateNewFileIn}" "LOCAL" "${mseMetaFile}")
              mse_inter_showError "ERR::${mseFeedBackMsg}"
            else
              mseFeedBackMsg=$(mse_str_replacePlaceHolder "${lbl_success_initDir}" "DIR" "${mseDir}")
              mse_inter_showAlert "s" "${mseFeedBackMsg}"
            fi
          fi
        fi
      fi
    fi
  fi
}
MSE_GLOBAL_CMD["notes dir init"]="mse_notes_dirInit"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_dirInit_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=1
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="DirPath :: r :: dirName"
}
