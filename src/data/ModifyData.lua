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

--设置场景数
function setSceneNumber(num)
	sceneNumber = num
end
--设置关卡数
function setChapterNumber(num)
	chapterNumber = num
end
--得到场景数
function getSceneNumber()
	return sceneNumber
end
--得到关卡数
function getChapterNumber()
	return chapterNumber
end
--设置星星数
function setStarNumber(num)
	starNumber = num
end
--得到星星数
function getStarNumber()
	return starNumber
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
