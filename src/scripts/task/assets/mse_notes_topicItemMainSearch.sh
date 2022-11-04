#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Efetua uma busca entre todos os tópicos de notas por aqueles itens que
# correspondem às informações de consulta passadas.
# O resultado será adicionado no array "MSE_NOTES_SEARCH".
#
# No início de cada linha serão adicionadas novas colunas de dados que trazem
# meta-informações sobre cada item.
# A parte de meta-dados será separada da parte de dados brutos da linha usando
# o separador indicado na variável "MSE_NOTES_ITEM_META_SEPARATOR".
#
# As seguintes colunas serão adicionadas nesta area de meta-informação:
#
# - NaturalTopicName [ espaço de 32 caracteres ]
#   Nome do tópico em seu formato "natural", ou seja, da forma como ele foi
#   digitado pelo usuário na criação do mesmo.
#
# - TopicName [ espaço de 32 caracteres ]
#   Nome do tópico em seu formato sistemico, que é o formato usado nos comandos
#   e também é o formato em que seu arquivo correspondente é nomeado.
#
# - LineNumber [ espaço de 10 caracteres ]
#   Número da linha, no arquivo do respectivo tópico em que a informação foi
#   encontrada.
#
# A primeira linha do retorno - se houver algum - será usada para retornar os
# cabeçalhos correspondentes às informações obtidas.
#
#
# @param string $1
# [opcional]
# Id do item sendo procurado.
#
# @param string $2
# [opcional]
# Nome total ou parcial do/s tópico/s onde a consulta será feita.
#
# @param string $3
# [opcional]
# Descrição total ou parcial do item.
#
# @param status $4
# [opcional]
# Status atual do item.
# Se não for definido, buscará por todos os status (open | closed).
#
# @param datetime $5
# [opcional]
# Usando o campo "RegisterDate", indica a partir de que momento exatamente
# que os registros devem ser retornados.
#
# @param datetime $6
# [opcional]
# Usando o campo "RegisterDate", indica até que momento exatamente que os
# registros devem ser retornados.
#
# @param datetime $7
# [opcional]
# Usando o campo "CloseDate", indica a partir de que momento exatamente
# que os registros devem ser retornados.
#
# @param datetime $8
# [opcional]
# Usando o campo "CloseDate", indica até que momento exatamente que os
# registros devem ser retornados.
#
# @param string $9
# [opcional]
# Permite configurar as colunas de dados que devem ser retornadas.
# Se não for usado ou um valor inválido for indicado, todas as colunas serão
# retornadas.
#
# Neste momento são 8 colunas ao todo que podem ser retornadas:
#
# [Colunas de meta dados]
# - NaturalTopicName
# - TopicName
# - LineNumber
#
# [Colunas de informações]
# - Id
# - Status
# - RegisterDate
# - CloseDate
# - Description
#
#
# Use as seguintes regras para gerar um valor válido para este parametro:
# - Use apenas strings que possuam o mesmo número de caracteres que a
#   totalidade das colunas existentes (vide acima).
#
# - Em cada posição da string, use apenas valores "0" e "1".
#   Desta forma, cada posição da string corresponderá a uma coluna de dados e
#   ao mesmo tempo indica (com "1") quando ela deve ser retornada e (com "0")
#   quando ela deve ser excluída da resposta.
#
# Ex:
# "00111001"
# Com o valor acima serão retornadas as seguintes colunas:
# - LineNumber
# - Id
# - Status
# - Description
#
# @param bool $10
# [opcional]
# Quando "1", retornará as linhas de dados sem separar a parte de meta
# informações da parte dos dados em si.
mse_notes_topicItemMainSearch() {
  local mseFeedBackMsg=""

  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    local mseCheckDate=""
    local mseCheckTimeStamp=""
    local mseTotalMatch=0

    declare -A mseSearchBy
    mseSearchBy["Id"]=0
    mseSearchBy["TopicName"]=0
    mseSearchBy["Description"]=0
    mseSearchBy["Status"]=0
    mseSearchBy["RegisterDateTimeFrom"]=0
    mseSearchBy["RegisterDateTimeTo"]=0
    mseSearchBy["CloseDateTimeFrom"]=0
    mseSearchBy["CloseDateTimeTo"]=0



    local mseId=$(mse_str_trim "${1}")
    if [ "${mseId}" != "" ]; then
      ((mseTotalMatch = mseTotalMatch + 1))
      mseSearchBy["Id"]=1
    fi



    local mseTopicName=$(mse_notes_normalizeTopicName "${2}")
    if [ "${mseTopicName}" != "" ]; then
      ((mseTotalMatch = mseTotalMatch + 1))
      mseSearchBy["TopicName"]=1
    fi



    local mseDescription=$(mse_str_trim "${3}")
    if [ "${mseDescription}" != "" ]; then
      ((mseTotalMatch = mseTotalMatch + 1))
      mseSearchBy["Description"]=1
    fi



    local mseStatus=$(mse_str_trim "${4}")
    case "${mseStatus}" in
      "c" | "close" | "closed")
        mseStatus="closed"
      ;;

      "o" | "open")
        mseStatus="open"
      ;;

      *)
        mseStatus=""
      ;;
    esac
    if [ "${mseStatus}" != "" ]; then
      ((mseTotalMatch = mseTotalMatch + 1))
      mseSearchBy["Status"]=1
    fi



    local mseRegisterDateTimeFrom=$(mse_str_trim "${5}")
    if [ "${mseRegisterDateTimeFrom}" != "" ]; then
      mseCheckDate=$(date -d"$mseRegisterDateTimeFrom" "+%Y-%m-%d %H:%M:%S" 2> /dev/null)
      if [ "${mseCheckDate}" == "${mseRegisterDateTimeFrom}" ]; then
        ((mseTotalMatch = mseTotalMatch + 1))
        mseSearchBy["RegisterDateTimeFrom"]=1
        mseRegisterDateTimeFrom=$(date -d"${mseRegisterDateTimeFrom}" "+%s" 2> /dev/null)
      fi
    fi



    local mseRegisterDateTimeTo=$(mse_str_trim "${6}")
    if [ "${mseRegisterDateTimeTo}" != "" ]; then
      mseCheckDate=$(date -d"$mseRegisterDateTimeTo" "+%Y-%m-%d %H:%M:%S" 2> /dev/null)
      if [ "${mseCheckDate}" == "${mseRegisterDateTimeTo}" ]; then
        ((mseTotalMatch = mseTotalMatch + 1))
        mseSearchBy["RegisterDateTimeTo"]=1
        mseRegisterDateTimeTo=$(date -d"${mseRegisterDateTimeTo}" "+%s" 2> /dev/null)
      fi
    fi



    local mseCloseDateTimeFrom=$(mse_str_trim "${7}")
    if [ "${mseCloseDateTimeFrom}" != "" ]; then
      mseCheckDate=$(date -d"$mseCloseDateTimeFrom" "+%Y-%m-%d %H:%M:%S" 2> /dev/null)
      if [ "${mseCheckDate}" == "${mseCloseDateTimeFrom}" ]; then
        ((mseTotalMatch = mseTotalMatch + 1))
        mseSearchBy["CloseDateTimeFrom"]=1
        mseCloseDateTimeFrom=$(date -d"${mseCloseDateTimeFrom}" "+%s" 2> /dev/null)
      fi
    fi



    local mseCloseDateTimeTo=$(mse_str_trim "${8}")
    if [ "${mseCloseDateTimeTo}" != "" ]; then
      mseCheckDate=$(date -d"$mseCloseDateTimeTo" "+%Y-%m-%d %H:%M:%S" 2> /dev/null)
      if [ "${mseCheckDate}" == "${mseCloseDateTimeTo}" ]; then
        ((mseTotalMatch = mseTotalMatch + 1))
        mseSearchBy["CloseDateTimeTo"]=1
        mseCloseDateTimeTo=$(date -d"${mseCloseDateTimeTo}" "+%s" 2> /dev/null)
      fi
    fi


    local mseShowColumns="${9}"
    if [ "${mseShowColumns}" == "" ] || [ "${#mseShowColumns}" != 8 ]; then
      mseShowColumns="11111111"
    fi


    local mseMetaSeparatorIndex=""
    if [ "${mseShowColumns:0:1}" == "1" ]; then
      mseMetaSeparatorIndex=0
    fi
    if [ "${mseShowColumns:1:1}" == "1" ]; then
      mseMetaSeparatorIndex=1
    fi
    if [ "${mseShowColumns:2:1}" == "1" ]; then
      mseMetaSeparatorIndex=2
    fi


    #
    # Identifica se existem apenas metadados nesta seleção
    local mseIsOnlyMetaData="0"
    if [ "${mseMetaSeparatorIndex}" != "" ] && [ "${mseShowColumns:3}" == "00000" ]; then
      mseIsOnlyMetaData="1"
    fi


    local mseStrMetaSeparator="${MSE_NOTES_ITEM_META_SEPARATOR}"
    local mseUseOnlyColumnSeparator="${10}"
    if [ "${mseUseOnlyColumnSeparator}" == "1" ]; then
      mseMetaSeparatorIndex=""
      mseStrMetaSeparator="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"
    fi





    if [ ${mseTotalMatch} -ge 1 ]; then

      local mseSelectedItens=("${MSE_NOTES_ITEM_META_COLUMNS}${mseStrMetaSeparator}${MSE_NOTES_ITEM_DATA_COLUMNS}")

      local mseTopicFile=""
      local mseFileContent=""
      local mseLineCount=0
      local mseCountMatch=0

      local mseNaturalTopicName=""
      local mseMetaLine=""

      local mseLineId=""
      local mseLineStatus=""
      local mseLineRegisterDate=""
      local mseLineCloseDate=""
      local mseLineDescription=""



      for mseTopic in "${!MSE_NOTES_TOPICS[@]}"; do
        if [ ${mseSearchBy["TopicName"]} == 0 ] || [[ "${mseTopic}" =~ "${mseTopicName}" ]]; then
          mseTopicFile="${MSE_NOTES_DIRECTORY["topicsDir"]}/${mseTopic}"
          mseFileContent=""

          if [ -f "${mseTopicFile}" ]; then
            mseFileContent=$(< "${mseTopicFile}")
          fi

          if [ "${mseFileContent}" != "" ]; then
              #
            # A solução ' || [ -n "${mseRawLine}" ]' garante que a última linha será também
            # incluída no loop. Sem isto, a última linha é considerada 'EOF' e o loop não
            # itera sobre ela.
            IFS=$'\n'
            mseLineCount=0
            while read mseLineRaw || [ -n "${mseLineRaw}" ]; do
              ((mseLineCount = mseLineCount + 1))

              if [ "${mseLineCount}" == "1" ]; then
                mseNaturalTopicName=$(mse_str_trim "${mseLineRaw}")
              elif [ "${mseLineCount}" -ge 3 ]; then
                mse_str_split "${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}" "${mseLineRaw}"
                if [ "${#MSE_GLOBAL_MODULE_SPLIT_RESULT[@]}" == "5" ]; then
                  mseCountMatch=0

                  mseLineId=$(mse_str_trim "${MSE_GLOBAL_MODULE_SPLIT_RESULT[0]}")
                  mseLineStatus=$(mse_str_trim "${MSE_GLOBAL_MODULE_SPLIT_RESULT[1]}")
                  mseLineRegisterDate=$(mse_str_trim "${MSE_GLOBAL_MODULE_SPLIT_RESULT[2]}")
                  mseLineCloseDate=$(mse_str_trim "${MSE_GLOBAL_MODULE_SPLIT_RESULT[3]}")
                  mseLineDescription=$(mse_str_trim "${MSE_GLOBAL_MODULE_SPLIT_RESULT[4]}")


                  if [ ${mseSearchBy["Id"]} == 1 ] && [[ "${mseId}" == "${mseLineId}" ]]; then
                    ((mseCountMatch = mseCountMatch + 1))
                  fi

                  if [ ${mseSearchBy["TopicName"]} == 1 ]; then
                    ((mseCountMatch = mseCountMatch + 1))
                  fi

                  if [ ${mseSearchBy["Status"]} == 1 ] && [[ "${mseLineStatus}" == "${mseStatus}" ]]; then
                    ((mseCountMatch = mseCountMatch + 1))
                  fi

                  if [ ${mseSearchBy["RegisterDateTimeFrom"]} == 1 ] || [ ${mseSearchBy["RegisterDateTimeTo"]} == 1 ]; then
                    mseCheckTimeStamp=$(date -d"${mseLineRegisterDate}" "+%s" 2> /dev/null)

                    if [ ${mseSearchBy["RegisterDateTimeFrom"]} == 1 ] && [ ${mseCheckTimeStamp} -ge ${mseRegisterDateTimeFrom} ]; then
                      ((mseCountMatch = mseCountMatch + 1))
                    fi

                    if [ ${mseSearchBy["RegisterDateTimeTo"]} == 1 ] && [ ${mseCheckTimeStamp} -ge ${mseRegisterDateTimeTo} ]; then
                      ((mseCountMatch = mseCountMatch + 1))
                    fi
                  fi

                  if [ ${mseSearchBy["CloseDateTimeFrom"]} == 1 ] || [ ${mseSearchBy["CloseDateTimeTo"]} == 1 ]; then
                    mseCheckTimeStamp=$(date -d"${mseLineCloseDate}" "+%s" 2> /dev/null)

                    if [ ${mseSearchBy["CloseDateTimeFrom"]} == 1 ] && [ ${mseCheckTimeStamp} -ge ${mseCloseDateTimeFrom} ]; then
                      ((mseCountMatch = mseCountMatch + 1))
                    fi

                    if [ ${mseSearchBy["CloseDateTimeTo"]} == 1 ] && [ ${mseCheckTimeStamp} -ge ${mseCloseDateTimeTo} ]; then
                      ((mseCountMatch = mseCountMatch + 1))
                    fi
                  fi

                  if [ ${mseSearchBy["Description"]} == 1 ] && [[ "${mseLineDescription}" =~ "${mseDescription}" ]]; then
                    ((mseCountMatch = mseCountMatch + 1))
                  fi


                  if [ "${mseCountMatch}" == "${mseTotalMatch}" ]; then
                    mseMetaLine=$(mse_str_pad "${mseNaturalTopicName}" " " "32" "r")
                    mseMetaLine+="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"
                    mseMetaLine+=$(mse_str_pad "${mseTopic}" " " "32" "r")
                    mseMetaLine+="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"
                    mseMetaLine+=$(mse_str_pad "${mseLineCount}" " " "10" "r")

                    mseSelectedItens+=("${mseMetaLine}${mseStrMetaSeparator}${mseLineRaw}")

                    #
                    # Se a pesquisa foi por Id, encerra
                    if [ ${mseSearchBy["Id"]} == 1 ]; then
                      break;
                    fi
                  fi

                fi
              fi
            done <<< "$mseFileContent"
            IFS=$' \t\n'


            #
            # Se a pesquisa foi por Id, encerra
            if [ ${mseSearchBy["Id"]} == 1 ] && [ "${#mseSelectedItens[@]}" -gt 1 ]; then
              break;
            fi
          fi
        fi

      done



      unset MSE_NOTES_SEARCH
      declare -ga MSE_NOTES_SEARCH=()

      if [ "${#mseSelectedItens[@]}" -gt 1 ]; then

        if [ "${mseShowColumns}" == "11111111" ]; then
          MSE_NOTES_SEARCH=("${mseSelectedItens[@]}")
        else
          local mseTmpLine=""
          local mseUseMetaSeparator=""

          declare -a mseTmpLineData=()

          for mseSelectedRawLine in "${mseSelectedItens[@]}"; do
            mseTmpLineData=()

            mseTmpLine=$(mse_str_replace "${MSE_NOTES_ITEM_META_SEPARATOR}" "${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}" "${mseSelectedRawLine}")
            mse_str_split "${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}" "${mseTmpLine}"

            for mseIndex in {0..7}; do
              if [ "${mseShowColumns:${mseIndex}:1}" == "1" ]; then
                mseUseMetaSeparator=""
                if [ "${mseIndex}" == "${mseMetaSeparatorIndex}" ] && [ "${mseIsOnlyMetaData}" == "0" ]; then
                  mseUseMetaSeparator="${mseStrMetaSeparator}"
                fi

                mseTmpLineData+=("${MSE_GLOBAL_MODULE_SPLIT_RESULT[${mseIndex}]}${mseUseMetaSeparator}")
              fi
            done

            mseTmpLine=$(mse_str_join "${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}" "mseTmpLineData")
            mseTmpLine=$(mse_str_replace "${MSE_NOTES_ITEM_META_SEPARATOR}${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}" "${MSE_NOTES_ITEM_META_SEPARATOR}" "${mseTmpLine}")
            MSE_NOTES_SEARCH+=("${mseTmpLine}")
          done
        fi
      fi
    fi
  fi
}