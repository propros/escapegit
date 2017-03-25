module("ModifyData",package.seeall)

sceneNumber = 1
chapterNumber = 1 
starNumber = 0

bool = false
ITEM_TABLE = {}
-- 将item加到table里面
function tableinsert(str)
	table.insert(ITEM_TABLE, str)
end

--得到ITEM_TABLE个数
function getTableNum()
	return #ITEM_TABLE
end
--得到ITEM_TABLE
function getTable()
	return ITEM_TABLE
end

--写入沙盒路径
function writeToDoc(str)
	local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
    local f = assert(io.open(docpath, 'w'))
    f:write(str)
    f:close()
end

--从沙盒路径下读出
function readFromDoc()
	local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
 	local str = cc.FileUtils:getInstance():getStringFromFile(docpath)
  	return str
end
