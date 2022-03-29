#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]
#
# No diretório raiz use o comando abaixo para iniciar
# este módulo de forma independente
# . src/loadModule.sh



#
# Identifica o tipo de inicialização
if [ -z ${MSE_TMP_THIS_MODULE_NAME+x} ]; then
  MSE_TMP_THIS_MODULE_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
  . "${MSE_TMP_THIS_MODULE_DIRECTORY}/config/load.sh"

  MSE_TMP_STANDALONE=1
  unset MSE_TMP_THIS_MODULE_NAME
fi



if [ $MSE_TMP_ISOK == 1 ]; then
  #
  # Se o locale para as mensagens não está definido, usa o padrão 'en-us',
  if [ -z ${MSE_GLOBAL_MODULE_LOCALE+x} ]; then
    MSE_GLOBAL_MODULE_LOCALE="en-us"
  fi
  MSE_TMP_PATH_TO_LOCALE="${MSE_TMP_THIS_MODULE_DIRECTORY}/locale/${MSE_GLOBAL_MODULE_LOCALE}.sh"
  if [ ! -f "${MSE_TMP_PATH_TO_LOCALE}" ]; then
    MSE_TMP_PATH_TO_LOCALE="${MSE_TMP_THIS_MODULE_DIRECTORY}/locale/en-us.sh"
  fi
  . "${MSE_TMP_PATH_TO_LOCALE}"
  unset MSE_TMP_PATH_TO_LOCALE



  #
  # Carrega as variáveis do módulo caso um arquivo 'variables.sh' esteja definido
  if [ -f "${MSE_TMP_THIS_MODULE_DIRECTORY}/config/variables.sh" ]; then
    . "${MSE_TMP_THIS_MODULE_DIRECTORY}/config/variables.sh"
  fi

  #
  # Carrega os 'aliases' do módulo caso um arquivo 'aliases.sh' esteja definido
  if [ -f "${MSE_TMP_THIS_MODULE_DIRECTORY}/config/aliases.sh" ]; then
    . "${MSE_TMP_THIS_MODULE_DIRECTORY}/config/aliases.sh"
  fi



  #
  # Conforme o tipo de inicialização...
  if [ $MSE_TMP_STANDALONE == 0 ]; then
    #
    # Registra/inicia este módulo usando o módulo principal.
    mse_mmod_registerModule "${MSE_TMP_THIS_MODULE_NAME}" "${MSE_TMP_THIS_MODULE_DIRECTORY}"
  else
    mseModFiles=$(find "${MSE_TMP_THIS_MODULE_DIRECTORY}/scripts" -name "*.sh")

    #
    # Carrega os arquivos de scripts deste módulo
    while read rawLine
    do
      mseFullFileName=$(basename -- "$rawLine")
      mseScriptName="${mseFullFileName%.*}"

      unset "${mseScriptName}"
      . "$rawLine" || true
    done <<< ${mseModFiles}

    unset mseModFiles
    unset rawLine
    unset mseFullFileName
    unset mseScriptName
  fi



  #
  # Existindo dependências para o funcionamento deste módulo,
  # tenta carregá-las
  if [ ${#MSE_TMP_THIS_MODULE_DEPENDENCY[@]} -gt 0 ]; then
    for mseDependency in "${MSE_TMP_THIS_MODULE_DEPENDENCY[@]}";
    do
      #
      # Conforme o tipo de inicialização...
      if [ $MSE_TMP_STANDALONE == 0 ]; then

        #
        # Se o módulo ainda não foi carregado
        mseIsDependencyModuleLoaded=$(mse_mmod_checkIfHasValueInArray "${mseDependency}" "MSE_GLOBAL_MODULES_NAMES")
        if [ $mseIsDependencyModuleLoaded == 0 ]; then
          msePathToModule="${MSE_TMP_THIS_MODULE_DIRECTORY}/../${mseDependency}/src/init.sh"
          if [ -f "${msePathToModule}" ]; then
            . "${msePathToModule}"

            MSE_TMP_THIS_MODULE_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
            . "${MSE_TMP_THIS_MODULE_DIRECTORY}/config/load.sh"
          else
            MSE_TMP_ISOK=0
            mse_mmod_replacePlaceHolder "MODULE" "${mseDependency}" "${lbl_generic_ModuleNotFound}"
            printf "${msePathToModule}\n"
          fi
        fi

        unset mseIsDependencyModuleLoaded
      else

        msePathToModule="${MSE_TMP_THIS_MODULE_DIRECTORY}/../${mseDependency}/src/loadModule.sh"
        if [ -f "${msePathToModule}" ]; then
          . "${msePathToModule}"

          MSE_TMP_THIS_MODULE_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
          . "${MSE_TMP_THIS_MODULE_DIRECTORY}/config/load.sh"

          MSE_TMP_STANDALONE=1
          unset MSE_TMP_THIS_MODULE_NAME
        else
          printf "\n"
          printf "    Attention\n"
          printf "    The module \"${mseDependency}\" was not found.\n"
          printf "    in the expected location:\n"
          printf "    ${msePathToModule} \n"
          printf "\n"
        fi
      fi
    done

    unset mseDependency
    unset msePathToModule
  fi
fi



if [ $MSE_TMP_STANDALONE == 1 ]; then
  unset MSE_TMP_ISOK
  unset MSE_TMP_STANDALONE
  unset MSE_TMP_THIS_MODULE_DIRECTORY
  unset MSE_TMP_THIS_MODULE_DEPENDENCY
fi
