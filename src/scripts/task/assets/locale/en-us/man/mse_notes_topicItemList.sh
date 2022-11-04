#
# @desc
# List items in a topic according to the given settings.
# For a more comprehensive query with more information use the function
# "mse_notes_topicItemSearch".
#
# @param string $1
# [optional]
# Full or partial name of the topic(s) targeted by the listing.
# If not set, will return items from all topics in the directory.
#
# @param string $2
# [optional]
# Total or partial description of the items to be returned.
#
# @param status $3
# [optional]
# Status of items.
# If not set, search for all statuses (open | closed).
#
# @param string $4
# [optional]
# Configure the columns of data that should be returned.
#
# Use the same rules as described for the "$9" parameter of the function
# "mse_notes_topicItemSearch"