#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("RewriteNote;Rewrite entire clean note without command lines;rn;")

#
# Executa o comando.
mse_notes_execCmdRewriteNote() {
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
