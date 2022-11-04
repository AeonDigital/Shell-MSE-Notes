#
# @desc
# Allows you to generate a report of the activities performed based on the
# criteria of selection indicated.
#
# @param date $1
# Starting date from which grades will be included in the report.
# Use the format "YYYY-MM-DD" to indicate a valid value.
#
# @param date $2
# End date by which grades will be included in the report.
# Use the format "YYYY-MM-DD" to indicate a valid value.
#
# @param string $3
# Full or partial name of the topic/s to which the notes
# must belong.
#
# @param string $4
# [optional]
# Name of the report file.
# If not defined, the result will be printed on the screen.
# If set, the file will be stored in the "/reports" directory for
# to the location that is currently open.