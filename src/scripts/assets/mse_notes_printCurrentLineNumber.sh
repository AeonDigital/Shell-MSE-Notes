#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Printa o número da linha atual
#
# @param int $1
# Número da linha que será printado
mse_notes_printCurrentLineNumber() {
  local mseLine=""
  local mseLineRawNumber=${1}
  local mseLineNumberLength="${#mseLineRawNumber}"
  local mseLineNumberMaxLength="${#MSE_NOTES_INTERFACE_MAX_LINES}"

  local msePadChar="0"
  local msePadCounter=0
  ((msePadCounter = mseLineNumberMaxLength - mseLineNumberLength))


  #
  # Em caso de exceder o limite de linhas definidos
  local mseLine=""
  if [ ${mseLineRawNumber} -gt ${MSE_NOTES_INTERFACE_MAX_LINES} ]; then
    msePadChar="x"
    msePadCounter=${mseLineNumberMaxLength}
    mseLineRawNumber=""
  fi


  if [ ${msePadCounter} -ge 1 ]; then
    mseLine=$(eval printf "${msePadChar}%.0s" {1..$msePadCounter})
  fi
  mseLine+="${mseLineRawNumber} | "
  printf "${mseLine}"
}
