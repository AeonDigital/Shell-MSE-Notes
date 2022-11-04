#
# @desc
# List the notes according to the sampling criteria.
#
# @param int $1
# Indicates how many days in the past, including today, that the notes should be
# sampled in the listing.
# If empty, it will use the value "0", thus showing only today's day.
#
# @param date $2
# [optional]
# Starting date from which grades will be shown.
# Use the format "YYYY-MM-DD" to indicate a valid value.
# If the first parameter is set, it will be ignored.
#
# @param date $3
# [optional]
# End date until which the query will be made.
# Use the format "YYYY-MM-DD" to indicate a valid value.
# If the first parameter is set, it will be ignored.
#
# @param string $4
# Full or partial name of the topic/s to which the notes
# must belong.
#
# @param string $5
# [optional]
# Keyword that must be in the body of the notes.