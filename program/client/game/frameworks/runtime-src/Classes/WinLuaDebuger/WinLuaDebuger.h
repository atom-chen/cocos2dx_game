/*
** Desc:    LUA调试器
** Author:  陈胜
** Date:    
** Last:
*/
#ifndef __LUADEBUGER_H__
#define __LUADEBUGER_H__

#include "cocos2d.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include <thread>
USING_NS_CC;

using namespace std;

#define COMMANDSIZE 1024

enum RESULTS
{
	exe,//让脚本执行
	ret,//返回
	ignore//什么都不做
};

class  LuaDebuger
{
public:
	LuaDebuger();
	~LuaDebuger();
	static LuaDebuger * getInstance();
	//初始化
	bool init();
	//检测输入线程
	void senseInput();
	//打开调试器
	int open();
	//进入调试
	void deb();
	//显示执行的行;
	bool showLine(lua_Debug *ar);
	//钩子
	static void luaHook(lua_State *L, lua_Debug *ar);
	void onHook(lua_State *L, lua_Debug *ar);
	//钩子


private:
	lua_Debug *_mAr;
	
	typedef int (LuaDebuger::*CmdProcessRoutine) (std::string& tokens);
    typedef std::map<std::string, CmdProcessRoutine> MapCmdRoutines;
    MapCmdRoutines mMapCmdRoutines;

	//获取文件里指定行数的内容
	string getFileString(const char *fileName, int start, int end);
	//注册命令
	void registerCmdRoutines();
	//解析命令
	int parseCommand(std::string cmd);
    int cmd_Help(std::string& token);
	int cmd_Continue(std::string& tokens);
	int cmd_Next(std::string& tokens);
	int cmd_In(std::string& tokens);
	int cmd_Backtrace(std::string&);
	int cmd_Locals(std::string&);
	int cmd_ShowCode(std::string&);
	
	//代码
	std::string codeStr;

	//记录运行深度
	unsigned int mRunningLevel;
	//获取运行堆栈的深度
	unsigned int getRunStackDepth();
	lua_State *_mState;
	
	static LuaDebuger * _instance;
	static char command[COMMANDSIZE];
};
#endif // __LUADEBUGER_H__
