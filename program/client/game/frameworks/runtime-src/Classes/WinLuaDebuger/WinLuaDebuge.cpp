/******************************************************************************
// Desc:    LUA������
// Author:  ��ʤ
// Date:
// Last:
//
// ����ִ�С���һ��������������
// �г�Դ���롢ִ�в��г�����Դ����
// ��ӡ���ö�ջ��Ϣ��FRAME��Ϣ���ֲ�������Ϣ
// ����LUA���õ�����
// ִ��һ��LUA�ű�
// ���ʾֲ���������_L.(������)��ʽ���ʡ��޸�
// �����ϵ� deb(true) �������ϵ㣬deb() deb(false)�����ϵ�'
//
// continue/c             ����ִ��
// next/n                 ִ����һ�䣨�����뺯����
// in/i                   ִ����һ�䣨�ɽ��뺯����
// backtrace/b            ��ӡ���ö�ջ��Ϣ
// locals/l               ��ӡ���оֲ�����
// showCode/s                 �г�Դ����
/////////////////////////////////////////////////////////////////////////*/
#include "WinLuaDebuger.h"
#include <iostream>
USING_NS_CC;

int lua_Deb(lua_State *L)
{
    if (!lua_toboolean(L, 1))
    {
        LuaDebuger::getInstance()->deb();
    }
    return 0;
}
void LuaDebuger::deb()
{
    string str;//��ʽ
    cmd_In(str);
}

LuaDebuger * LuaDebuger::_instance = 0;
char LuaDebuger::command[COMMANDSIZE] = "";

static int _L__index(lua_State *L)
{
    const char *key = lua_tostring(L, -1);

    lua_Debug _ar;
    for (int depth = 0; lua_getstack(L, depth, &_ar); ++depth)
    {
        int n = 1, i = -1;
        const char *name = NULL;
        // ͳ���߼���������
        while ((name = lua_getlocal(L, &_ar, n++)) != NULL)
        {
            // ȡ���INDEX����ǰִ�в���߼�����������
            if (!strcmp(name, key))
                i = n - 1;
            lua_pop(L, 1);
        }
        if (i != -1)
        {
            lua_getlocal(L, &_ar, i);
            return 1;
        }

        // ����upvalue
        n = 1;
        lua_getinfo(L, "f", &_ar);
        while ((name = lua_getupvalue(L, -1, n++)) != NULL)
        {
            if (!strcmp(name, key))
                return 1;
            // ����lua_getupvalueʱѹ���ֵ
            lua_pop(L, 1);
        }
        // ����lua_getinfoʱѹ���function
        lua_pop(L, 1);
    }
    return 0;
}

static int _L__newindex(lua_State *L)
{
    const char *key = lua_tostring(L, -2);

    lua_Debug _ar;
    for (int depth = 0; lua_getstack(L, depth, &_ar); ++depth)
    {
        int n = 1, i = -1;
        const char *name = NULL;
        // ͳ���߼���������
        while ((name = lua_getlocal(L, &_ar, n++)) != NULL)
        {
            // ȡ���INDEX����ǰִ�в���߼�����������
            if (!strcmp(name, key))
                i = n - 1;
            lua_pop(L, 1);
        }
        // �ҵ��ֲ���������������
        if (i != -1)
        {
            lua_setlocal(L, &_ar, i);
            return 0;
        }
        // û���ҵ��ֲ�������������upvalue
        n = 1;
        lua_getinfo(L, "f", &_ar);
        while ((name = lua_getupvalue(L, -1, n++)) != NULL)
        {
            if (!strcmp(name, key))
                i = n - 1;
            // ����lua_getupvalueѹ���ֵ
            lua_pop(L, 1);
        }
        // �ҵ�upvalue
        if (i != -1)
        {
            // ��-2λ�õ�����ֵѹ�뵽�µ�-1λ��
            // ѹ֮ǰ��ջ�������ģ�
            //   -2 = ����̨�����ֵ
            //   -1 = lua_getinfo��ȡ��upvalue functionֵ
            //
            // ѹ���ջ�������ģ�
            //   -3 = ����̨�����ֵ
            //   -2 = lua_getinfo��ȡ��upvalue functionֵ
            //   -1 = ����̨�����ֵ��������
            lua_pushvalue(L, -2);
            // ջ[-2 -- lua_getinfo��ȡ��upvalue functionֵ]��upvalue(i) ����ջ[-1 ����̨�����ֵ��������]��ֵ
            lua_setupvalue(L, -2, i);
            // ����lua_getinfo��ȡ��upvalue functionֵ
            lua_pop(L, 1);
            return 0;
        }
        // ����lua_getinfoѹ���function
        lua_pop(L, 1);
    }
    printf("Unable to find local '%s'.\n", key);
    return 0;
}
LuaDebuger::LuaDebuger() :
codeStr("")
{
    CC_ASSERT(!_instance);
    CC_ASSERT(init());
}

