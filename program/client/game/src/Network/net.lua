---------------------------------------------------------------------------
-- 
-- 此文件是自动生成的，禁止手动修改！
-- 
---------------------------------------------------------------------------
 
---------------------------------------------------------------------------------------------
-- 查找处理函数
---------------------------------------------------------------------------------------------
cc.exports.netMessageHandle = {}
netMessageHandle[11000000] = "test_sendToClient1"
netMessageHandle[11000001] = "test_sendToClient3"
netMessageHandle[11000002] = "test_sendToClient4"
netMessageHandle[11000100] = "testa_sendToClient1"
netMessageHandle[11000101] = "testa_sendToClient3"
netMessageHandle[11000102] = "testa_sendToClient4"
netMessageHandle[11020000] = "test_sendToClient1"
netMessageHandle[11020001] = "test_sendToClient3"
netMessageHandle[11020002] = "test_sendToClient4"
netMessageHandle[11020100] = "testa_sendToClient1"
netMessageHandle[11020101] = "testa_sendToClient3"
netMessageHandle[11020102] = "testa_sendToClient4"

 
---------------------------------------------------------------------------------------------
-- 查找结构体
---------------------------------------------------------------------------------------------
cc.exports.netMessageProto = {}
netMessageProto[11000000] = "data2"
netMessageProto[11000001] = "data2"
netMessageProto[11000002] = "data2"
netMessageProto[11000101] = "data1"
netMessageProto[11000102] = "data2"
netMessageProto[11020000] = "data2"
netMessageProto[11020001] = "data2"
netMessageProto[11020002] = "data2"
netMessageProto[11020101] = "data1"
netMessageProto[11020102] = "data2"


cc.exports.net = {}
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/test.si
--  这是注视哦 sendToServer1
---------------------------------------------------------------------------------------------
function net.test_sendToServer1()
    NetworkManager:send(01000000, "")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/test.si
--  这是注视哦 sendToServer2
---------------------------------------------------------------------------------------------
function net.test_sendToServer2(data1)
    NetworkManager:send(01000001, protobuf.encode("data1", data1))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/test.si
--  这是注视哦 sendToServer3
---------------------------------------------------------------------------------------------
function net.test_sendToServer3(data1)
    NetworkManager:send(01000002, protobuf.encode("data1", data1))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/test.si
--  这是注视哦sendToClient1
---------------------------------------------------------------------------------------------
function net.test_sendToClient1(data2)
    dump(data2)
	log("请实现函数:net.test_sendToClient1")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/test.si
-- 	sendToClient3(data2) 
---------------------------------------------------------------------------------------------
function net.test_sendToClient3(data2)
    dump(data2)
	log("请实现函数:net.test_sendToClient3")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/test.si
--  这是注视哦sendToClient4
---------------------------------------------------------------------------------------------
function net.test_sendToClient4(data2)
    dump(data2)
	log("请实现函数:net.test_sendToClient4")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToServer(Person)
    NetworkManager:send(01000100, protobuf.encode("Person", Person))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToServerllal(data1)
    NetworkManager:send(01000101, protobuf.encode("data1", data1))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToServertest(data2)
    NetworkManager:send(01000102, protobuf.encode("data2", data2))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToClient1()
    log("请实现函数:net.testa_sendToClient1")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToClient3(data1)
    dump(data1)
	log("请实现函数:net.testa_sendToClient3")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game1/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToClient4(data2)
    dump(data2)
	log("请实现函数:net.testa_sendToClient4")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/test.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.test_sendToServer1()
    NetworkManager:send(01020000, "")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/test.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.test_sendToServer2(data1)
    NetworkManager:send(01020001, protobuf.encode("data1", data1))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/test.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.test_sendToServer3(data1)
    NetworkManager:send(01020002, protobuf.encode("data1", data1))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/test.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.test_sendToClient1(data2)
    dump(data2)
	log("请实现函数:net.test_sendToClient1")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/test.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.test_sendToClient3(data2)
    dump(data2)
	log("请实现函数:net.test_sendToClient3")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/test.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.test_sendToClient4(data2)
    dump(data2)
	log("请实现函数:net.test_sendToClient4")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToServer(Person)
    NetworkManager:send(01020100, protobuf.encode("Person", Person))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToServerllal(data1)
    NetworkManager:send(01020101, protobuf.encode("data1", data1))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToServertest(data2)
    NetworkManager:send(01020102, protobuf.encode("data2", data2))
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToClient1()
    log("请实现函数:net.testa_sendToClient1")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToClient3(data1)
    dump(data1)
	log("请实现函数:net.testa_sendToClient3")
end
   
---------------------------------------------------------------------------------------------
-- 来自 game2/message/testa.si
--  这是注视哦
---------------------------------------------------------------------------------------------
function net.testa_sendToClient4(data2)
    dump(data2)
	log("请实现函数:net.testa_sendToClient4")
end

