# These are not fully tested commands, but they are a starting point
# Sample command to rsyn entiure directory tree
aws s3 sync s3://bluefish-datashare.chesapeakebay.net/source/ /path/to/local/copy
# Ex: aws s3 sync s3://bluefish-datashare.chesapeakebay.net/vadeq/gb604/ /opt/model/p6/p6_gb604

# Sync a single file
#For a single file however, just the CP command is necessary
# File name can be omitted, or included, or changed on the destination similar to the linux cp command.
aws s3 cp s3://bluefish-datashare.chesapeakebay.net/source/FileXYZ.csv /path/to/source2/FileXYZ.csv


# R repo for cli tools
https://github.com/cloudyr/aws.s3
