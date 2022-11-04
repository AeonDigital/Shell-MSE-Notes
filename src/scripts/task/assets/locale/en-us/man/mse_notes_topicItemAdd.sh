#
# @desc
# Add a new item to a topic.
#
# @param string $1
# Name of the topic where the new item will be added.
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
# If not set, will use today's date and time.
# If set, must use the format "YYYY-MM-DD HH:MM:SS"
# Use the value "now" to get today's date and time.
#
# @param datetime $5
# [optional]
# Informs the day and time the item was completed.
# If set, must use the format "YYYY-MM-DD HH:MM:SS"
# If the item status is not "closed", this value will be
# ignored.
# Use the value "now" to get today's date and time.