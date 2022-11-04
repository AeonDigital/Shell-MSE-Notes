#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("EditLine;Edit the text of the indicated line;el;l")

#
# Executa o comando.
mse_notes_execCmdEditLine() {
  printf "::   ${mseCmdType} ${mseCmdTargetLine}\n"

  mseLine="${MSE_NOTES_FILE_CONTENT[$mseCmdTargetIndex]}"
  read -r -e -i "${mseLine}" mseLine
  MSE_NOTES_FILE_CONTENT[$mseCmdTargetIndex]="${mseLine}"
}
