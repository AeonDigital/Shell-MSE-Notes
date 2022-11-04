#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("Options;Show this options;opt;")

#
# Executa o comando.
mse_notes_execCmdOptions() {
  local mseRawTable="     Command|Name|Description\n"

  local mseCmdName
  local mseCmdKey
  local mseCmdDescription
  local mseCmdTarget
  for mseCmdName in "${MSE_NOTES_USER_CALLABLE_COMMAND_NAME[@]}"; do
    mseCmdKey="${MSE_NOTES_USER_CALLABLE_COMMAND_KEY[$mseCmdName]}"
    mseCmdDescription="${MSE_NOTES_USER_CALLABLE_COMMAND_DESCRIPTION[$mseCmdName]}"
    mseCmdTarget="${MSE_NOTES_USER_CALLABLE_COMMAND_TARGET[$mseCmdName]}"

    if [ "${mseCmdTarget}" == "l" ]; then
      mseCmdKey+="#"
    fi

    mseRawTable+="     :${mseCmdKey}|${mseCmdName}|${mseCmdDescription}\n"
  done

  clear
  mse_notes_printHeader
  printf "     ${mseCmdType}\n\n"
  mseRawTable=$(printf "${mseRawTable}")
  column -e -s "|" -t <<< "${mseRawTable}"

  printf "\n"
  read -n 1 -s -r -p "     Press any key to return"

  mse_notes_execCmdRefreshNote "1"
}
