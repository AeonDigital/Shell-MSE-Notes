#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Verifica se existem atualizações a serem feitas.
mse_notes_freeNote() {
  local mseIFS="${IFS}"

  MSE_NOTES_FILE_CONTENT=()
  local mseLine=''
  local mseLineCounter=0


  local mseRegEx=''
  local mseCmdType='ReadLine'
  local mseCmdError=''
  local mseCmdFnName=''
  local mseCmdTargetLine=-1
  local mseCmdTargetIndex=-1
  local mseCmdIsReadLine=1

  local mseEndFile=':EOF'


  IFS=''
  clear
  mse_notes_printTopHeader

  while [ "${mseLine}" != "${mseEndFile}" ]; do
    mseCmdIsReadLine=1
    mseCmdFnName="mse_notes_cmd${mseCmdType}"

    if [ "${mseCmdType}" != "ReadLine" ]; then
      mseCmdIsReadLine=0
    fi

    #
    # Efetivamente executa o comando
    "${mseCmdFnName}"

    #
    # Tendo executado qualquer comando diferente
    # de 'ReadLine'
    if [ $mseCmdIsReadLine == 0 ]; then
      mseCmdType="ReadLine"
      mseCmdError=''
      mseCmdTargetLine=-1
      mseCmdTargetIndex=-1
      ((mseLineCounter=mseLineCounter-1))
    fi
  done

  IFS="${mseIFS}"
  mse_notes_printBottomHeader

  printf "%s\n" "${MSE_NOTES_FILE_CONTENT[@]}"
}





#
# Printa o header de topo
mse_notes_printTopHeader() {
  printf ":: INI NOTE\n"
  printf -- "=%.0s" {1..80}
  printf "\n"
}
#
# Printa o número da linha atual
#
# @param int $1
# Número da linha que será printado
mse_notes_printCurrentLineNumber() {
  if [ $1 -lt 10 ]; then
    printf "0"
  fi
  printf "$1 | "
}
#
# Printa o header de baixo
mse_notes_printBottomHeader() {
  printf -- '=%.0s' {1..80}
  printf "\n"
  printf ":: END NOTE\n"
}





