#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# @desc
# Efetua uma busca entre todos os tópicos por aqueles itens que
# correspondem às informações de consulta passadas e mostra o resultado
# na tela.
#
# @param string $1
# [opcional]
# Id do item sendo procurado.
#
# @param string $2
# [opcional]
# Nome total ou parcial do/s grupo/s onde a consulta será feita.
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
mse_notes_topicItemSearch() {
  if [ "${MSE_NOTES_DIRECTORY["open"]}" != "1" ]; then
    mse_inter_showError "ERR::${lbl_err_hasNoDirectoryOpened}"
  else
    mse_notes_topicItemMainSearch "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}" "${10}"

    if [ "${#MSE_NOTES_SEARCH[@]}" == 0 ]; then
      mse_inter_showAlert "a" "${lbl_info_itemSearch_emptyResult}"
    else
      mse_inter_showAlert "a" "${lbl_info_itemSearch_foundResult}"

      printf "%s\n" "${MSE_NOTES_SEARCH[@]}"
      printf "\n"
    fi
  fi
}
MSE_GLOBAL_CMD["notes topic item search"]="mse_notes_topicItemSearch"




#
# Preenche o array associativo 'MSE_GLOBAL_VALIDATE_PARAMETERS_RULES'
# com as regras de validação dos parametros aceitáveis.
mse_notes_topicItemSearch_vldtr() {
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["count"]=10
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_0"]="Id :: o :: int"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_1"]="TopicName :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_2"]="Description :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_3"]="Status :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_3_labels"]="a, o, c"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_3_values"]="all, open, closed"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_4"]="RegisterDateFrom :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_5"]="RegisterDateTo :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_6"]="CloseDateFrom :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_7"]="CloseDateTo :: o :: string"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_8"]="RetrieveColumns :: o :: string :: 11111111 :: 8"
  MSE_GLOBAL_VALIDATE_PARAMETERS_RULES["param_9"]="UseMetaSeparator :: o :: bool :: 1"
}
