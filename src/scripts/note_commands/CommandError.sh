#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("CommandError;Shows the error message of a command;;")

#
# Executa o comando.
mse_notes_execCmdCommandError() {
  if [ $mseCmdError == "InvalidLine" ]; then
    printf "::   Invalid Line Number; Choose a number between 1 and ${#MSE_NOTES_FILE_CONTENT[@]}\n"
  fi
}
