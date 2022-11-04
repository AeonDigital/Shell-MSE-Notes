#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Carrega os módulos de comandos caso não tenham sido
# carregados ainda.
#
# @param bool $1
# Indique '1' para forçar o reload dos módulos.
# Omita ou indique '0' para que apenas seja feito o
# carregamento caso não tenha ocorrido ainda
mse_notes_loadCommands() {
  local mseForceLoad=0

  if [ $# -gt 0 ] && [ $1 == 1 ]; then
    mseForceLoad=1
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



    local mseTmpPathToCommands=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && cd .. && pwd )
    local msePathToCommand
    local mseFullFileName
    local mseCommandName

    #
    # Carrega cada um dos comandos existentes
    while read msePathToCommand; do
      mseFullFileName=$(basename -- "$msePathToCommand")
      mseCommandName="${mseFullFileName%.*}"

      unset "mse_notes_execCmd${mseCommandName}"
      . "$msePathToCommand" || true
    done <<< $(find "${mseTmpPathToCommands}/commands" -maxdepth 1 -name '*.sh' | sort)


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
