#
# @desc
# Edit an existing item.
#
# @param string $1
# Id of the item to be edited.
#
# @param string $2
# Item description.
#
# @param status $3
# [optional]
# Informs the current status of the item.
# If not set, by default set this value to
# "open". Valid options are only "open" and "closed".
#
# @param datetime $4
# [optional]
# Informs the day and time the item was added.
# If not set, will use the pre-existing date and time in the record.
# If set, must use the format "YYYY-MM-DD HH:MM:SS"
# Use the value "now" to get today's date and time.
#
# @param datetime $5
# [optional]
# Informs the day and time the item was completed.
# If set, must use the format "YYYY-MM-DD HH:MM:SS"
# Use the value "now" to get today's date and time.
# If the item status is not "closed", this value will be
# ignored.