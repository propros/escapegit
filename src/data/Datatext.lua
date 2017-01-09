module("Datatext",package.seeall)
function gettextData(num)
	local textData = TEXT[num]
	return textData
end
--语言
TEXT = {}
TEXT[1] = {key="1",text="测试text1"}
TEXT[2] = {key="2",text="测试text2"}
TEXT[3] = {key="3",text="测试text3"}

function getItemData(num)
	local itemdata = ITEM[num]
	return itemdata
end


--物品
ITEM={}
ITEM[1] = {key="1",pic="icon/bell.png",name="铃铛"}
ITEM[2] = {key="2",pic="icon/book.png",name="书"}
ITEM[3] = {key="3",pic="icon/box.png",name="箱子"}
ITEM[4] = {key="4",pic="icon/elegant.png",name="图标"}
ITEM[5] = {key="5",pic="icon/key.png",name="钥匙"}
ITEM[6] = {key="6",pic="icon/padlock.png",name="锁"}
ITEM[7] = {key="7",pic="icon/stamp.png",name="印章"}
ITEM[8] = {key="8",pic="icon/water.png",name="水"}


MERGE={}
MERGE[1] = {key="1",id={1,2},nid="3"}
MERGE[2] = {key="2",id={},nid=""}
MERGE[3] = {key="3",id={},nid=""}
MERGE[4] = {key="4",id={},nid=""}
MERGE[5] = {key="5",id={},nid=""}
MERGE[6] = {key="6",id={},nid=""}
MERGE[7] = {key="7",id={},nid=""}




