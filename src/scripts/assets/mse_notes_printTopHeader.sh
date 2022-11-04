#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Printa o header de topo
mse_notes_printHeader() {
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