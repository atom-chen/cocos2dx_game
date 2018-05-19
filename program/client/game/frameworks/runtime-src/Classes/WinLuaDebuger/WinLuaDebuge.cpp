/******************************************************************************
// Desc:    LUA调试器
// Author:  陈胜
// Date:
// Last:
//
// 继续执行、下一步、跳进、跳出
// 列出源代码、执行并列出附近源代码
// 打印调用堆栈信息、FRAME信息、局部变量信息
// 进入LUA内置调试器
// 执行一行LUA脚本
// 访问局部变量采用_L.(变量名)方式访问、修改
// 条件断点 deb(true) 不会进入断点，deb() deb(false)则进入断点'
//
// continue/c             继续执行
// next/n                 执行下一句（不进入函数）
// in/i                   执行下一句（可进入函数）
// backtrace/b            打印调用堆栈信息
// locals/l               打印所有局部变量
// showCode/s                 列出源代码
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
    string str;//格式
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
        // 统计逻辑变量数量
        while ((name = lua_getlocal(L, &_ar, n++)) != NULL)
        {
            // 取最大INDEX（当前执行层的逻辑变量索引）
            if (!strcmp(name, key))
                i = n - 1;
            lua_pop(L, 1);
        }
        if (i != -1)
        {
            lua_getlocal(L, &_ar, i);
            return 1;
        }

        // 返回upvalue
        n = 1;
        lua_getinfo(L, "f", &_ar);
        while ((name = lua_getupvalue(L, -1, n++)) != NULL)
        {
            if (!strcmp(name, key))
                return 1;
            // 弹出lua_getupvalue时压入的值
            lua_pop(L, 1);
        }
        // 弹出lua_getinfo时压入的function
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
        // 统计逻辑变量数量
        while ((name = lua_getlocal(L, &_ar, n++)) != NULL)
        {
            // 取最大INDEX（当前执行层的逻辑变量索引）
            if (!strcmp(name, key))
                i = n - 1;
            lua_pop(L, 1);
        }
        // 找到局部变量，则设置它
        if (i != -1)
        {
            lua_setlocal(L, &_ar, i);
            return 0;
        }
        // 没有找到局部变量，则搜索upvalue
        n = 1;
        lua_getinfo(L, "f", &_ar);
        while ((name = lua_getupvalue(L, -1, n++)) != NULL)
        {
            if (!strcmp(name, key))
                i = n - 1;
            // 弹出lua_getupvalue压入的值
            lua_pop(L, 1);
        }
        // 找到upvalue
        if (i != -1)
        {
            // 把-2位置的输入值压入到新的-1位置
            // 压之前，栈是这样的：
            //   -2 = 控制台输入的值
            //   -1 = lua_getinfo获取的upvalue function值
            //
            // 压入后，栈是这样的：
            //   -3 = 控制台输入的值
            //   -2 = lua_getinfo获取的upvalue function值
            //   -1 = 控制台输入的值（副本）
            lua_pushvalue(L, -2);
            // 栈[-2 -- lua_getinfo获取的upvalue function值]的upvalue(i) 等于栈[-1 控制台输入的值（副本）]的值
            lua_setupvalue(L, -2, i);
            // 弹出lua_getinfo获取的upvalue function值
            lua_pop(L, 1);
            return 0;
        }
        // 弹出lua_getinfo压入的function
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
    //lua状态机
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
    //当前层级大于mRunningLevel则不打印不等待用户输入
    if (mRunningLevel < getRunStackDepth())
        return;
    else
        showLine(ar);
    while (true)
    {
        std::cout << "deb->:";
        std::cin.getline(command, COMMANDSIZE);
        //返回值确定是不是继续等待输入
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
    //判断是不是c的函数, 或者文件不存在
    if (strcmp(ar->what, "C") == 0 || !FileUtils::getInstance()->isFileExist(ar->source))
    {
        return false;
    }
    //log(ar->source);//文件名
    //log("%d",ar->currentline);//行
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
    // 打印lua调用栈开始  
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
        // 先打印所有局部变量信息
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
        // 打印所有UPVALUE值
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
    //判断是不是c的函数, 或者文件不存在
    if (strcmp(ar->what, "C") == 0 || !FileUtils::getInstance()->isFileExist(ar->source))
    {
        return false;
    }
    HANDLE hOut = GetStdHandle(STD_OUTPUT_HANDLE);
    /*log("%d",ar->linedefined);//函数头
    log("%d",ar->lastlinedefined);//函数尾
    log("%d",ar->currentline);//执行行*/
    //log();//文件名
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
