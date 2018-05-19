/*
** Desc:    LUA������
** Author:  ��ʤ
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
	exe,//�ýű�ִ��
	ret,//����
	ignore//ʲô������
};

class  LuaDebuger
{
public:
	LuaDebuger();
	~LuaDebuger();
	static LuaDebuger * getInstance();
	//��ʼ��
	bool init();
	//��������߳�
	void senseInput();
	//�򿪵�����
	int open();
	//�������
	void deb();
	//��ʾִ�е���;
	bool showLine(lua_Debug *ar);
	//����
	static void luaHook(lua_State *L, lua_Debug *ar);
	void onHook(lua_State *L, lua_Debug *ar);
	//����


private:
	lua_Debug *_mAr;
	
	typedef int (LuaDebuger::*CmdProcessRoutine) (std::string& tokens);
    typedef std::map<std::string, CmdProcessRoutine> MapCmdRoutines;
    MapCmdRoutines mMapCmdRoutines;

	//��ȡ�ļ���ָ������������
	string getFileString(const char *fileName, int start, int end);
	//ע������
	void registerCmdRoutines();
	//��������
	int parseCommand(std::string cmd);
    int cmd_Help(std::string& token);
	int cmd_Continue(std::string& tokens);
	int cmd_Next(std::string& tokens);
	int cmd_In(std::string& tokens);
	int cmd_Backtrace(std::string&);
	int cmd_Locals(std::string&);
	int cmd_ShowCode(std::string&);
	
	//����
	std::string codeStr;

	//��¼�������
	unsigned int mRunningLevel;
	//��ȡ���ж�ջ�����
	unsigned int getRunStackDepth();
	lua_State *_mState;
	
	static LuaDebuger * _instance;
	static char command[COMMANDSIZE];
};
#endif // __LUADEBUGER_H__
