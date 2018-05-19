# coding=utf-8
# 将excel解析成json文件
# version 1.0: 2014-11-2, 题头格式变更，第0行类型，第1行 策划注释，第2行 kye name

import os
import sys
import codecs
import xlrd #http://pypi.python.org/pypi/xlrd

global PRINT_LEVEL# 0:no log; 1: warning; 2: prompt; 3: all
PRINT_LEVEL = 3
# 全局变量
g_idDict = {}# 记录ID，用于检查重复
COL_TYPE = "INT"


def getStrFromObj(obj):
	if type(obj) == float:
		intValue = int(obj)
		floatValue = float(obj)
		decValue = floatValue - intValue
		if decValue > 0.0001:
			#return str(obj)
			floatValue = "%.4f" % floatValue
			return str(floatValue)
		else:
			return str(intValue)
	else:
		return obj
		
def getEcelColStr(col):
	if col <= 26:
		return chr(ord('A') + col - 1)
	elif col <= 52:
		return 'A'+chr(ord('A') + col - 26 - 1)
	elif col <= 78:
		return 'A'+chr(ord('A') + col - 26 - 1)
	else:
		return str(col)

def praseRowData(outputFile, fieldName, rowData, row, errorFile, row_type):
	ncols = len(rowData)
	cellValue = getStrFromObj(rowData[0])
	outputFile.write('\t\"' + cellValue + '\": {\n')
	# 检查id是否重复
	if cellValue in g_idDict:
		if PRINT_LEVEL >= 1:
			print ('id: ' + cellValue + ' is duplicate!')
			errorFile.write('id: ' + cellValue + ' is duplicate!\n')
			os.system("pause")
	else:
		g_idDict[cellValue] = 1
	if PRINT_LEVEL >= 3:
		print ('id: ' + cellValue)
	
	for col in range(ncols-1):
		if col != 0:
			outputFile.write(',\n')
		if PRINT_LEVEL >= 3:
			print ('col: ' + str(col))
		cellValue = getStrFromObj(rowData[col+1])
		if PRINT_LEVEL >= 1:
			if len(cellValue) == 0:
				colStr = getEcelColStr(col+2)
				print ('Warning: the value in row %d col %s is null!' % (row+2, colStr))
		field = fieldName[col+1]
		if(row_type[col+1] == COL_TYPE):
			if(len(cellValue) == 0):
				lineStr = '\"' + field + '\" : 0'
			else:
				lineStr = '\"' + field + '\" : ' + cellValue + ''
		else:
			lineStr = '\"' + field + '\" : \"' + cellValue + '\"'
		if PRINT_LEVEL >= 3:
			print (lineStr)
		outputFile.write('\t\t' + lineStr)
		
	outputFile.write('\n\t}')

def praseSheetData(outputFileName, sheet, errorFile):
	if sheet.nrows != 0:
		# open file
		outputFile = codecs.open(outputFileName, 'w', 'utf-8')

		firstLine = True
		# prase table data begin
		if firstLine:
			firstLine = False
		else:
			outputFile.write(u'\n')
		outputFile.write(u'{\n')
		
		

		# get field
		fieldName = sheet.row_values(2)
		sheet_type = sheet.row_values(0)
		# for marge lua 
		json_struct = '"key":"'+ sheet_type[0] + '",\n"val":{\n'
				
		outputFile.write(json_struct)
			

		
		for row in range(sheet.nrows - 1):
			if row < 2:
				continue
			elif row > 2:
				outputFile.write(',\n')
			praseRowData(outputFile, fieldName, sheet.row_values(row + 1), row, errorFile, sheet_type)
		
		# prase table data end
		outputFile.write(u'\n}\n}')
		
		# close file
		outputFile.close()
	

def main():
	if len(sys.argv) != 2:
		print ('argv count != 2, program exit')
		print ('Usage: a.py excelFileName')
		exit(0)

	if PRINT_LEVEL >= 2:
		print ('****************')
		print ('excel to json')
		print ('****************')

	# prase file name
	excelFileName = sys.argv[1]
	if PRINT_LEVEL >= 2:
		print ('Excel File Name: ' + excelFileName)
	tmpStr = excelFileName.split('.')[0]
	jsonFileName = tmpStr[0:]# + '.json'
	if PRINT_LEVEL >= 2:
		print ('Json File Name: ' + jsonFileName)
		print ('****************')
	if os.path.exists(excelFileName) == False:
		if PRINT_LEVEL >= 1:
			print ('Warning: the excel file %s dose not exsit!' % (excelFileName))
		exit(0)

	# open file
	workbook = xlrd.open_workbook(excelFileName)
	
	# prase
	if PRINT_LEVEL >= 2:
		print ('Prase ...')
	
	# check how many sheets have data
	n = 0
	for sheet in workbook.sheets():
		if sheet.nrows != 0:
			n = n + 1
			
	# putout error
	errorFile = codecs.open('error.txt', 'a')# 追加
	errorFile.write(u'\n' + excelFileName + u':\n')
	
	for sheet in workbook.sheets():
		if n == 1:
			outputFileName = jsonFileName + '.json'
			praseSheetData(outputFileName, sheet, errorFile)
		else:
			outputFileName = sheet.name + '.json'
			praseSheetData(outputFileName, sheet, errorFile)
			
	# putout error
	errorFile.write(u'\n')
	errorFile.close
	
	if PRINT_LEVEL >= 2:
		print ('****************')
		print ('Excel to Json Finished!')
		print ('****************')
	
main()