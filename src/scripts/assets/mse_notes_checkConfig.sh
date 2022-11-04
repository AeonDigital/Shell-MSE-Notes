#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Verifica se as configurações básicas estão definidas
# Estando, define-ás, não estando, usa os valores padrões.
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
      ((mseTotalChar = MSE_NOTES_INTERFACE_RULER_LENGTH * MSE_NOTES_INTERFACE_MAX_LINES))
      MSE_NOTES_INTERFACE_CONFIG+=("totalChar: ${mseTotalChar}")
    fi
  fi
}
