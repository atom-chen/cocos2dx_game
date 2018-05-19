---------------------------------------------------------------------------
--
-- 此文件是自动生成的，禁止手动修改！
--
---------------------------------------------------------------------------

local M = {
	[0] = {
		id = 0, testInt = 0, testBool = false, testString = "描述1", textLanguage = 1,testFloat = 0.1111, 
	},
	[1] = {
		id = 1, testInt = 0, testBool = false, testString = "描述2\n描述2\n描述2\n", textLanguage = 2,testFloat = 1.1112, 
	},
	[2] = {
		id = 2, testString = "描述3", textLanguage = 3,testFloat = 2.1111, 
	},
	[3] = {
		id = 3, testInt = 2000000000, testBool = false, textLanguage = 4,testFloat = 0, 
	},
	[4] = {
		id = 4, testInt = 0, testBool = false, testString = "描述5", textLanguage = 5,testFloat = 4.1111, 
	},
	[5] = {
		id = 5, testInt = 1111, testBool = false, testString = "描述6", testFloat = 5.1111, 
	},
	[6] = {
		id = 6, testInt = 0, testBool = true, testString = "描述7", textLanguage = 6,testFloat = 6.1111, 
	},
	[7] = {
		id = 7, testInt = 0, testBool = true, testString = "描述8", textLanguage = 7,testFloat = 7.1111, 
	},
	[8] = {
		id = 8, testInt = 1111, testBool = true, testString = "描述9", textLanguage = 8,testFloat = 8.1111, 
	},
}

---------------------------------------------------------------------------------------------
-- 空值检测
---------------------------------------------------------------------------------------------
setmetatable(M, {__index = function (t, key)
	error(string.format("配置表test.xlsx不存在id = %s !", key))
end})

return M