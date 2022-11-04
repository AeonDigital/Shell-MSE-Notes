#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Cria/abre uma nota.
#
# @param string $1
# Caminho até um arquivo que deve ser carregado.
# Se nada for indicado abrirá uma nova nota.
#
# @param string $2
# Caminho até um arquivo que possui as instruções para a
# montagem de um formulário a ser implementado.
#
# @obs
# Se tiver dúvidas sobre o uso das notas, digite o comando
# :opt
# no início de uma linha e precione enter para ver as demais
# possibilidades de controles de edição.
mse_notes_shellNote() {
  mse_notes_checkConfig

  local mseTmpFile=""
  if [ $# -gt 0 ]; then
    mseTmpFile=$(mse_str_replace "~" "${HOME}" "$1")
  fi
  mse_notes_checkArgFileName "${mseTmpFile}"



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
  mse_notes_loadCommands "1"


  #
  # Sendo para abrir uma nova nota...
  if [ "${#MSE_NOTES_FILE_CONTENT[@]}" == 0 ]; then
    clear
    mse_notes_printHeader
  else
    mse_notes_execCmdRefreshNote "0"
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
      ((mseLineCounter = mseLineCounter - 1))
    fi
  done

  IFS="${mseIFS}"
  mse_notes_printFooter
}
MSE_GLOBAL_CMD["notes shellNote"]="mse_notes_shellNote"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_shellNote_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=2
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="FilePath :: o :: fileName"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="FormModel :: o :: fileName"
}
