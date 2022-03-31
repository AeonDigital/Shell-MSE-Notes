#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
# Armazena o nome de todos os módulos carregados.
unset MSE_NOTES_FILE_CONTENT
declare -a MSE_NOTES_FILE_CONTENT=()


#
# Arquivo que está aberto no momento.
MSE_NOTES_INTERFACE_FILE=""

#
# Tamanho da 'regua' visual para orientação do usuário
MSE_NOTES_INTERFACE_RULER_LENGTH=80

#
# Indica se deve ou não quebrar as linhas cujo texto ultrapassem
# o tamanho definido para a 'regua'
MSE_NOTES_INTERFACE_BREAKLINE=0

#
# Tamanho máximo 'em linhas' que uma nota pode ter.
# Indique '0' para que não tenha limites
MSE_NOTES_INTERFACE_MAX_LINES=0

#
# Armazena as strings indicativas de cada uma das regras
# de configuração da interface da nota atualmente em uso.
unset MSE_NOTES_INTERFACE_CONFIG
declare -a MSE_NOTES_INTERFACE_CONFIG=()



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
declare -a MSE_NOTES_RAW_COMMAND=()

#
# Armazena todos os nomes de comandos que podem ser evocados
# pelos usuários
unset MSE_NOTES_USER_CALLABLE_COMMAND_NAME
declare -a MSE_NOTES_USER_CALLABLE_COMMAND_NAME=()

#
# Associa o nome do comando com sua respectiva descrição
unset MSE_NOTES_USER_CALLABLE_COMMAND_DESCRIPTION
declare -A MSE_NOTES_USER_CALLABLE_COMMAND_DESCRIPTION

#
# Associa o nome do comando com sua chave de ativação
unset MSE_NOTES_USER_CALLABLE_COMMAND_KEY
declare -A MSE_NOTES_USER_CALLABLE_COMMAND_KEY

#
# Associa o nome do comando com o alvo de sua ação
unset MSE_NOTES_USER_CALLABLE_COMMAND_TARGET
declare -A MSE_NOTES_USER_CALLABLE_COMMAND_TARGET
