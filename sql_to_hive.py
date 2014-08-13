import re
import sys

# Parameters: input_filepath, output_filename (default = output.txt)

#This script takes an input text file which is list of column names and 
#types from SSMS Create Table script for a table, and outputs the equivalent
#Hive column names and types.

# Ex/ input file:
# [OwningBusinessUnit] [uniqueidentifier] NULL,
# [ActualEnd] [datetime] NULL,
# [VersionNumber] [timestamp] NULL,
# [ActivityId] [uniqueidentifier] NOT NULL,
# [IsBilled] [bit] NULL,
# [CreatedBy] [uniqueidentifier] NULL,
# [Description] [nvarchar](max) NULL,




input_filename = sys.argv[1]

try:
	output_filename = sys.argv[2]
except Exception:
	output_filename = 'output.txt'

regs = [
	
	(			r'[\[\]]'	        ,				''				),
	(        r'\bnvarchar[ ]*\((.)*\) '      ,			'string '			),
	(		r'\bdecimal[ ]*\((.)*\)'			,			'decimal'			),
	(		r'\buniqueidentifier\b' , 			'string'			),
	(		r'\bNOT NULL\b'			, 				''					),
	(		r'\bNULL\b'				,				''				),
	(		r'\bdatetime\b'			,			'timestamp'			),
	(		r'\bmoney\b'			,			'decimal'			),
	(		r'\bbit\b'				,			'boolean'			),
	# (		r'^\b[^ ]+'	   ,          	''  				)



]

input = open(input_filename)
output = open(output_filename,'w')


lines = input.readlines()

for line in lines:
	for (k,v) in regs:
		# print k
		line = re.sub(k,v,line)


	output.write(line)
	print line

output.close()
