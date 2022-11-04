#
# @desc
# Add a correlated note to a topic item.
# Open the note for editing at the end of the insertion.
#
# @param string $1
# Id of a topic item to which the note will be linked.
#
# @param time $2
# [optional]
# Start time of this activity.
# If set, use "HH:MM" format.
# If not set, use current system time.
#
# @param time $3
# [optional]
# End time of this activity.
# If set, use "HH:MM" format.
#
# @param bool $4
# [optional]
# Use "1" to use the "full" hour, thus converting any
# fraction of time in zero minutes.
#
# @param date $5
# [optional]
# By default, always use today's date to allocate the note
# physically on the file system.
# If set, use "YYYY-MM-DD" format
# An invalid value will force the use of today.