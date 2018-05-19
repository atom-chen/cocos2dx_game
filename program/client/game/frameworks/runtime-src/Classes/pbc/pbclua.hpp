#include "base/ccConfig.h"

#ifndef PROTOBUF_C_PBCLUA_H
#define PROTOBUF_C_PBCLUA_H
#ifdef __cplusplus
extern "C" {
#endif
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#include "pbc.h"

#ifdef __cplusplus
}
#endif

int luaopen_protobuf_c(lua_State* tolua_S);



#endif // PROTOBUF_C_PBCLUA_H