#
# Verifica se a linha selecionada para executar um comando
# é válida. Sendo, aplica o comando selecionado
#
# @param string $1
# Comando que será aplicado caso a linha selecionada seja
# válida.
mse_notes_checkSelectedLineNumber() {
  #
  # Identifica se a linha apontada existe
  if [ $mseCmdTargetLine -le ${#MSE_NOTES_FILE_CONTENT[@]} ]; then
    mseCmdType="$1"

    #
    # Identifica o índice da linha que será editada
    mseCmdTargetIndex=$mseCmdTargetLine
    ((mseCmdTargetIndex=mseCmdTargetIndex-1))
  else
    mseCmdType="CommandError"
    mseCmdError="InvalidLine"
  fi
}




#
# Printa uma mensagem de erro conforme o tipo do
# erro ocorrido
mse_notes_cmdCommandError() {
  if [ $mseCmdError == "InvalidLine" ]; then
    printf "::   Invalid Line Number; Choose a number between 1 and ${#MSE_NOTES_FILE_CONTENT[@]}\n"
  fi
}





#
# Comando responsável por ler cada linha e identificar
# quando há um comando especial setado pelo usuário
mse_notes_cmdReadLine() {
  ((mseLineCounter=mseLineCounter+1))
  mse_notes_printCurrentLineNumber "${mseLineCounter}"


  read -r -e mseLine
  if [ "${mseLine}" != "${mseEndFile}" ]; then
    if [ "${mseLine}" == "" ]; then
      printf "\n"
    else
      mse_notes_checkCmdEditLine
      mse_notes_checkCmdClearLine
      mse_notes_checkCmdRemoveLine
      mse_notes_checkCmdRewriteNote
      mse_notes_checkCmdQuit
      mse_notes_checkCmdOptions
    fi

    if [ "${mseCmdType}" == "ReadLine" ]; then
      MSE_NOTES_FILE_CONTENT+=("${mseLine}")
    fi
  fi
}





#
# Identifica a entrada do comando 'EditLine'
mse_notes_checkCmdEditLine() {
  if [ "${mseCmdType}" == "ReadLine" ]; then
    #
    # Regex que identifica o comando
    mseRegEx='^(:el)[0-9]+$'
    if [[ "${mseLine}" =~ $mseRegEx ]]; then
      #
      # Identifica a linha alvo
      mseRegEx='s/:el//g'
      mseCmdTargetLine="$(printf "$mseLine" | sed -e "${mseRegEx}")"

      mse_notes_checkSelectedLineNumber "EditLine"
    fi
  fi
}
#
# Executa o comando 'EditLine'
mse_notes_cmdEditLine() {
  printf "::   ${mseCmdType} ${mseCmdTargetLine}\n"

  mseLine="${MSE_NOTES_FILE_CONTENT[$mseCmdTargetIndex]}"
  read -r -e -i "${mseLine}" mseLine
  MSE_NOTES_FILE_CONTENT[$mseCmdTargetIndex]="${mseLine}"
}





#
# Identifica a entrada do comando 'ClearLine'
mse_notes_checkCmdClearLine() {
  if [ "${mseCmdType}" == "ReadLine" ]; then
    #
    # Regex que identifica o comando
    mseRegEx='^(:cl)[0-9]+$'
    if [[ "${mseLine}" =~ $mseRegEx ]]; then
      #
      # Identifica a linha alvo
      mseRegEx='s/:cl//g'
      mseCmdTargetLine="$(printf "$mseLine" | sed -e "${mseRegEx}")"

      mse_notes_checkSelectedLineNumber "ClearLine"
    fi
  fi
}
#
# Executa o comando 'ClearLine'
mse_notes_cmdClearLine() {
  printf "::   ${mseCmdType} ${mseCmdTargetLine}\n"

  MSE_NOTES_FILE_CONTENT[$mseCmdTargetIndex]=""
}





#
# Identifica a entrada do comando 'RemoveLine'
mse_notes_checkCmdRemoveLine() {
  if [ "${mseCmdType}" == "ReadLine" ]; then
    #
    # Regex que identifica o comando
    mseRegEx='^(:rl)[0-9]+$'
    if [[ "${mseLine}" =~ $mseRegEx ]]; then
      #
      # Identifica a linha alvo
      mseRegEx='s/:rl//g'
      mseCmdTargetLine="$(printf "$mseLine" | sed -e "${mseRegEx}")"

      mse_notes_checkSelectedLineNumber "RemoveLine"
    fi
  fi
}
#
# Executa o comando 'RemoveLine'
mse_notes_cmdRemoveLine() {
  printf "::   ${mseCmdType} ${mseCmdTargetLine}\n"

  unset MSE_NOTES_FILE_CONTENT[$mseCmdTargetIndex]
  mse_notes_cmdRewriteNote
}





#
# Identifica a entrada do comando 'RewriteNote'
mse_notes_checkCmdRewriteNote() {
  if [ "${mseCmdType}" == "ReadLine" ]; then
    #
    # Regex que identifica o comando
    mseRegEx='^(:rn)$'
    if [[ "${mseLine}" =~ $mseRegEx ]]; then
      mseCmdType="RewriteNote"
    fi
  fi
}
#
# Executa o comando 'RewriteNote'
mse_notes_cmdRewriteNote() {
  mseLineCounter=0

  clear
  mse_notes_printTopHeader
  for mseLine in "${MSE_NOTES_FILE_CONTENT[@]}"; do
    ((mseLineCounter=mseLineCounter+1))
    mse_notes_printCurrentLineNumber "${mseLineCounter}"
    printf "%s\n" "${mseLine}"
  done

  ((mseLineCounter=mseLineCounter+1))
}





#
# Identifica a entrada do comando 'Quit'
mse_notes_checkCmdQuit() {
  if [ "${mseCmdType}" == "ReadLine" ]; then
    #
    # Regex que identifica o comando
    mseRegEx='^(:q)$'
    if [[ "${mseLine}" =~ $mseRegEx ]]; then
      mseCmdType="Quit"
    fi
  fi
}
#
# Executa o comando 'Quit'
mse_notes_cmdQuit() {
  mseLine=':EOF'
}





#
# Identifica a entrada do comando 'Options'
mse_notes_checkCmdOptions() {
  if [ "${mseCmdType}" == "ReadLine" ]; then
    #
    # Regex que identifica o comando
    mseRegEx='^(:o)$'
    if [[ "${mseLine}" =~ $mseRegEx ]]; then
      mseCmdType="Options"
    fi
  fi
}
#
# Executa o comando 'Options'
mse_notes_cmdOptions() {
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

  mse_notes_cmdRewriteNote
}
