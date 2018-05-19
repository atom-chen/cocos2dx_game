# coding: utf-8


import os
import sys
import codecs
import xlrd #http://pypi.python.org/pypi/xlrd
if sys.getdefaultencoding() != 'utf-8':
	reload(sys)
	sys.setdefaultencoding('utf-8')

# 全局变量
COL_TYPE_STRING = u"STRING"
COL_TYPE_BOOL = u"BOOL"
COL_TYPE_LANGUAGE = u"LANGUAGE"
LOG_FILE_NAME = u"log.txt"
FILE_TYPE = u"xlsx"
LANGUAGE_FILE_NAME = "language.lua"

CONFIG_FILE_NAME = u"Config."

CONFIG_FILE_REQUIRE_NAME = u"RequireConfig.lua"

errorFile = codecs.open(LOG_FILE_NAME, 'w+')# 重置错误文件

languageId = 0 # 语言表文件
def getStrFromObj(obj):
	if type(obj) == float:
		intValue = int(obj)
		floatValue = float(obj)
		decValue = floatValue - intValue
		if decValue >= 0.0001:
			#return str(obj)
			floatValue = "%.4f" % floatValue
			return str(floatValue)
		else:
			return str(intValue)
	else:
		return obj

def log(_str):
	print(_str)
	errorFile.write(_str + u'\n')

def fieldLegitimate(fields):
	# 记录字段名字，用于检查重复
	haveKeys = {}
	for field in fields:
		if haveKeys.has_key(field) == True:
			log("错误: 字段 " + field + " 重复！")
			exit(0)
		else:
			haveKeys[field] = True

# 生成lua文件
def writeLua(table, path, excelName):
	luaFile = codecs.open(path, 'w+')

			# languageFile.write(field + u'\n')
	luaFile.write("---------------------------------------------------------------------------\n")
	luaFile.write("--\n")
	luaFile.write("-- 此文件是自动生成的，禁止手动修改！\n")
	luaFile.write("--\n")
	luaFile.write("---------------------------------------------------------------------------\n\n")
	luaFile.write("local M = {\n")

	types = table.row_values(0)# 字段类型
	descs = table.row_values(1)# 字段说明
	effective = table.row_values(2)# 字段是否有
	fields = table.row_values(3)# 字段名字

	# 检测配置文件字段
	fieldLegitimate(fields)

	for i in range(4, table.nrows):
		data = table.row_values(i)
		if len(getStrFromObj(data[0])) > 0:
			if (types[0] == "INT"):
				tempStr = '\t['+getStrFromObj(data[0])+'] = {\n\t\t'
			else:
				tempStr = '\t'+getStrFromObj(data[0])+' = {\n\t\t'

			for j in range(len(fields)):
				field = fields[j]
				fieldType = types[j]
				value = data[j]
				effectiveId = getStrFromObj(effective[j])

				if (effectiveId == "1" or effectiveId == "3") and len(field) > 0 and len(getStrFromObj(value)) > 0:
					if(fieldType == COL_TYPE_STRING):
						tempStr += field + ' = "' + getStrFromObj(value) + '", '

					elif(fieldType == COL_TYPE_BOOL):
						if(getStrFromObj(value) == "0"):
							tempStr += field + ' = false, '
						else:
							tempStr += field + ' = true, '

					elif fieldType == COL_TYPE_LANGUAGE:
						global languageId
						languageId += 1
						languageFile.write('\n\t['+str(languageId)+'] = "' + getStrFromObj(value) + '",')
						tempStr += field + ' = ' + str(languageId) + ','

					else:
						tempStr += field + ' = ' + getStrFromObj(value) + ', '
			tempStr += '\n\t},\n'
			luaFile.write(tempStr)


	luaFile.write("}\n\n")

	metatableStr = "---------------------------------------------------------------------------------------------\n"
	metatableStr += "-- 空值检测\n"
	metatableStr += "---------------------------------------------------------------------------------------------\n"
	metatableStr += "setmetatable(M, {__index = function (t, key)\n"
	metatableStr += "\terror(string.format(\"配置表" + excelName + "不存在id = %s !\", key))\n"
	metatableStr += "end})\n\n"

	# setmetatable(M, {__index = function (t, key)
	# 		print(t, key)
	# end})

	luaFile.write(metatableStr)
	luaFile.write("return M")
	luaFile.close()


