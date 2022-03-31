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
  clear
  printf "::   ${mseCmdType}\n\n"

  local mseRawTable="Command|Name|Description\n"
  mseRawTable+=":el@|EditLine|Edit single line defined in @\n"
  mseRawTable+=":cl@|ClearLine|Remove entire text from line defined in @\n"
  mseRawTable+=":rl@|RemoveLine|Remove the line defined in @\n"
  mseRawTable+=":rn@|RewriteNote|Rewrite entire clean note without command lines\n"
  mseRawTable+=":q  |Quit|Exit from editor\n"
  mseRawTable+=":o  |Options|Show this options\n"

  mseRawTable=$(printf "${mseRawTable}")
  column -e -s "|" -t <<< "${mseRawTable}"

  printf "\n"
  read -n 1 -s -r -p "Press any key to return"

  mse_notes_execCmdRewriteNote
}