LuaDebuger::~LuaDebuger()
{
    CC_ASSERT(this == _instance);
    _instance = nullptr;
}

bool LuaDebuger::init()
{
    //lua״̬��
    _mState = LuaEngine::getInstance()->getLuaStack()->getLuaState();
    lua_State *L = _mState;
    lua_pushstring(L, "_L");
    lua_newtable(L);
    lua_pushcclosure(L, _L__index, 0);
    lua_setfield(L, -2, "__index");
    lua_pushcclosure(L, _L__newindex, 0);
    lua_setfield(L, -2, "__newindex");
    lua_settable(L, LUA_GLOBALSINDEX);
    lua_getglobal(L, "_L");
    lua_setmetatable(L, -1);

    registerCmdRoutines();
    return true;
};

int LuaDebuger::open()
{
    lua_pushcfunction(_mState, lua_Deb);
    lua_setglobal(_mState, "deb");
    return 0;
}

LuaDebuger * LuaDebuger::getInstance()
{
    if (!_instance)
    {
        _instance = new LuaDebuger;
    }
	
    return _instance;
}

unsigned int LuaDebuger::getRunStackDepth()
{
    lua_Debug ld;
    unsigned int depth = 0;
    for (; lua_getstack(_mState, depth, &ld); ++depth);
    return depth;
}

void LuaDebuger::luaHook(lua_State *L, lua_Debug *ar)
{
    LuaDebuger::getInstance()->onHook(L, ar);
}

void LuaDebuger::onHook(lua_State *L, lua_Debug *ar)
{
    _mAr = ar;
    char command[COMMANDSIZE];
    LuaStack* engine = LuaEngine::getInstance()->getLuaStack();
    //��ǰ�㼶����mRunningLevel�򲻴�ӡ���ȴ��û�����
    if (mRunningLevel < getRunStackDepth())
        return;
    else
        showLine(ar);
    while (true)
    {
        std::cout << "deb->:";
        std::cin.getline(command, COMMANDSIZE);
        //����ֵȷ���ǲ��Ǽ����ȴ�����
        int result = LuaDebuger::getInstance()->parseCommand(command);
        switch (result)
        {
        case RESULTS::exe:
            engine->executeString(command);
            break;
        case RESULTS::ret:
            return;
        case RESULTS::ignore:
            break;
        default:
            engine->executeString(command);
            break;
        }
    }
}

string LuaDebuger::getFileString(const char *fileName, int start, int count)
{
    if (start < 0)
    {
        start = 0;
    }
    if (!FileUtils::getInstance()->isFileExist(fileName))
    {
        codeStr = "";
        return codeStr;
    }
    codeStr = FileUtils::getInstance()->getStringFromFile(fileName);
    int _start = 0;
    int _end = 0;
    int index = 0;
    for (int i = 0; i < start - 1; i++)
    {
        index = codeStr.find('\n', index) + 1;
    }
    _start = index;
    for (int i = 0; i <= count; i++)
    {
        index = codeStr.find('\n', index) + 1;
    }
    _end = index - 1;
    return codeStr.substr(_start, _end - _start);;
}

bool LuaDebuger::showLine(lua_Debug *ar)
{
    lua_getinfo(_mState, "lS", ar);
    //�ж��ǲ���c�ĺ���, �����ļ�������
    if (strcmp(ar->what, "C") == 0 || !FileUtils::getInstance()->isFileExist(ar->source))
    {
        return false;
    }
    //log(ar->source);//�ļ���
    //log("%d",ar->currentline);//��
    HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hOut, FOREGROUND_RED | FOREGROUND_INTENSITY);
    log(getFileString(ar->source, _mAr->currentline, 0).c_str());
    SetConsoleTextAttribute(hOut, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
    //log("%s %d->%s",ar->source, ar->currentline, fileString.c_str());
    return true;
}

int LuaDebuger::parseCommand(std::string cmd)
{
    MapCmdRoutines::iterator itr = mMapCmdRoutines.find(cmd);
    if (itr == mMapCmdRoutines.end())
    {
        return RESULTS::exe;
    }
    CmdProcessRoutine routine = itr->second;
    return (this->*routine)(cmd);
}

int LuaDebuger::cmd_Help(std::string&)
{
    static const char *szHelp =
        "**********************help**************************\n"
        "continue/c             resume execute script\n"
        "next/n                 execute next statement\n"
        "in/i                   step in function\n"
        "backtrace/b            print call stack info\n"
        "help                   show this message\n"
        "locals/l               print all locals\n"
        "showCode/s             list source script\n"
        "****************************************************\n"
        ;
    log(szHelp);
    return RESULTS::ignore;
}

int LuaDebuger::cmd_Continue(std::string& tokens)
{
    lua_sethook(_mState, luaHook, 0, 0);
    return RESULTS::ret;
};

int LuaDebuger::cmd_Next(std::string& tokens)
{
    lua_sethook(_mState, luaHook, LUA_MASKLINE, 0);
    mRunningLevel = getRunStackDepth();
    return RESULTS::ret;
}

