#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("RefreshNote;Refresh entire note in terminal;rn;")

#
# Executa o comando.
mse_notes_execCmdRefreshNote() {
  mseLineCounter=0
  MSE_NOTES_FILE_CONTENT=("${MSE_NOTES_FILE_CONTENT[@]}")

  clear
  mse_notes_printHeader
  for mseLine in "${MSE_NOTES_FILE_CONTENT[@]}"; do
    ((mseLineCounter = mseLineCounter + 1))
    mse_notes_printCurrentLineNumber "${mseLineCounter}"
    printf "%s\n" "${mseLine}"
  done


  #
  # Por padrão, quando evocado pelo usuário, exige
  # um ajuste de +1 para que a contagem das linhas prossiga corretamente.
  # No entanto, quando evocado em outros pontos, tal correção não é necessária
  # neste caso, se o parametro $1 for definido e for igual a '0' o ajuste
  # de linha será ignorado.
  local mseAdjustLineCounter=1
  if [ $# == 1 ] && [ $1 == 0 ]; then
    mseAdjustLineCounter=0
  fi

  if [ $mseAdjustLineCounter == 1 ]; then
    ((mseLineCounter = mseLineCounter + 1))
  fi
}
