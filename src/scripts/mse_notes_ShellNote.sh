#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Inicia um ShellNote
#
# @param string $1
# Caminho até um arquivo que deve ser carregado.
# Se nada for indicado abrirá uma nova nota.
mse_notes_ShellNote() {
  unset MSE_NOTES_FILE_CONTENT
  declare -ga MSE_NOTES_FILE_CONTENT=()


  mse_notes_checkConfig
  if [ $# -gt 0 ]; then
    mse_notes_checkArgFileName "$1"
  fi



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


  #
  # Sendo para abrir uma nova nota...
  if [ "${#MSE_NOTES_FILE_CONTENT[@]}" == 0 ]; then
    clear
    mse_notes_printTopHeader
  else
    mse_notes_execCmdRewriteNote "0"
  fi


  local mseIFS="${IFS}"
  IFS=''

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
# Verifica se as configurações básicas estão definidas
mse_notes_checkConfig() {
  declare -ga MSE_NOTES_INTERFACE_CONFIG=()

  #
  # Garante que existirá uma 'regua' e que ela terá o tamanho
  # mínimo especificado
  local mseMinRulerLength=25
  if [ -z ${MSE_NOTES_INTERFACE_RULER_LENGTH+x} ]; then
    MSE_NOTES_INTERFACE_RULER_LENGTH=80
  elif [ ${MSE_NOTES_INTERFACE_RULER_LENGTH} -lt ${mseMinRulerLength} ]; then
    MSE_NOTES_INTERFACE_RULER_LENGTH=${mseMinRulerLength}
  fi
  MSE_NOTES_INTERFACE_CONFIG+=("rulerLength: ${MSE_NOTES_INTERFACE_RULER_LENGTH}")


  #
  # Identifica se deve ocorrer uma quebra de linha obrigatória para
  # casos onde a linha digitada pelo usuário ultrapasse o tamanho da regua
  local mseBreakLine='n'
  if [ -z ${MSE_NOTES_INTERFACE_BREAKLINE+x} ]; then
    MSE_NOTES_INTERFACE_BREAKLINE=1
  fi
  if [ "${MSE_NOTES_INTERFACE_BREAKLINE}" == 1 ]; then
    mseBreakLine='y'
  fi
  MSE_NOTES_INTERFACE_CONFIG+=("breakLine: ${mseBreakLine}")


  #
  # Identifica o tamanho máximo 'em linhas' que a nota pode ter.
  # Notas abertas com tamanho maior que este serão truncadas.
  if [ -z ${MSE_NOTES_INTERFACE_MAX_LINES+x} ]; then
    MSE_NOTES_INTERFACE_MAX_LINES=20
  fi
  if [ "${MSE_NOTES_INTERFACE_MAX_LINES}" -gt 0 ]; then
    MSE_NOTES_INTERFACE_CONFIG+=("maxLines: ${MSE_NOTES_INTERFACE_MAX_LINES}")

    if [ "${MSE_NOTES_INTERFACE_BREAKLINE}" == 1 ]; then
      local mseTotalChar
      ((mseTotalChar=MSE_NOTES_INTERFACE_RULER_LENGTH*MSE_NOTES_INTERFACE_MAX_LINES))
      MSE_NOTES_INTERFACE_CONFIG+=("totalChar: ${mseTotalChar}")
    fi
  fi
}



#
# Verifica o argumento 'FileName' ($1).
# que indica o arquivo alvo da edição sendo feita.
mse_notes_checkArgFileName() {
  #
  # Identifica se é para abrir um arquivo existente
  if [ "$1" != "" ]; then
    MSE_NOTES_INTERFACE_FILE=$(realpath "$1")
    if [ -f "${MSE_NOTES_INTERFACE_FILE}" ]; then
      readarray -t MSE_NOTES_FILE_CONTENT < "${MSE_NOTES_INTERFACE_FILE}"

      local mseTotalLines="${#MSE_NOTES_FILE_CONTENT[@]}"
      if [ "${mseTotalLines}" -gt 0 ]; then
        #
        # Remove o '\n' adicionado ao final da última linha pelo comando 'readarray'
        local mseLastLineIndex="${mseTotalLines}"
        ((mseLastLineIndex=mseLastLineIndex-1))

        MSE_NOTES_FILE_CONTENT[$mseLastLineIndex]=$(printf "${MSE_NOTES_FILE_CONTENT[$mseLastLineIndex]}" | sed 's/^\s*//g' | sed 's/\s*$//g')
      fi
    fi
  fi
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
  printf "     :: SHELL NOTE \n"
  printf "     >> ${MSE_NOTES_INTERFACE_FILE} \n"

  local mseConfigLine
  if [ "${#MSE_NOTES_INTERFACE_CONFIG[@]}" -gt 0 ]; then
    printf "     [ "

    for mseConfigLine in "${MSE_NOTES_INTERFACE_CONFIG[@]}"; do
      printf "${mseConfigLine}; "
    done
    printf "]\n"
  fi

  printf "     "
  eval printf "=%.0s" {1..$MSE_NOTES_INTERFACE_RULER_LENGTH}
  printf "\n"
}
#
# Printa o header de baixo
mse_notes_printBottomHeader() {
  printf "     "
  eval printf "=%.0s" {1..$MSE_NOTES_INTERFACE_RULER_LENGTH}
  printf "\n"
  printf "     :: END NOTE\n"
}
#
# Printa o número da linha atual
#
# @param int $1
# Número da linha que será printado
mse_notes_printCurrentLineNumber() {
  #
  # Em caso de exceder o limite de linhas definidos
  if [ $1 -gt ${MSE_NOTES_INTERFACE_MAX_LINES} ]; then
    printf "xx | "
  else
    if [ $1 -lt 10 ]; then
      printf "0"
    fi
    printf "$1 | "
  fi
}
