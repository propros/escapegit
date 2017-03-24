module("Data",package.seeall)

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

function getMergeData( num )
	local MERGEdata = MERGE[num]
	return MERGEdata
end

function setItemappear(num , bool)
	ITEM[num].appear = bool
end

--物品
ITEM={}
ITEM[1] = {key=1,pic="icon/bell.png",name="铃铛",appear=false}
ITEM[2] = {key=2,pic="icon/book.png",name="书",appear=false}
ITEM[3] = {key=3,pic="icon/box.png",name="箱子",appear=false}
ITEM[4] = {key=4,pic="icon/elegant_easyicon.png",name="护身符",appear=false}
ITEM[5] = {key=5,pic="icon/key.png",name="钥匙",appear=false}
ITEM[6] = {key=6,pic="icon/doorkey.png",name="门钥匙",appear=false}
ITEM[7] = {key=7,pic="icon/stamp.png",name="印章",appear=false}
ITEM[8] = {key=8,pic="icon/water.png",name="墨水",appear=false}
ITEM[9] = {key=9,pic="icon/paper.png",name="纸",appear=false}
ITEM[10] = {key=10,pic="icon/mima3.png",name="密码3",appear=false}
ITEM[11] = {key=11,pic="icon/scissors.png",name="剪刀",appear=false}

MERGE={}

MERGE[1] = {key=1,id={3,11},nid=8}
MERGE[2] = {key=2,id={9,7},nid=10}

































