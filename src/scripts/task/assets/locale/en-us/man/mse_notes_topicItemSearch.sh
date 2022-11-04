#
# @desc
# Search through all topics for those items that
# match the passed query information and show the result
# on the screen.
#
# @param string $1
# [optional]
# Id of the item being searched for.
#
# @param string $2
# [optional]
# Full or partial name of the group/s where the query will be made.
#
# @param string $3
# [optional]
# Full or partial description of the item.
#
# @param status $4
# [optional]
# Current status of the item.
# If not set, search for all statuses (open | closed).
#
# @param datetime $5
# [optional]
# Using the "RegisterDate" field, indicate from which moment exactly
# that records should be returned.
#
# @param datetime $6
# [optional]
# Using the "RegisterDate" field, indicate up to what point exactly the
# records must be returned.
#
# @param datetime $7
# [optional]
# Using the "CloseDate" field, indicate from which moment exactly
# that records should be returned.
#
# @param datetime $8
# [optional]
# Using the "CloseDate" field, indicate up to what point exactly the
# records must be returned.
#
# @param string $9
# [optional]
# Allows you to configure the data columns that should be returned.
#
# Right now there are 8 columns in total that can be returned:
#
# [Columns of meta data]
# - NaturalTopicName
# - TopicName
# - LineNumber
#
# [Columns of Information]
# - ID
# - Status
# - RegisterDate
# - CloseDate
# - Description
#
#
# Use the following rules to generate a valid value for this parameter:
# - Only use strings that have the same number of characters as the
# all existing columns (see above).
#
# - In each string position, use only "0" and "1" values.
# This way each string position will correspond to a column of data and
# at the same time indicates (with "1") when it should be returned and (with "0")
# when it should be excluded from the response.
#
# Ex:
# "00111001"
# With the above value, the following columns will be returned:
# - LineNumber
# - ID
# - Status
# - Description
#
# @param bool $10
# [optional]
# When "1", it will return the data rows without separating the meta part
# information from the data part itself.