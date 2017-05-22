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

function getdestMergeTable( )
	return MERGE
end

function setItemappear(num , bool)
	ITEM[num].appear = bool
end


--物品
ITEM={}

ITEM[1] = {key=1,pic="icon/piece.png",name="锋利的碎片",appear=true,ifcontain = true,inname="piece"}
ITEM[2] = {key=2,pic="icon/passpaper.png",name="密码纸",appear=true,ifcontain = true,inname="passpaper"}
ITEM[3] = {key=3,pic="icon/box.png",name="带绳箱子",appear=true,ifcontain = true,inname="box"}
ITEM[4] = {key=4,pic="icon/elegant_easyicon.png",name="护身符",appear=true,ifcontain = true,inname="elegant_easyicon"}
ITEM[5] = {key=5,pic="icon/pot.png",name="红色颜料",appear=true,ifcontain = true,inname="pot"}
ITEM[6] = {key=6,pic="icon/brush.png",name="刷子",appear=true,ifcontain = true,inname="brush"}
ITEM[7] = {key=7,pic="icon/redbrush.png",name="红色刷子",appear=true,ifcontain = true,inname="redbrush"}
ITEM[8] = {key=8,pic="icon/stool.png",name="凳子",appear=true,ifcontain = true,inname="stool"}
ITEM[9] = {key=9,pic="icon/phonenum.png",name="电话纸",appear=true,ifcontain = true,inname="phonepaper"}
ITEM[10] = {key=10,pic="icon/boxpass.png",name="密码盒子",appear=true,ifcontain = true,inname="boxpass"}
ITEM[11] = {key=11,pic="icon/scissors.png",name="剪刀",appear=true,ifcontain = true,inname="scissors"}
ITEM[12] = {key=12,pic="icon/scissorsright.png",name="剪刀右半",appear=true,ifcontain = true,inname="scissorsright"}
ITEM[13] = {key=13,pic="icon/scissorsleft.png",name="剪刀左半",appear=true,ifcontain = true,inname="scissorsleft"}
ITEM[14] = {key=14,pic="icon/hammer.png",name="小锤子",appear=true,ifcontain = true,inname="hammer"}
ITEM[15] = {key=15,pic="icon/paperpen.png",name="笔和纸",appear=true,ifcontain = true,inname="paperpen"}
ITEM[16] = {key=16,pic="icon/redflower.png",name="红色花朵",appear=true,ifcontain = true,inname="redflower",use = false}
ITEM[17] = {key=17,pic="icon/bedkey.png",name="床头柜钥匙",appear=true,ifcontain = true,inname="bedkey"}
ITEM[18] = {key=18,pic="icon/key.png",name="衣柜钥匙",appear=true,ifcontain = true,inname="key"}
ITEM[19] = {key=19,pic="icon/doorkey.png",name="门钥匙",appear=true,ifcontain = true,inname="doorkey"}
ITEM[20] = {key=20,pic="icon/stamp.png",name="圆形印章",appear=true,ifcontain = true,inname="stamp"}
ITEM[21] = {key=21,pic="icon/yansemima.png",name="颜色密码箱",appear=true,ifcontain = true,inname="yansemima"}
ITEM[22] = {key=22,pic="icon/familyphoto.png",name="家族照片",appear=true,ifcontain = true,inname="familyphoto"}
ITEM[23] = {key=23,pic="icon/liguikey.png",name="立柜钥匙",appear=true,ifcontain = true,inname="liguikey"}




MERGE={}

MERGE[1] = {key=1,id={13,12},nid=11}
MERGE[2] = {key=2,id={3,1},nid=20}
MERGE[3] = {key=3,id={2,10},nid=13}
MERGE[4] = {key=4,id={5,6},nid=7}
-- MERGE[5] = {key=5,id={9,6},nid=7}






































