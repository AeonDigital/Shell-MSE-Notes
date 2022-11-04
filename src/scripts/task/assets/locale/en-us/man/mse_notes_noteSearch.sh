#
# @desc
# Performs a search among all notes that match the information of
# query passed and show the result on the screen.
#
# @param string $1
# [optional]
# Id of the note being searched for.
#
# @param date $2
# [optional]
# Starting date from which the query will be made.
# Use the format "YYYY-MM-DD" to indicate a valid value.
# If not set, will use today's date.
# If it is not defined but the $1 parameter is, it will use the value as date
# "2000-01-01" as the start date.
#
# @param date $3
# [optional]
# End date until which the query will be made.
# Use the format "YYYY-MM-DD" to indicate a valid value.
# If not set, will use today's date.
#
# @param string $4
# [optional]
# Full or partial name of the topic/s to which the notes
# must belong.
#
# @param int $5
# [optional]
# Id of the item to which the grades should be correlated.
#
# @param string $6
# [optional]
# Day period.
#
# @param string $7
# [optional]
# Keyword that must be in the body of the notes.
#
# @param bool $8
# When "1", it will return the data lines of each note that matched the
# value of the given keyword.