#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Printa o header de baixo
mse_notes_printFooter() {
  printf "     "
  eval printf "=%.0s" {1..$MSE_NOTES_INTERFACE_RULER_LENGTH}
  printf "\n"
  printf "     :: END NOTE\n"
}
