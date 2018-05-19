# coding=utf-8
# 将excel解析成lua文件
# version 1.0: 2014-3-8, 添加对重复id的检测

import os
import sys
import codecs
import xlrd #http://pypi.python.org/pypi/xlrd

def praseSheetData(outputFileName, sheet):
    if sheet.nrows != 0:
        # open file
        outputFile = codecs.open(outputFileName, 'w', 'utf-8')
                
        # get field
        #sheet_title = sheet.row_values(2)
        #sheet_type = sheet.row_values(0)
        strbuf = ""
        arr = []
        for row in range(sheet.nrows):
            rowData = sheet.row_values(row)
            ncols = len(rowData)
            for col in range(ncols):
                if row == 0 :
                    #print ("His name is %s"%(rowData[col]))
                    if rowData[col] == "DESC":
                        arr.append(col)
                if (col in arr):
                    pass
                else:
                    if type(rowData[col]) == float:
                        intValue = int(rowData[col])
                        floatValue = float(rowData[col])
                        decValue = floatValue - intValue
                        if decValue >= 0.0001:
                            floatValue = "%.4f" % floatValue
                            strbuf = str(floatValue)
                        else:
                            strbuf = str(intValue)
                    else:
                        strbuf = rowData[col]
                    outputFile.write(strbuf + ',\t')
            outputFile.write('\r')
        # close file
        outputFile.close()
    

def main():
    if len(sys.argv) != 2:
        print ('argv count != 2, program exit')
        print ('Usage: a.py excelFileName')
        exit(0)

    # prase file name
    excelFileName = sys.argv[1]
    
    tmpStr = excelFileName.split('.')[0]
    outputFileName = tmpStr[0:] + '.cfg'# + '.lua'

    # open file
    workbook = xlrd.open_workbook(excelFileName)
    
    
    for sheet in workbook.sheets():
        praseSheetData(outputFileName, sheet)
        break
    
main()