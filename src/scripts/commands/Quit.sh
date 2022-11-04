#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("Quit;Exit from editor;q;")
MSE_NOTES_RAW_COMMAND+=("QuitWithoutSave;Exit from editor without save;q!;")

#
# Executa o comando.
mse_notes_execCmdQuit() {
  local msePromptRead=""
  local msePromptOption=""


  #
  # Caso esteja executando uma ação de sair sem salvar
  if [ "${mseCmdType}" == "QuitWithoutSave" ]; then
    msePromptOption="y"
  else
    clear
    mse_notes_printHeader
    printf "     ${mseCmdType}\n\n"
    printf "     all changes will be lost, confirm? \n"

    while [ "${msePromptOption}" == "" ]; do
      read -r -e -p "     [y|n] " msePromptRead

      if [ "${msePromptRead}" == "y" ] || [ "${msePromptRead}" == "n" ]; then
        msePromptOption="${msePromptRead}"
      fi
    done
  fi


  if [ "${msePromptOption}" == "y" ]; then
    mseLine=':EOF'
  else
    mse_notes_execCmdRefreshNote "1"
  fi
}



#
# Força a ação de sair sem salvar
mse_notes_execCmdQuitWithoutSave() {
  mse_notes_execCmdQuit
}
