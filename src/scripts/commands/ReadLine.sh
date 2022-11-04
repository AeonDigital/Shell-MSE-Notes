#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("ReadLine;Reads a line of text entered by the user;;l")

#
# Executa o comando.
mse_notes_execCmdReadLine() {
  ((mseLineCounter = mseLineCounter + 1))
  local prompt=$(mse_notes_printCurrentLineNumber "${mseLineCounter}")


  read -r -p "${prompt}" -e mseLine
  if [ "${mseLine}" != "${mseEndFile}" ]; then
    if [ "${mseLine}" == "" ]; then
      printf "\n"
    else
      local mseRegEx
      local mseCmdName
      local mseCmdKey
      local mseCmdTarget

      #
      # Verifica se algum comando foi digitado pelo usuário
      for mseCmdName in "${MSE_NOTES_USER_CALLABLE_COMMAND_NAME[@]}"; do
        #
        # Até dar match com o primeiro comando identificado
        if [ "${mseCmdType}" == "ReadLine" ]; then
          mseCmdKey="${MSE_NOTES_USER_CALLABLE_COMMAND_KEY[$mseCmdName]}"
          mseCmdTarget="${MSE_NOTES_USER_CALLABLE_COMMAND_TARGET[$mseCmdName]}"
          mseRegEx='^(:'$mseCmdKey')$'
          if [ "${mseCmdTarget}" == "l" ]; then
            mseRegEx='^(:'$mseCmdKey')[0-9]+$'
          fi


          #
          # Sendo o comando que está sendo verificado...
          if [[ "${mseLine}" =~ $mseRegEx ]]; then
            mseCmdType="${mseCmdName}"

            #
            # Se o comando tem como alvo uma linha que deve ser especificada
            # pelo usuário, identifica e valida a mesma
            if [ "${mseCmdTarget}" == "l" ]; then
              mseRegEx='s/:'$mseCmdKey'//g'
              mseCmdTargetLine="$(printf "$mseLine" | sed -e "${mseRegEx}")"

              #
              # Identifica se a linha apontada existe
              if [ $mseCmdTargetLine -le ${#MSE_NOTES_FILE_CONTENT[@]} ]; then
                #
                # Identifica o índice da linha que será editada
                mseCmdTargetIndex=$mseCmdTargetLine
                ((mseCmdTargetIndex = mseCmdTargetIndex - 1))
              else
                mseCmdType="CommandError"
                mseCmdError="InvalidLine"
              fi

            fi
          fi

        fi
      done
    fi

    if [ "${mseCmdType}" == "ReadLine" ]; then
      #
      # Processa a quebra de linha caso seja para realizá-la
      if [ $MSE_NOTES_INTERFACE_BREAKLINE == 1 ] && [ ${#mseLine} -gt ${MSE_NOTES_INTERFACE_RULER_LENGTH} ] && [[ "${mseLine}" = *" "* ]]; then
        mse_notes_execCmdReadLine_BreakLine
      else
        MSE_NOTES_FILE_CONTENT+=("${mseLine}")
      fi

      mse_notes_execCmdReadLine_MaxLines
    fi
  fi
}





#
# Efetua o processamento da quebra automática de linhas
mse_notes_execCmdReadLine_BreakLine() {
  #
  # Splita a linha em palavras
  local mseLineWords
  readarray -d ' ' -t mseLineWords <<< "${mseLine}"


  #
  # Remove o '\n' adicionado ao final da última linha pelo comando 'readarray'
  local mseLastWordIndex="${#mseLineWords[@]}"
  ((mseLastWordIndex = mseLastWordIndex - 1))
  mseLineWords[$mseLastWordIndex]=$(printf "${mseLineWords[$mseLastWordIndex]}" | sed 's/^\s*//g' | sed 's/\s*$//g')


  local mseAtualWord=""
  local mseAtualWordLength=0
  local mseAtualLine=""
  local mseAtualLineLength=0
  for mseAtualWord in "${mseLineWords[@]}"; do
    mseAtualWordLength=${#mseAtualWord}
    mseAtualLineLength=${#mseAtualLine}
    ((mseAtualLineLength = mseAtualLineLength + mseAtualWordLength))

    #
    # se a linha ficar maior que a régua...
    if [ ${mseAtualLineLength} -gt ${MSE_NOTES_INTERFACE_RULER_LENGTH} ]; then
      MSE_NOTES_FILE_CONTENT+=("${mseAtualLine}")
      mseAtualLine=""
    elif [ ${#mseAtualLine} -gt 0 ]; then
      mseAtualLine+=" "
    fi

    mseAtualLine+="${mseAtualWord}"
  done

  if [ "${mseAtualLine}" != "" ]; then
    MSE_NOTES_FILE_CONTENT+=("${mseAtualLine}")
  fi

  mse_notes_execCmdRefreshNote "0"
}

#
# Efetua o processamento do controle de linha máxima
mse_notes_execCmdReadLine_MaxLines() {
  #
  # Em caso de exceder o limite de linhas definidos
  if [ ${#MSE_NOTES_FILE_CONTENT[@]} -gt ${MSE_NOTES_INTERFACE_MAX_LINES} ]; then
      MSE_NOTES_FILE_CONTENT=("${MSE_NOTES_FILE_CONTENT[@]:0:${MSE_NOTES_INTERFACE_MAX_LINES}}")
      mse_notes_execCmdRefreshNote "0"
  fi
}
