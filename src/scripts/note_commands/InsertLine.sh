#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("InsertLine;inserts a new line at the indicated position;il;l")

#
# Executa o comando 'InsertLine'
mse_notes_execCmdInsertLine() {
  local mseNewContent=("${MSE_NOTES_FILE_CONTENT[@]:0:$mseCmdTargetIndex}")
  mseNewContent+=("")
  mseNewContent+=("${MSE_NOTES_FILE_CONTENT[@]:$mseCmdTargetIndex}")
  MSE_NOTES_FILE_CONTENT=("${mseNewContent[@]}")

  mse_notes_execCmdRefreshNote "1"
}
