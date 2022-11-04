#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula).
#
# Veja mais informações sobre como preencher esta informação no
# arquivo /src/config/variables.sh
MSE_NOTES_RAW_COMMAND+=("Write;save the note in the indicated location;w;")
MSE_NOTES_RAW_COMMAND+=("WriteAndQuit;save the note in the indicated location and quit;wq;")


#
# Executa o comando.
mse_notes_execCmdWrite() {

  local mseErr=0
  local msePromptRead=""
  local mseSaveOption=""
  local mseValidOptions='^(y|n|yes|as|no)$'


  #
  # Uma ação de 'salvar e sair' só é possível se já há um arquivo
  # indicado para edição. De outra forma, ativará a ação padrão 'Salvar'
  if [ "${mseCmdType}" == "WriteAndQuit" ]; then
    if [ "${MSE_NOTES_INTERFACE_FILE}" == "" ]; then
      mseCmdType="Write"
    else
      mseSaveOption="y"
    fi
  fi


  #
  # Sendo uma ação padrão 'salvar'
  if [ "${mseCmdType}" == "Write" ]; then
    clear
    mse_notes_printHeader
    printf "     ${mseCmdType}\n\n"


    #
    # Havendo um erro ao salvar uma nota, abre este comando
    # com uma mensagem de alerta
    if [ $# -gt 0 ]; then
      case "$1" in
        1)
          printf "     You need to inform where the note should be saved \n"
        ;;

        2)
          printf "     An unexpected error occurred and the note could not be saved \n"
          printf "     Do you have permission to save to this location? \n"
        ;;
      esac

      printf "\n"
    fi


    #
    # Informa as opções do usuário conforme a definição ou não de um arquivo
    # alvo para ser salvo.
    if [ "${MSE_NOTES_INTERFACE_FILE}" == "" ]; then
      printf "     type 'n' to cancel or inform where the note should be saved \n"
      mseSaveOption="as"
    else
      printf "     Select an option \n"
      printf "     y|yes  [ save to ${MSE_NOTES_INTERFACE_FILE} ] \n"
      printf "     as     [ save as ] \n"
      printf "     n|no   [ cancel ] \n"

      while [ "${mseSaveOption}" == "" ]; do
        read -r -e -p "     : " msePromptRead

        if [[ "${msePromptRead}" =~ $mseValidOptions ]]; then
          mseSaveOption="${msePromptRead}"

          case "${mseSaveOption}" in
            yes)
              mseSaveOption="s"
            ;;
            no)
              mseSaveOption="n"
            ;;
          esac
        fi
      done
    fi


    #
    # Sendo uma ação 'salvar como'
    if [ "${mseSaveOption}" == "as" ]; then
      read -r -e -p "     save as: " msePromptRead
      msePromptRead=$(mse_str_replace "~" "${HOME}" "${msePromptRead}")


      if [ "${msePromptRead}" == "" ]; then
        mseSaveOption="err"
        mseErr=1
      elif [ "${msePromptRead}" == "n" ]; then
        msePromptRead="n"
      else
        #
        # Se o arquivo informado não existe, OU
        # sendo diferente do arquivo originalmente informado ao abrir o editor
        # Aceita o valor imediatamente
        if [ ! -f "${msePromptRead}" ] || [ "${msePromptRead}" == "${MSE_NOTES_INTERFACE_FILE}" ]; then
          mseSaveOption="y"
          MSE_NOTES_INTERFACE_FILE="${msePromptRead}"
        else
          #
          # Questiona o usuário sobre a sobrescrita do arquivo alvo
          local mseOverwriteOption=""

          while [ "${mseOverwriteOption}" == "" ]; do
            printf "     The file already exists, overwrite? \n"
            read -r -e -p "     [y|n] " msePromptRead

            if [ "${msePromptRead}" == "y" ] || [ "${msePromptRead}" == "n" ]; then
              mseOverwriteOption="${msePromptRead}"
              mseSaveOption="${msePromptRead}"
            fi
          done
        fi
      fi
    fi
  fi



  #
  # Conforme a opção de ação definida pelo usuário
  case "${mseSaveOption}" in
    y)
      #
      # Efetivamente salva a nota com os dados atuais
      printf "%s\n" "${MSE_NOTES_FILE_CONTENT[@]}" > "${MSE_NOTES_INTERFACE_FILE}"

      if [ $? == 0 ]; then
        if [ "${mseCmdType}" == "WriteAndQuit" ]; then
          mseCmdType="QuitWithoutSave"
          mse_notes_execCmdQuit
        else
          mse_notes_execCmdRefreshNote "1"
        fi
      else
        mse_notes_execCmdWrite "2"
      fi
    ;;

    n)
      mse_notes_execCmdRefreshNote "1"
    ;;

    err)
      mse_notes_execCmdWrite "${mseErr}"
    ;;
  esac
}



#
# Executa o comando.
mse_notes_execCmdWriteAndQuit() {
  mse_notes_execCmdWrite
}
