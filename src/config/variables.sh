#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Arquivo que está aberto no momento.
MSE_NOTES_INTERFACE_FILE=""


#
# Armazena o conteúdo do arquivo carregado linha a linha.
unset MSE_NOTES_FILE_CONTENT
declare -ga MSE_NOTES_FILE_CONTENT=()


#
# Tamanho da 'regua' visual para orientação do usuário
MSE_NOTES_INTERFACE_RULER_LENGTH=120

#
# Indica se deve ou não quebrar as linhas cujo texto ultrapassem
# o tamanho definido para a 'regua'
MSE_NOTES_INTERFACE_BREAKLINE=1

#
# Tamanho máximo 'em linhas' que uma nota pode ter.
# Indique '0' para que não tenha limites
MSE_NOTES_INTERFACE_MAX_LINES=20

#
# Armazena as strings indicativas de cada uma das regras
# de configuração da interface da nota atualmente em uso.
unset MSE_NOTES_INTERFACE_CONFIG
declare -ga MSE_NOTES_INTERFACE_CONFIG=()



#
# Guarda os comandos aptos a serem utilizados
#
# Registre o comando adicionando um novo item no array de comandos
# respeitando os seguintes campos (separados por ponto e virgula)
#
# nome (string):
# Nome do comando. Compõe o nome da função com o prefixo
# 'mse_notes_execCmd' e que efetivamente traz o algoritmo do comando.
#
# descrição (string):
# Uma descrição breve do respectivo comando.
#
# chave (string):
# Informe qual conjunto de teclas deve ser digitado pelo usuário
# para ativar o comando.
# Deixe vazio caso esta opção não se aplique a este caso.
#
# alvo (string):
# Informe o 'alvo' para este comando.
# Use 'l' se ele tem uma linha do editor como alvo. Neste caso o número
# da linha precisa ser indicado imediatamente após a chave.
# Informe '' caso não se aplique.
unset MSE_NOTES_RAW_COMMAND
declare -ga MSE_NOTES_RAW_COMMAND=()

#
# Armazena todos os nomes de comandos que podem ser evocados
# pelos usuários
unset MSE_NOTES_USER_CALLABLE_COMMAND_NAME
declare -ga MSE_NOTES_USER_CALLABLE_COMMAND_NAME=()

#
# Associa o nome do comando com sua respectiva descrição
unset MSE_NOTES_USER_CALLABLE_COMMAND_DESCRIPTION
declare -gA MSE_NOTES_USER_CALLABLE_COMMAND_DESCRIPTION

#
# Associa o nome do comando com sua chave de ativação
unset MSE_NOTES_USER_CALLABLE_COMMAND_KEY
declare -gA MSE_NOTES_USER_CALLABLE_COMMAND_KEY

#
# Associa o nome do comando com o alvo de sua ação
unset MSE_NOTES_USER_CALLABLE_COMMAND_TARGET
declare -gA MSE_NOTES_USER_CALLABLE_COMMAND_TARGET



#
# Diretório de notas que está aberto.
unset MSE_NOTES_DIRECTORY
declare -gA MSE_NOTES_DIRECTORY
MSE_NOTES_DIRECTORY["open"]="0"

unset MSE_NOTES_TOPICS
declare -gA MSE_NOTES_TOPICS=()

unset MSE_NOTES_SEARCH
declare -ga MSE_NOTES_SEARCH=()

MSE_NOTES_ITEM_META_SEPARATOR=" :: "
MSE_NOTES_ITEM_COLUMNS_SEPARATOR=" | "

mseTMP="${MSE_NOTES_ITEM_COLUMNS_SEPARATOR}"
MSE_NOTES_ITEM_META_COLUMNS="NaturalTopicName                ${mseTMP}TopicName                       ${mseTMP}LineNumber"
MSE_NOTES_ITEM_DATA_COLUMNS="Id    ${mseTMP}Status${mseTMP}RegisterDate       ${mseTMP}CloseDate          ${mseTMP}Description"

MSE_NOTES_NOTE_META_COLUMNS="NaturalTopicName                ${mseTMP}ItemId${mseTMP}NoteId${mseTMP}DayPeriod ${mseTMP}IniTime ${mseTMP}EndTime ${mseTMP}TotalHours${mseTMP}Date       "

MSE_NOTES_REPOST_META_COLUMN="Report DateTime    ${mseTMP}IniDate   ${mseTMP}EndDate   ${mseTMP}Topic"
unset mseTMP

MSE_NOTES_ITEM_ERROR_MSG=""
MSE_NOTES_NOTE_ERROR_MSG=""