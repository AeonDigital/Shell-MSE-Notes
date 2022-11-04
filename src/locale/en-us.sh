#!/usr/bin/env bash
# myShellEnv v 1.0 [aeondigital.com.br]







#
lbl_err_hasNoDirectoryOpened="No notes directory has been opened to perform this action."

#
# DIR :: INIT
lbl_err_initDir_dirIsNotEmpty="The directory \"[[DIR]]\" is not empty."
lbl_success_initDir="The directory \"[[DIR]]\" has been initialized."

#
# DIR :: OPEN
lbl_err_openDir_dirIsNotInitialized="The directory \"[[DIR]]\" is not initialized."
lbl_success_openDir="The directory \"[[DIR]]\" is open."

#
# TOPIC :: ADD
lbl_err_topicAdd_maxLengthExceeded="The topic name \"[[TOPIC]]\" exceeded the max characters length of 32."
lbl_err_topicAdd_alreadExist="The topic \"[[TOPIC]]\" already exists."
lbl_err_topicAdd_cannotCreate="Cannot create the topic \"[[TOPIC]]\"."
lbl_success_topicAdd="The topic \"[[TOPIC]]\" has beem created."

#
# TOPIC :: LIST
lbl_info_topicList_empty="There are no topics in this directory."
lbl_info_topicList_find="The following topics were found."

#
# TOPIC :: REMOVE
lbl_err_topicRemove_notExist="The topic \"[[TOPIC]]\" does not exists."
lbl_err_topicRemove_cannotRemove="Cannot remove file from topic \"[[TOPIC]]\"."
lbl_success_topicRemove="The topic \"[[TOPIC]]\" has been removed."

#
# TOPIC :: RENAME
lbl_err_topicRename_maxLengthExceeded="The topic name \"[[TOPIC]]\" exceeded the max characters length of 32."
lbl_err_topicRename_notExist="The topic \"[[TOPIC]]\" does not exists."
lbl_err_topicRename_alreadyExist="The topic \"[[TOPIC]]\" already exists."
lbl_err_topicRename_unespectedFail="An unexpected failure occurred while trying to rename the topic \"[[TOPIC]]\"."
lbl_success_topicRename="The topic \"[[OLD_TOPIC]]\" has been renamed to \"[[NEW_TOPIC]]\"."

#
# TOPIC :: ITEM ADD
lbl_err_itemAdd_invalidId_NaN="The given Id is not a number."
lbl_err_itemAdd_idNotFound="No items were found with the given Id."
lbl_err_itemAdd_invalidTopic="Invalid topic name: \"[[TOPIC]]\"."
lbl_err_itemAdd_topicFileNotFound="Cannot found the topic file \"[[TOPIC]]\"."
lbl_err_itemAdd_invalidDescription="The description value cannot be empty."
lbl_err_itemAdd_invalidRegisterDate="The given register date is invalid; Use the \"YYYY-MM-DD HH:mm:ss\" format."
lbl_err_itemAdd_invalidCloseDate="The given closed date is invalid; Use the \"YYYY-MM-DD HH:mm:ss\" format."
lbl_err_itemAdd_cannotSave="Unespected error. Cannot save the new item."
lbl_success_itemAdd="The new item has beem add for the topic \"[[TOPIC]]\"."

#
# TOPIC :: ITEM ADD
lbl_success_itemEdit="Item changes have been saved."

#
# TOPIC :: ITEM LIST
lbl_info_itemList_emptyResult="No itens where found."
lbl_info_itemList_foundResult="The following items were found."

#
# TOPIC :: ITEM REMOVE
lbl_info_itemRemove_notFound="No items were found with the given Id."
lbl_success_itemRemove="The indicated item has been removed."

#
# TOPIC :: ITEM SEARCH
lbl_info_itemSearch_emptyResult="No items were found for the given criteria."
lbl_info_itemSearch_foundResult="The following items were found."

#
# NOTE :: ADD
lbl_info_addNote_notFound="No items were found with the given Id."
lbl_info_noteAdd_cannotSave="Unespected error. Cannot save the new note."
lbl_success_noteAdd="The new note has beem add."

#
# NOTE :: EDIT
lbl_err_noteEdit_idNotFound="No notes were found with the given Id."
lbl_err_noteEdit_metaLineCorrupt="The meta data row is corrupt and cannot be edited."
lbl_err_noteEdit_cannotCreateDirectory="Cannot create directory to relocate note."
lbl_err_noteEdit_cannotChangeDate="It was not possible to change the date of the note."
lbl_success_noteEdit="The new note has beem changed."

#
# NOTE :: REMOVE
lbl_err_noteRemove_idNotFound="No notes were found with the given Id."
lbl_err_noteRemove_cannotRemoveDate="Cannot remove the target note file."
lbl_success_noteRemove="The note has beem removed."

#
# NOTE :: SEARCH
lbl_info_noteSearch_emptyResult="No notes were found for the given criteria."
lbl_info_noteSearch_foundResult="The following notes were found."

#
# NOTE :: SHOW
lbl_err_noteShow_cannotFind="File note not found."

#
# REPORT
lbl_info_report_emptyResult="No notes were found for the given criteria."
lbl_err_report_cannotSave="Unespected error. Cannot save the report."
lbl_success_reportScreen="Your report has been saved in the \"[[FILE]]\" file"

lbl_report_resume="Summary"
lbl_report_hours="hours"
lbl_report_fullReport="Full report"
lbl_report_day="day"
lbl_report_dayFormat="+%m/%d"