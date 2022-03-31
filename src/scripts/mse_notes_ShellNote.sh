#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Inicia um ShellNote
mse_notes_ShellNote() {
  unset MSE_NOTES_FILE_CONTENT
  declare -ga MSE_NOTES_FILE_CONTENT=()


  local mseLine=''
  local mseLineCounter=0
  local mseEndFile=':EOF'


  local mseCmdType='ReadLine'
  local mseCmdError=''
  local mseCmdFnName=''
  local mseCmdTargetLine=-1
  local mseCmdTargetIndex=-1
  local mseCmdAppendLine=1



  #
  # Use '1' quando estiver debugando os comandos
  mse_notes_loadCommands "0"

  local mseIFS="${IFS}"
  IFS=''
  clear
  mse_notes_printTopHeader

  while [ "${mseLine}" != "${mseEndFile}" ]; do
    #
    # Quando não for para adicionar uma nova linha de texto
    # no array da nota, significa que algum outro comando está
    # sendo executado.
    mseCmdAppendLine=1
    if [ "${mseCmdType}" != "ReadLine" ]; then
      mseCmdAppendLine=0
    fi

    #
    # Efetivamente executa o comando indicado
    mseCmdFnName="mse_notes_execCmd${mseCmdType}"
    "${mseCmdFnName}"

    #
    # Sempre que executar um comando diferente da leitura padrão
    # de texto para uma linha da nota, efetua alguns ajustes para
    # as variáveis de controle.
    if [ $mseCmdAppendLine == 0 ]; then
      mseCmdType="ReadLine"
      mseCmdError=''
      mseCmdFnName=''
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
# Carrega os módulos de comandos caso não tenham sido
# carregados ainda
#
# @param bool $1
# Indique '1' para forçar o reload dos módulos.
# Omita ou indique '0' para que apenas seja feito o
# carregamento caso não tenha ocorrido ainda
mse_notes_loadCommands() {
  local mseForceLoad=0

  if [ $# -gt 0 ]; then
    if [ $1 == 1 ]; then
      mseForceLoad=1
    fi
  fi


  #
  # Inicia o editor carregando
  # cada um dos comandos existentes
  if [ $mseForceLoad == 1 ] || [ "${#MSE_NOTES_RAW_COMMAND[@]}" == 0 ]; then
    unset MSE_NOTES_RAW_COMMAND
    declare -ga MSE_NOTES_RAW_COMMAND=()

    unset MSE_NOTES_USER_CALLABLE_COMMAND_NAME
    declare -ga MSE_NOTES_USER_CALLABLE_COMMAND_NAME=()

    unset MSE_NOTES_USER_CALLABLE_COMMAND_DESCRIPTION
    declare -gA MSE_NOTES_USER_CALLABLE_COMMAND_DESCRIPTION

    unset MSE_NOTES_USER_CALLABLE_COMMAND_KEY
    declare -gA MSE_NOTES_USER_CALLABLE_COMMAND_KEY

    unset MSE_NOTES_USER_CALLABLE_COMMAND_TARGET
    declare -gA MSE_NOTES_USER_CALLABLE_COMMAND_TARGET



    local nseTmpPathToCommands=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    local msePathToCommand
    local mseFullFileName
    local mseCommandName

    #
    # Carrega cada um dos comandos existentes
    while read msePathToCommand
    do
      mseFullFileName=$(basename -- "$msePathToCommand")
      mseCommandName="${mseFullFileName%.*}"

      unset "mse_notes_execCmd${mseCommandName}"
      . "$msePathToCommand" || true
    done <<< $(find "${nseTmpPathToCommands}/note_commands" -maxdepth 1 -name '*.sh')


    #
    # Processa os comandos encontrados
    local mseRawCommand
    local mseStrSplit
    local mseCmdName
    for mseRawCommand in "${MSE_NOTES_RAW_COMMAND[@]}"; do
      readarray -d ';' -t mseStrSplit <<< "${mseRawCommand}"

      #
      # Registra apenas os comandos que estão corretamente definidos e
      # que são possíveis de serem evocados pelo usuário
      if [ "${#mseStrSplit[@]}" == 4 ] && [ "${mseStrSplit[2]}" != "" ]; then
        mseCmdName="${mseStrSplit[0]}"

        MSE_NOTES_USER_CALLABLE_COMMAND_NAME+=("${mseCmdName}")
        MSE_NOTES_USER_CALLABLE_COMMAND_DESCRIPTION["${mseCmdName}"]="${mseStrSplit[1]}"
        MSE_NOTES_USER_CALLABLE_COMMAND_KEY["${mseCmdName}"]="${mseStrSplit[2]}"

        #
        # O here-string (operador <<<) usado no 'split' das informações
        # gera um \n no conteúdo do último item do array, para sanar,
        # é aplicado um 'trim' conforme abaixo
        MSE_NOTES_USER_CALLABLE_COMMAND_TARGET["${mseCmdName}"]=$(printf "${mseStrSplit[3]}" | sed 's/^\s*//g' | sed 's/\s*$//g')
      fi
    done
  fi
}



#
# Printa o header de topo
mse_notes_printTopHeader() {
  printf ":: SHELL NOTE \n"
  printf -- "=%.0s" {1..80}
  printf "\n"
}
#
# Printa o header de baixo
mse_notes_printBottomHeader() {
  printf -- '=%.0s' {1..80}
  printf "\n"
  printf ":: END NOTE\n"
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
