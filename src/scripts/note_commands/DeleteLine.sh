#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("DeleteLine;Completely remove the indicated line;dl;l")

#
# Executa o comando.
mse_notes_execCmdDeleteLine() {
  printf "::   ${mseCmdType} ${mseCmdTargetLine}\n"

  unset MSE_NOTES_FILE_CONTENT[$mseCmdTargetIndex]
  mse_notes_execCmdRefreshNote "1"
}
