#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
lbl_err_hasNoDirectoryOpened="Nenhum diretório de notas foi aberto para realizar esta ação."

#
# DIR :: INIT
lbl_err_initDir_dirIsNotEmpty="O diretório \"[[DIR]]\" não está vazio."
lbl_success_initDir="O diretório \"[[DIR]]\" foi inicializado."

#
# DIR :: OPEN
lbl_err_openDir_dirIsNotInitialized="O diretório \"[[DIR]]\" não foi inicializado."
lbl_success_openDir="O diretório \"[[DIR]]\" está aberto."

#
# TOPIC :: ADD
lbl_err_topicAdd_maxLengthExceeded="O nome do tópico \"[[TOPIC]]\" excedeu o comprimento máximo de 32 caracteres."
lbl_err_topicAdd_alreadExist="O tópico \"[[TOPIC]]\" já existe."
lbl_err_topicAdd_cannotCreate="Não é possível criar o tópico  \"[[TOPIC]]\"."
lbl_success_topicAdd="O tópico \"[[TOPIC]]\" foi criado."

#
# TOPIC :: LIST
lbl_info_topicList_empty="Não há tópicos neste diretório."
lbl_info_topicList_find="Os seguintes tópicos foram encontrados."

#
# TOPIC :: REMOVE
lbl_err_topicRemove_notExist="O tópico \"[[TOPIC]]\" não existe."
lbl_err_topicRemove_cannotRemove="Não é possível remover o arquivo do tópico \"[[TOPIC]]\"."
lbl_success_topicRemove="O tópico \"[[TOPIC]]\" foi removido."

#
# TOPIC :: RENAME
lbl_err_topicRename_maxLengthExceeded="O nome do tópico \"[[TOPIC]]\" excedeu o comprimento máximo de 32 caracteres."
lbl_err_topicRename_notExist="O tópico \"[[TOPIC]]\" não existe."
lbl_err_topicRename_alreadyExist="O tópico \"[[TOPIC]]\" já existe."
lbl_err_topicRename_unespectedFail="Ocorreu uma falha inesperada ao tentar renomear o tópico \"[[TOPIC]]\"."
lbl_success_topicRename="O tópico \"[[OLD_TOPIC]]\" foi renomeado para \"[[NEW_TOPIC]]\"."

#
# TOPIC :: ITEM ADD
lbl_err_itemAdd_invalidId_NaN="O Id fornecido não é um número."
lbl_err_itemAdd_idNotFound="Nenhum item foi encontrado com o Id fornecido."
lbl_err_itemAdd_invalidTopic="Nome de tópico inválido: \"[[TOPIC]]\"."
lbl_err_itemAdd_topicFileNotFound="Não foi possível encontrar o arquivo do tópico \"[[TOPIC]]\"."
lbl_err_itemAdd_invalidDescription="O valor da descrição não pode estar vazio."
lbl_err_itemAdd_invalidRegisterDate="A data de registro fornecida é inválida; Use o formato \"AAAA-MM-DD HH:mm:ss\"."
lbl_err_itemAdd_invalidCloseDate="A data de fechamento fornecida é inválida; Use o formato \"AAAA-MM-DD HH:mm:ss\"."
lbl_err_itemAdd_cannotSave="Erro não esperado. Não é possível salvar o novo item."
lbl_success_itemAdd="O novo item foi adicionado ao tópico \"[[TOPIC]]\"."

#
# TOPIC :: ITEM EDIT
lbl_success_itemEdit="As alterações do item foram salvas."

#
# TOPIC :: ITEM LIST
lbl_info_itemList_emptyResult="Nenhum item foi encontrado."
lbl_info_itemList_foundResult="Os seguintes itens foram encontrados."

#
# TOPIC :: ITEM REMOVE
lbl_info_itemRemove_notFound="Nenhum item foi encontrado com o Id fornecido."
lbl_success_itemRemove="O item indicado foi removido."

#
# TOPIC :: ITEM SEARCH
lbl_info_itemSearch_emptyResult="Nenhum item foi encontrado para os critérios fornecidos."
lbl_info_itemSearch_foundResult="Os seguintes itens foram encontrados."

#
# NOTE :: ADD
lbl_info_addNote_notFound="Nenhum item foi encontrado com o Id fornecido."
lbl_info_noteAdd_cannotSave="Erro não esperado. Não é possível salvar a nova nota."
lbl_success_noteAdd="A nova nota foi adicionada."

#
# NOTE :: EDIT
lbl_err_noteEdit_idNotFound="Nenhuma nota foi encontrada com o Id fornecido."
lbl_err_noteEdit_metaLineCorrupt="A linha de metadados está corrompida e não pode ser editada."
lbl_err_noteEdit_cannotCreateDirectory="Não é possível criar diretório para realocar a nota."
lbl_err_noteEdit_cannotChangeDate="Não foi possível alterar a data da nota."
lbl_success_noteEdit="A nova nota foi alterada."

#
# NOTE :: REMOVE
lbl_err_noteRemove_idNotFound="Nenhuma nota foi encontrada com o Id fornecido."
lbl_err_noteRemove_cannotRemoveDate="Não é possível remover o arquivo de nota de destino."
lbl_success_noteRemove="A nota foi removida."

#
# NOTE :: SEARCH
lbl_info_noteSearch_emptyResult="Nenhuma nota foi encontrada para os critérios fornecidos."
lbl_info_noteSearch_foundResult="As seguintes notas foram encontradas."

#
# NOTE :: SHOW
lbl_err_noteShow_cannotFind="Nota de arquivo não encontrada."

#
# REPORT
lbl_info_report_emptyResult="Nenhuma nota foi encontrada para os critérios fornecidos."
lbl_err_report_cannotSave="Erro não esperado. Não é possível salvar o relatório."
lbl_success_reportScreen="Seu relatório foi salvo no arquivo \"[[FILE]]\""

lbl_report_resume="Resumo"
lbl_report_hours="horas"
lbl_report_fullReport="Relatório completo"
lbl_report_day="dia"
lbl_report_dayFormat="+%d/%m"