def handleExcel(path, toPath, excelName):
	log(u'生成配置文件: %s ==> %s'%(path,toPath))
	# open file
	workbook = xlrd.open_workbook(path)
	
	# 只处理每个文件的第一页
	table = workbook.sheets()[0]

	# print(table.nrows)# 行数
	# print(table.ncols)# 列数

	# 生成配置文件
	writeLua(table, toPath, excelName)

def getRequireName(str):
	return "cfg" + str[0:1].capitalize() + str[1:len(str)]

def writeLanguageLuaBegin():
	languageFile.write("---------------------------------------------------------------------------\n")
	languageFile.write("--\n")
	languageFile.write("-- 此文件是自动生成的，禁止手动修改！\n")
	languageFile.write("--\n")
	languageFile.write("---------------------------------------------------------------------------\n\n")
	languageFile.write("local M = {")

def writeLanguageLuaEnd():
	languageFile.write("\n}\n\n")
	languageFile.write("---------------------------------------------------------------------------------------------\n")
	languageFile.write("--\n")
	languageFile.write("-- 获取字符串，根据语言表id\n")
	languageFile.write("--\n")
	languageFile.write("---------------------------------------------------------------------------------------------\n")
	languageFile.write("function cc.exports.getLanguageById(id)\n")
	languageFile.write("\treturn M[id]\n")
	languageFile.write("end\n\n")
	languageFile.write("return M")
	languageFile.close()


def writeRequireLuaBegin():
	requireLuaFile.write("---------------------------------------------------------------------------\n")
	requireLuaFile.write("--\n")
	requireLuaFile.write("-- 此文件是自动生成的，禁止手动修改！\n")
	requireLuaFile.write("--\n")
	requireLuaFile.write("---------------------------------------------------------------------------\n\n")
	requireLuaFile.write("cc.exports." + getRequireName(LANGUAGE_FILE_NAME.split('.')[0]) +" = " + "require(\"" + CONFIG_FILE_NAME + LANGUAGE_FILE_NAME.split('.')[0]+"\")\n")




def main():
	if len(sys.argv) != 3:
		log (u'参数必须是3个！')
		exit(0)

	log (u'****************')
	log (u'开始生成配置文件')

	# prase file name
	excelFilePath = ""
	luaFilePath = ""
	inputFilePath = sys.argv[1]
	outputFilePath = sys.argv[2]

	global languageFile
	languageFile = codecs.open(outputFilePath+LANGUAGE_FILE_NAME, 'w+')# 语言文件
	writeLanguageLuaBegin()

	global requireLuaFile
	requireLuaFile = codecs.open(outputFilePath+CONFIG_FILE_REQUIRE_NAME, 'w+')# require文件
	writeRequireLuaBegin()

	fs = os.listdir(inputFilePath)
	for fname in fs:
		excelFilePath = os.path.join(inputFilePath,fname)
		# # 只处理文件和避开临时文件
		if not os.path.isdir(excelFilePath):
			if fname.find("~$") == -1:
				luaFileName = fname.split('.')[0]
				handleExcel(excelFilePath, outputFilePath + luaFileName+".lua", fname)
				requireLuaFile.write("cc.exports." + getRequireName(luaFileName) +" = require(\"" + CONFIG_FILE_NAME + luaFileName+"\")\n")
		# else:
		# 	log(u'警告:跳过文件夹' + excelFilePath)
	log (u'生成配置文件完毕')
	log (u'****************')
main()

writeLanguageLuaEnd()
languageFile.close()
errorFile.close()