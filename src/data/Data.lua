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

function getdestMergeTable()
	return MERGE
end

function setItemappear(num , bool)
	ITEM[num].appear = bool
end

function getRoomtb()
	return ROOM
end

function getsavedata(  )
	return SAVEDATA
end


--物品
ITEM={}

ITEM[1] = {key=1,pic="icon/piece.png",name="锋利的碎片",appear=true,ifcontain = true,inname="piece",tishi="锋利的镜子碎片，不过还不足以划破很厚的布料"}
ITEM[2] = {key=2,pic="icon/passpaper.png",name="密码纸",appear=true,ifcontain = true,inname="passpaper",tishi="写着密码的纸"}
ITEM[3] = {key=3,pic="icon/box.png",name="带绳箱子",appear=true,ifcontain = true,inname="box",tishi="箱子",tishi="被绳子系住的盒子，绳子很紧，需要东西割开"}
ITEM[4] = {key=4,pic="icon/elegant_easyicon.png",name="护身符",appear=true,ifcontain = true,inname="elegant_easyicon",tishi="和贝诺特利的国徽相同、具有奥拉汀女神标志的护身符"}
ITEM[5] = {key=5,pic="icon/pot.png",name="红色颜料",appear=true,ifcontain = true,inname="pot",tishi="装着红色颜料的颜料罐"}
ITEM[6] = {key=6,pic="icon/brush.png",name="刷子",appear=true,ifcontain = true,inname="brush",tishi="一把颜料刷"}
ITEM[7] = {key=7,pic="icon/redbrush.png",name="红色刷子",appear=true,ifcontain = true,inname="redbrush",tishi="一把蘸有红色颜料的颜料刷"}
ITEM[8] = {key=8,pic="icon/stool.png",name="凳子",appear=true,ifcontain = true,inname="stool",tishi="小凳子，可以踩在上面够到更高的地方"}
ITEM[9] = {key=9,pic="icon/phonenum.png",name="电话纸",appear=true,ifcontain = true,inname="phonepaper",tishi="一张写着电话号码的纸"}
ITEM[10] = {key=10,pic="icon/boxpass.png",name="密码盒子",appear=true,ifcontain = true,inname="boxpass",tishi="一个四位数字密码的小盒子"}
ITEM[11] = {key=11,pic="icon/scissors.png",name="剪刀",appear=true,ifcontain = true,inname="scissors",tishi="一把锋利的剪刀"}
ITEM[12] = {key=12,pic="icon/scissorsright.png",name="剪刀右半边",appear=true,ifcontain = true,inname="scissorsright",tishi="剪刀的右半边"}
ITEM[13] = {key=13,pic="icon/scissorsleft.png",name="剪刀左半边",appear=true,ifcontain = true,inname="scissorsleft",tishi="剪刀的左半边"}
ITEM[14] = {key=14,pic="icon/hammer.png",name="小锤子",appear=true,ifcontain = true,inname="hammer",tishi="一把小锤子，可以用来敲碎什么东西"}
ITEM[15] = {key=15,pic="icon/paperpen.png",name="笔和纸",appear=true,ifcontain = true,inname="paperpen",tishi="笔和纸，可以用来抄写东西"}
ITEM[16] = {key=16,pic="icon/redflower.png",name="红色花朵",appear=true,ifcontain = true,inname="redflower",use = false,tishi="被刷成红色的花朵，不知怎的看起来有些让人不舒服"}
ITEM[17] = {key=17,pic="icon/bedkey.png",name="床头柜钥匙",appear=true,ifcontain = true,inname="bedkey",tishi="床头柜钥匙"}
ITEM[18] = {key=18,pic="icon/key.png",name="衣柜的钥匙",appear=true,ifcontain = true,inname="key",tishi="衣柜的钥匙"}
ITEM[19] = {key=19,pic="icon/doorkey.png",name="一把门钥匙",appear=true,ifcontain = true,inname="doorkey",tishi="一把门钥匙"}
ITEM[20] = {key=20,pic="icon/stamp.png",name="圆形印章",appear=true,ifcontain = true,inname="stamp",tishi="带有奥拉汀女神标志的圆形印章"}
-- ITEM[21] = {key=21,pic="icon/yansemima.png",name="颜色密码箱",appear=true,ifcontain = true,inname="yansemima",tishi=""}
ITEM[22] = {key=22,pic="icon/familyphoto.png",name="家族照片",appear=true,ifcontain = true,inname="familyphoto",tishi="一张全家福的照片"}
ITEM[23] = {key=23,pic="icon/liguikey.png",name="立柜钥匙",appear=true,ifcontain = true,inname="liguikey",tishi="立柜钥匙"}



MERGE={}

MERGE[1] = {key=1,id={13,12},nid=11}
MERGE[2] = {key=2,id={3,1},nid=20}
MERGE[3] = {key=3,id={2,10},nid=13}
MERGE[4] = {key=4,id={5,6},nid=7}
-- MERGE[5] = {key=5,id={9,6},nid=7}


SCENE = {}
SCENE[1] = {}
SCENE[1][1] = {lock = 0}
SCENE[1][2] = {lock = 1}
SCENE[1][3] = {lock = 1}

SCENE[2] = {}
SCENE[2][1] = {lock = 0}
SCENE[2][2] = {lock = 1}
SCENE[2][3] = {lock = 1}

SCENE[3] = {}
SCENE[3][1] = {lock = 0}
SCENE[3][2] = {lock = 1}
SCENE[3][3] = {lock = 1}

CHAPTER = {}
CHAPTER[1] = {lock = 0}
CHAPTER[2] = {lock = 0}
CHAPTER[3] = {lock = 0}

-- 保存游戏进度

SAVEDATA = {girlpositionx = 480, bgpositionx = 0 }






