int LuaDebuger::cmd_In(std::string& tokens)
{
    lua_sethook(_mState, luaHook, LUA_MASKLINE, 0);
    mRunningLevel = -1;
    return RESULTS::ret;
}

int LuaDebuger::cmd_Backtrace(std::string&)
{
    // ��ӡlua����ջ��ʼ  
    lua_getglobal(_mState, "debug");
    lua_getfield(_mState, -1, "traceback");
    int iError = lua_pcall(_mState,//VMachine    
        0,//Argument Count    
        1,//Return Value Count    
        0);
    const char* sz = lua_tostring(_mState, -1);
    log(sz);
    return RESULTS::ignore;
}

int LuaDebuger::cmd_Locals(std::string&)
{
    lua_State *L = _mState;
    const char* name = nullptr;

    lua_Debug _ar;
    int depth = 0;
    while (lua_getstack(L, depth, &_ar))
    {
        depth++;
    }
    depth--;
    HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hOut, FOREGROUND_GREEN | FOREGROUND_INTENSITY);
    for (; lua_getstack(L, depth, &_ar); depth--)
    {
        int n = 1;
        // �ȴ�ӡ���оֲ�������Ϣ
        while ((name = lua_getlocal(L, &_ar, n++)) != NULL)
        {
            if (strcmp(name, "(*temporary)"))
            {
                lua_getglobal(L, "print");
                lua_insert(L, -2);
                lua_pushfstring(L, "[%d] %s = ", depth, name);
                lua_insert(L, -2);
                lua_pcall(L, 2, 0, 0);
            }
            else
                lua_pop(L, 1);
        }
        // ��ӡ����UPVALUEֵ
        n = 1;
        lua_getinfo(L, "f", &_ar);
        while ((name = lua_getupvalue(L, -1, n++)) != NULL)
        {
            if (strcmp(name, "(*temporary)"))
            {
                lua_getglobal(L, "print");
                lua_insert(L, -2);
                lua_pushfstring(L, "[%d] %s = ", depth, name);
                lua_insert(L, -2);
                lua_pcall(L, 2, 0, 0);
            }
            else
                lua_pop(L, 1);
        }
    }
    SetConsoleTextAttribute(hOut, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
    return RESULTS::ignore;
}

int LuaDebuger::cmd_ShowCode(std::string&)
{
    lua_Debug *ar = _mAr;
    lua_getinfo(_mState, "lS", ar);
    //�ж��ǲ���c�ĺ���, �����ļ�������
    if (strcmp(ar->what, "C") == 0 || !FileUtils::getInstance()->isFileExist(ar->source))
    {
        return false;
    }
    HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
    /*log("%d",ar->linedefined);//����ͷ
    log("%d",ar->lastlinedefined);//����β
    log("%d",ar->currentline);//ִ����*/
    //log();//�ļ���
    SetConsoleTextAttribute(hOut, FOREGROUND_BLUE | FOREGROUND_GREEN | FOREGROUND_INTENSITY);
    log("file %s :%d", ar->source, ar->currentline - 5);
    SetConsoleTextAttribute(hOut, FOREGROUND_GREEN | FOREGROUND_INTENSITY);
    log(getFileString(ar->source, _mAr->currentline - 5, 4).c_str());
    SetConsoleTextAttribute(hOut, FOREGROUND_RED | FOREGROUND_INTENSITY);
    log(getFileString(ar->source, _mAr->currentline, 0).c_str());
    SetConsoleTextAttribute(hOut, FOREGROUND_GREEN | FOREGROUND_INTENSITY);
    log(getFileString(ar->source, _mAr->currentline + 1, 4).c_str());
    SetConsoleTextAttribute(hOut, FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
    return RESULTS::ignore;
}

void LuaDebuger::registerCmdRoutines()
{
    mMapCmdRoutines["help"] = &LuaDebuger::cmd_Help;
    mMapCmdRoutines["continue"] = &LuaDebuger::cmd_Continue;
    mMapCmdRoutines["c"] = &LuaDebuger::cmd_Continue;
    mMapCmdRoutines["next"] = &LuaDebuger::cmd_Next;
    mMapCmdRoutines["n"] = &LuaDebuger::cmd_Next;
    mMapCmdRoutines["in"] = &LuaDebuger::cmd_In;
    mMapCmdRoutines["i"] = &LuaDebuger::cmd_In;
    mMapCmdRoutines["backtrace"] = &LuaDebuger::cmd_Backtrace;
    mMapCmdRoutines["b"] = &LuaDebuger::cmd_Backtrace;
    mMapCmdRoutines["locals"] = &LuaDebuger::cmd_Locals;
    mMapCmdRoutines["l"] = &LuaDebuger::cmd_Locals;
    mMapCmdRoutines["showcode"] = &LuaDebuger::cmd_ShowCode;
    mMapCmdRoutines["s"] = &LuaDebuger::cmd_ShowCode;
}
