#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("ClearLine;Completely removes text from the indicated line;cl;l")

#
# Executa o comando 'ClearLine'
mse_notes_execCmdClearLine() {
  printf "::   ${mseCmdType} ${mseCmdTargetLine}\n"

  MSE_NOTES_FILE_CONTENT[$mseCmdTargetIndex]=""
}
