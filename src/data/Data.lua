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

ITEM[1] = {key=1,pic="icon/icon11/piece.png",name="锋利的碎片",appear=true,ifcontain = true,inname="piece",tishi="锋利的镜子碎片，不过还不足以划破很厚的布料。"}
ITEM[2] = {key=2,pic="icon/icon11/passpaper.png",name="密码纸",appear=true,ifcontain = true,inname="passpaper",tishi="写着密码的纸。"}
ITEM[3] = {key=3,pic="icon/icon11/box.png",name="带绳箱子",appear=true,ifcontain = true,inname="box",tishi="箱子",tishi="被缎带系住的盒子，要想打开需要先把缎带割断。"}
ITEM[4] = {key=4,pic="icon/icon11/elegant_easyicon.png",name="护身符",appear=true,ifcontain = true,inname="elegant_easyicon",tishi="和贝诺特利的国徽相同、具有奥拉汀女神标志的护身符。",shoucangpic="shoucang/shoucang11/elegant_easyicon.png"}
ITEM[5] = {key=5,pic="icon/icon11/pot.png",name="红色颜料",appear=true,ifcontain = true,inname="pot",tishi="装着红色颜料的颜料罐。"}
ITEM[6] = {key=6,pic="icon/icon11/brush.png",name="刷子",appear=true,ifcontain = true,inname="brush",tishi="一把颜料刷。"}
ITEM[7] = {key=7,pic="icon/icon11/redbrush.png",name="红色刷子",appear=true,ifcontain = true,inname="redbrush",tishi="一把蘸有红色颜料的颜料刷。"}
ITEM[8] = {key=8,pic="icon/icon11/stool.png",name="凳子",appear=true,ifcontain = true,inname="stool",tishi="小凳子，可以踩在上面够到更高的地方。"}
ITEM[9] = {key=9,pic="icon/icon11/phonenum.png",name="电话纸",appear=true,ifcontain = true,inname="phonepaper",tishi="一张写着电话号码的纸。"}
ITEM[10] = {key=10,pic="icon/icon11/boxpass.png",name="密码盒子",appear=true,ifcontain = true,inname="boxpass",tishi="一个四位数字密码的小盒子。"}
ITEM[11] = {key=11,pic="icon/icon11/scissors.png",name="剪刀",appear=true,ifcontain = true,inname="scissors",tishi="一把锋利的剪刀。"}
ITEM[12] = {key=12,pic="icon/icon11/scissorsright.png",name="剪刀右半边",appear=true,ifcontain = true,inname="scissorsright",tishi="剪刀的右半边。"}
ITEM[13] = {key=13,pic="icon/icon11/scissorsleft.png",name="剪刀左半边",appear=true,ifcontain = true,inname="scissorsleft",tishi="剪刀的左半边。"}
ITEM[14] = {key=14,pic="icon/icon11/hammer.png",name="小锤子",appear=true,ifcontain = true,inname="hammer",tishi="一把小锤子，可以用来敲碎什么东西。"}
ITEM[15] = {key=15,pic="icon/icon11/paperpen.png",name="笔和纸",appear=true,ifcontain = true,inname="paperpen",tishi="笔和纸，可以用来抄写东西。"}
ITEM[16] = {key=16,pic="icon/icon11/redflower.png",name="红色花朵",appear=true,ifcontain = true,inname="redflower",tishi="被刷成红色的花朵，不知怎的看起来有些让人不舒服。"}
ITEM[17] = {key=17,pic="icon/icon11/bedkey.png",name="床头柜钥匙",appear=true,ifcontain = true,inname="bedkey",tishi="床头柜钥匙。"}
ITEM[18] = {key=18,pic="icon/icon11/key.png",name="衣柜的钥匙",appear=true,ifcontain = true,inname="yiguikey",tishi="衣柜的钥匙。"}
ITEM[19] = {key=19,pic="icon/icon11/doorkey.png",name="一把门钥匙",appear=true,ifcontain = true,inname="doorkey",tishi="一把门钥匙。"}
ITEM[20] = {key=20,pic="icon/icon11/stamp.png",name="圆形印章",appear=true,ifcontain = true,inname="stamp",tishi="带有奥拉汀女神标志的圆形印章。"}
ITEM[22] = {key=22,pic="icon/icon11/familyphoto.png",name="家族照片",appear=true,ifcontain = true,inname="familyphoto",tishi="一张全家福的照片。"}
ITEM[23] = {key=23,pic="icon/icon11/liguikey.png",name="立柜钥匙",appear=true,ifcontain = true,inname="liguikey",tishi="立柜钥匙。"}

--GameScene 12 
ITEM[24] = {key=24,pic="icon/icon12/letter.png",name="请柬",appear=true,ifcontain = true,inname="letter",tishi="亲爱的……我诚挚邀请您参加我们家族的聚会，请务必光临。"}
ITEM[25] = {key=25,pic="icon/icon12/huaibiao.png",name="怀表",appear=true,ifcontain = true,inname="huaibiao",tishi="怀表。"}
ITEM[26] = {key=26,pic="icon/icon12/maoyan.png",name="猫眼",appear=true,ifcontain = true,inname="maoyan",tishi="一对发着绿光的石头猫眼。"}
ITEM[27] = {key=27,pic="icon/icon12/huoqian.png",name="火钳",appear=true,ifcontain = true,inname="huoqian",tishi="一把火钳。"}
ITEM[28] = {key=28,pic="icon/icon12/xiaoyubing.png",name="小鱼饼",appear=true,ifcontain = true,inname="xiaoyubing",tishi="小鱼形状的饼干，猫咪的最爱？"}
ITEM[29] = {key=29,pic="icon/icon12/rongyaoshi.png",name="熔融钥匙",appear=true,ifcontain = true,inname="rongyaoshi",tishi="它被火烧熔了，不过勉强能看出来是个钥匙的形状。"}
ITEM[30] = {key=30,pic="icon/icon12/qinghua.png",name="绿花",appear=true,ifcontain = true,inname="qinghua",tishi="绿色的花朵，如果和粉色的花朵搭配起来应该会很好看。"}
ITEM[31] = {key=31,pic="icon/icon12/zihua.png",name="紫花",appear=true,ifcontain = true,inname="zihua",tishi="紫色的花朵，如果和绿色的花朵搭配起来应该会很好看。"}
ITEM[32] = {key=32,pic="icon/icon12/fenhua.png",name="粉色花",appear=true,ifcontain = true,inname="fenhua",tishi="粉色的花朵，如果和紫色的花朵搭配起来应该会很好看。"}
ITEM[33] = {key=33,pic="icon/icon12/jigui_key.png",name="唱片柜钥匙",appear=true,ifcontain = true,inname="jigui_key",tishi="唱片柜的钥匙。"}
ITEM[34] = {key=34,pic="icon/icon12/changpian.png",name="唱片",appear=true,ifcontain = true,inname="changpian",tishi="一张唱片。"}
ITEM[35] = {key=35,pic="icon/icon12/seed.png",name="种子",appear=true,ifcontain = true,inname="seed",tishi="留声机中生长出来的种子，不知道可以种出来什么？"}
ITEM[36] = {key=36,pic="icon/icon12/handsclock.png",name="时针",appear=true,ifcontain = true,inname="handsclock",tishi="时钟的时针。"}
ITEM[37] = {key=37,pic="icon/icon12/zi_qing.png",name="绿紫",appear=true,ifcontain = true,inname="zi_qing",tishi="紫色和绿色的花朵。"}
ITEM[38] = {key=38,pic="icon/icon12/fen_qing.png",name="绿粉",appear=true,ifcontain = true,inname="fen_qing",tishi="绿色和粉色的花朵。"}
ITEM[39] = {key=39,pic="icon/icon12/zi_fen.png",name="紫粉",appear=true,ifcontain = true,inname="zi_fen",tishi="紫色和粉色的花朵。"}
ITEM[40] = {key=40,pic="icon/icon12/flower_ring.png",name="花环",appear=true,ifcontain = true,inname="flower_ring",tishi="好看的花环，作为礼物应该没有人会不喜欢。"}
ITEM[41] = {key=41,pic="icon/icon12/daocao.png",name="稻草",appear=true,ifcontain = true,inname="daocao",tishi="干枯的金色稻草。"}
ITEM[42] = {key=42,pic="icon/icon12/shuihu.png",name="水壶",appear=true,ifcontain = true,inname="shuihu",tishi="一把装着水的小水壶。"}
ITEM[43] = {key=43,pic="icon/icon12/knife.png",name="小刀",appear=true,ifcontain = true,inname="knife",tishi="刀刃很薄的小匕首，看起来很脆弱的样子。"}
ITEM[44] = {key=44,pic="icon/icon12/fenzhen.png",name="分针",appear=true,ifcontain = true,inname="fenzhen",tishi="时钟的分针。"}
ITEM[45] = {key=45,pic="icon/icon12/zhizhen.png",name="指针",appear=true,ifcontain = true,inname="zhizhen",tishi="组装好的时钟指针。"}
ITEM[46] = {key=46,pic="icon/icon12/qianggui_key.png",name="墙柜钥匙",appear=true,ifcontain = true,inname="qianggui_key",tishi="墙柜的钥匙。"}
ITEM[47] = {key=47,pic="icon/icon12/hair.png",name="头发",appear=true,ifcontain = true,inname="hair",tishi="一缕洋娃娃的头发……"}
ITEM[48] = {key=48,pic="icon/icon12/taowa.png",name="套娃",appear=true,ifcontain = true,inname="taowa",tishi="小套娃，看上去很像我的洋娃娃。"}
ITEM[49] = {key=49,pic="icon/icon12/door_key.png",name="门钥匙",appear=true,ifcontain = true,inname="door_key",tishi="大门的钥匙。"}
ITEM[50] = {key=50,pic="icon/icon12/doll.png",name="洋娃娃",appear=true,ifcontain = true,inname="doll",tishi="我最喜欢的洋娃娃，大家都说她长得和我一模一样。"}


--GameScene13
ITEM[51] = {key=51,pic="icon/icon13/files_key.png",name="档案柜钥匙",appear=true,ifcontain = true,inname="files_key",tishi="一把钥匙，不知道是哪里的。"}
ITEM[52] = {key=52,pic="icon/icon13/diandiping.png",name="点滴瓶",appear=true,ifcontain = true,inname="diandiping",tishi="一个输液瓶。"}
ITEM[53] = {key=53,pic="icon/icon13/handle.png",name="柜子把手",appear=true,ifcontain = true,inname="handle",tishi="像是个把手。"}
ITEM[54] = {key=54,pic="icon/icon13/table_key.png",name="桌子钥匙",appear=true,ifcontain = true,inname="table_key",tishi="一把小钥匙。"}
ITEM[55] = {key=55,pic="icon/icon13/daoguan.png",name="导管",appear=true,ifcontain = true,inname="daoguan",tishi="一条导管。"}
ITEM[56] = {key=56,pic="icon/icon13/button.png",name="按钮",appear=true,ifcontain = true,inname="button",tishi="似乎是插在哪里的按钮。"}
ITEM[57] = {key=57,pic="icon/icon13/daoping.png",name="导管输液瓶",appear=true,ifcontain = true,inname="daoping",tishi="插上了导管的输液瓶。"}
ITEM[58] = {key=58,pic="icon/icon13/CTphoto.png",name="CT照片",appear=true,ifcontain = true,inname="CTphoto",tishi="一张肺部的CT照片，上边似乎有些什么文字，不过看不太清……"}
ITEM[59] = {key=59,pic="icon/icon13/record_B.png",name="病例_B",appear=true,ifcontain = true,inname="record_B",tishi="病历碎片"}
ITEM[60] = {key=60,pic="icon/icon13/zhenguan.png",name="针管",appear=true,ifcontain = true,inname="zhenguan",tishi="医院里常见的针管，要小心不要被扎到才好。"}
ITEM[61] = {key=61,pic="icon/icon13/shoushudao.png",name="手术剪刀",appear=true,ifcontain = true,inname="shoushudao",tishi="一把手术剪刀。"}
ITEM[62] = {key=62,pic="icon/icon13/cloth.png",name="一块布",appear=true,ifcontain = true,inname="cloth",tishi="看起来吸水性很好的一块布。"}
ITEM[63] = {key=63,pic="icon/icon13/qingjieji.png",name="清洁剂",appear=true,ifcontain = true,inname="qingjieji",tishi="清洁剂"}
ITEM[64] = {key=64,pic="icon/icon13/qingjiebu.png",name="清洁布",appear=true,ifcontain = true,inname="qingjiebu",tishi="蘸有清洁剂的布。"}
ITEM[65] = {key=65,pic="icon/icon13/passpad.png",name="密码板",appear=true,ifcontain = true,inname="passpad",tishi="写有密码的一块板子。"}
ITEM[66] = {key=66,pic="icon/icon13/record_A.png",name="病例_A",appear=true,ifcontain = true,inname="record_A",tishi="病历碎片"}
ITEM[67] = {key=67,pic="icon/icon13/heart.png",name="心脏标本",appear=true,ifcontain = true,inname="cardiac",tishi="装着一颗心脏的标本瓶……"}
ITEM[68] = {key=68,pic="icon/icon13/glass_key.png",name="玻璃柜钥匙",appear=true,ifcontain = true,inname="glass_key",tishi="不知道是哪里的钥匙。"}
ITEM[69] = {key=69,pic="icon/icon13/record_C.png",name="病例_c",appear=true,ifcontain = true,inname="record_C",tishi="病历碎片"}
ITEM[70] = {key=70,pic="icon/icon13/hair_simple.png",name="头发标本",appear=true,ifcontain = true,inname="hair_simple",tishi="装着头发的标本瓶……"}
ITEM[71] = {key=71,pic="icon/icon13/record_D.png",name="病例_D",appear=true,ifcontain = true,inname="record_D",tishi="贴有相片的病历"}
ITEM[72] = {key=72,pic="icon/icon13/binglisuipian.png",name="病理碎片",appear=true,ifcontain = true,inname="binglisuipian",tishi="病例碎片"}
ITEM[73] = {key=73,pic="icon/icon13/glue.png",name="胶水",appear=true,ifcontain = true,inname="glue",tishi="一瓶胶水。"}
ITEM[74] = {key=74,pic="icon/icon13/bingli.png",name="病例",appear=true,ifcontain = true,inname="bingli",tishi="这是我的病历……我……"}
ITEM[75] = {key=75,pic="icon/icon13/guanxue.png",name="一针管血",appear=true,ifcontain = true,inname="guanxue",tishi="抽满了血的针管……"}
ITEM[76] = {key=76,pic="icon/icon13/xuediping.png",name="血滴瓶",appear=true,ifcontain = true,inname="xuediping",tishi="里面灌满了血的输液瓶……看上去好恐怖……"}
ITEM[77] = {key=77,pic="icon/icon13/pliers.png",name="钳子",appear=true,ifcontain = true,inname="pliers",tishi="一把结实的钳子，可以用它来将东西拧下来。"}
ITEM[78] = {key=78,pic="icon/icon13/double.png",name="两个",appear=true,ifcontain = true,inname="double",tishi="两张病历碎片"}
ITEM[79] = {key=79,pic="icon/icon13/trible.png",name="三个",appear=true,ifcontain = true,inname="trible",tishi="三张病历碎片"}
ITEM[80] = {key=80,pic="icon/icon13/xianglian.png",name="项链",appear=true,ifcontain = true,inname="xianglian",tishi="形状很独特的项链，里面装着我的照片。"}


MERGE={}

MERGE[1] = {key=1,id={13,12},nid=11}
MERGE[2] = {key=2,id={3,1},nid=20}
MERGE[3] = {key=3,id={2,10},nid=13}
MERGE[4] = {key=4,id={5,6},nid=7}
--GameScene 12  花
MERGE[5] = {key=5,id={30,31},nid=37}
MERGE[6] = {key=6,id={50,11},nid=47}
MERGE[7] = {key=7,id={31,32},nid=39}
--花环
MERGE[8] = {key=8,id={30,39},nid=40}
MERGE[9] = {key=9,id={31,38},nid=40}
MERGE[10] = {key=10,id={32,37},nid=40}
MERGE[11] = {key=11,id={36,44},nid=45}
MERGE[12] = {key=12,id={30,32},nid=38}

MERGE[13] = {key=13,id={37,38},nid=40}
MERGE[14] = {key=14,id={37,39},nid=40}
MERGE[15] = {key=15,id={38,39},nid=40}

--GamneScne13 
MERGE[16] = {key=16,id={52,55},nid=57}
MERGE[17] = {key=17,id={62,63},nid=64}
MERGE[18] = {key=18,id={72,73},nid=74}
MERGE[19] = {key=19,id={75,57},nid=76}
MERGE[20] = {key=20,id={59,66},nid=78}
MERGE[21] = {key=21,id={59,69},nid=78}
MERGE[22] = {key=22,id={59,71},nid=78}
MERGE[23] = {key=23,id={66,69},nid=78}
MERGE[24] = {key=24,id={66,71},nid=78}
MERGE[25] = {key=25,id={69,71},nid=78}
MERGE[26] = {key=26,id={78,71},nid=79}
MERGE[27] = {key=27,id={78,69},nid=79}
MERGE[28] = {key=28,id={78,66},nid=79}
MERGE[29] = {key=29,id={78,59},nid=79}

MERGE[30] = {key=30,id={79,59},nid=72}
MERGE[31] = {key=31,id={79,66},nid=72}
MERGE[32] = {key=32,id={79,69},nid=72}
MERGE[33] = {key=33,id={79,71},nid=72}



SCENE = {}
SCENE[1] = {}
SCENE[1][1] = {lock = 0,changerolepic = "changerole/11.png"}
SCENE[1][2] = {lock = 1,changerolepic = "changerole/12.png"}
SCENE[1][3] = {lock = 1,changerolepic = "changerole/13.png",face = false}

SCENE[2] = {}
SCENE[2][1] = {lock = 0,changerolepic = "changerole/21.png"}
SCENE[2][2] = {lock = 1,changerolepic = "changerole/22.png",changerolepican = "changerole/an_22.png"}
SCENE[2][3] = {lock = 1,changerolepic = "changerole/23.png",changerolepican = "changerole/an_23.png",face = false}

SCENE[3] = {}
SCENE[3][1] = {lock = 0,changerolepic = "changerole/31.png"}
SCENE[3][2] = {lock = 1,changerolepic = "changerole/32.png",changerolepican = "changerole/an_32.png"}
SCENE[3][3] = {lock = 1,changerolepic = "changerole/33.png",changerolepican = "changerole/an_33.png",face = false}

JXSCENE = {}
JXSCENE[1] = {}
JXSCENE[1][1] = {name = GameScene11,bg="bgroll/gamescene11.png"}
JXSCENE[1][2] = {name = GameScene12,bg="bgroll/gamescene12.jpg"}
JXSCENE[1][3] = {name = GameScene13,bg="bgroll/gamescene13.png"}

JXSCENE[2] = {}
JXSCENE[2][1] = {name = GameScene21,bg="bgroll/gamescene21.png"}
JXSCENE[2][2] = {name = GameScene22,bg="bgroll/gamescene11.png"}
JXSCENE[2][3] = {name = GameScene23,bg="bgroll/gamescene11.png"}

JXSCENE[3] = {}
JXSCENE[3][1] = {name = GameScene31,bg="bgroll/gamescene31.png"}
JXSCENE[3][2] = {name = GameScene32,bg="bgroll/gamescene32.png"}
JXSCENE[3][3] = {name = GameScene33,bg="bgroll/gamescene33.png"}

CHAPTER = {}
CHAPTER[1] = {lock = 0}
CHAPTER[2] = {lock = 1}
CHAPTER[3] = {lock = 1}

-- 保存游戏人物和背景位置

SAVEDATA = {girlpositionx = 480, bgpositionx = 0 }
--新手教程存储
STUDY={study_over= false,touhnum = 1}

CESHI={}
CESHI[1]={a=1}

-- 家具数据存储

FURNITURE = {}
FURNITURE[1] = {inname = "box",bool = true , num = 1}
FURNITURE[2] = {inname = "hammer",bool = true ,num = 1}
FURNITURE[3] = {inname = "toilet_glass",bool = true ,num = 1,ifchangesprite = false}
FURNITURE[4] = {inname = "stool",bool = true ,num = 1}
FURNITURE[5] = {inname = "bear",bool = true ,num = 1,ifchangesprite = false}
FURNITURE[6] = {inname = "bedside_table",bool = true ,num = 1 , ifchangesprite = false}
FURNITURE[7] = {inname = "wardrobe",bool = true ,num = 1,ifchangesprite = false,passpass=false}
FURNITURE[8] = {inname = "cushion",bool = true ,num = 1,ifmoved = false,ifremoved = false}
FURNITURE[9] = {inname = "B_vase",bool = true ,num = 1,ifchangesprite=false}
FURNITURE[10] = {inname = "bookshelf",bool = true ,num = 1}
FURNITURE[11] = {inname = "paperpen",bool = true ,num = 1}
FURNITURE[12] = {inname = "wardrobe_drawer",bool = true ,num = 1,ifchangesprite=false}
FURNITURE[13] = {inname = "liguiframe",bool = true ,num = 1,ifchangesprite=false}
FURNITURE[14] = {inname = "phone",bool = true ,num = 1,redflower = false}
FURNITURE[15] = {inname = "Big_frame",bool = true ,num = 1,ifchangesprite=false,ifbigger=false}
FURNITURE[16] = {inname = "frame_5",bool = true ,num = 1}
FURNITURE[17] = {inname = "wardrobe_top",bool = true ,num = 1}

FURNITURE12 = {}
FURNITURE12[1] = {inname = "",bool = true ,num = 1}
FURNITURE12[2] = {inname = "",bool = true ,num = 1}
FURNITURE12[3] = {inname = "qingjian",bool = true ,num = 1}
FURNITURE12[4] = {inname = "yifu",bool = true ,num = 1}
FURNITURE12[5] = {inname = "dengzhao",bool = true ,num = 1,ifchangesprite=false}
FURNITURE12[6] = {inname = "ligui",bool = true ,num = 1,ifchangesprite=false}
FURNITURE12[7] = {inname = "stove",bool = true ,num = 1}
FURNITURE12[8] = {inname = "statuecat",bool = true ,num = 1,ifchangesprite=false}
FURNITURE12[9] = {inname = "key_up",bool = true ,num = 1}
FURNITURE12[10] = {inname = "qinghua",bool = true ,num = 1}
FURNITURE12[11] = {inname = "zihua",bool = true ,num = 1}
FURNITURE12[12] = {inname = "fenhua",bool = true ,num = 1}
FURNITURE12[13] = {inname = "cat",bool = true ,num = 1,foodhad = false}
FURNITURE12[14] = {inname = "jigui",bool = true ,num = 1,ifchangesprite=false}
FURNITURE12[15] = {inname = "changji",bool = true ,num = 1,ifchangesprite=false}
FURNITURE12[16] = {inname = "handsclock",bool = true ,num = 1}
FURNITURE12[17] = {inname = "biaoshen",bool = true ,num = 1,open = false,putin = false,shi = 0, fen = 0,putname="",door=false}
FURNITURE12[18] = {inname = "flowerpot",bool = true ,num = 1}
FURNITURE12[19] = {inname = "biaopan",bool = true ,num = 1,open = false , zhizhenhad = false}
FURNITURE12[20] = {inname = "weiniang",bool = true ,num = 1,heihua = false}
FURNITURE12[21] = {inname = "built_in",bool = true ,num = 1}

FURNITURE13 = {}
FURNITURE13[1]={iname="yangzhuang",bool = true ,num = 1}
FURNITURE13[2]={iname="tiaokuan",bool = true ,num = 1,xianglian = false,passpad=false}
FURNITURE13[3]={iname="youchouti",bool = true ,num = 1,ifchangesprite = false}
FURNITURE13[4]={iname="gongjuxiang",bool = true ,num = 1,ifchangesprite = false}
FURNITURE13[5]={iname="diandiping",bool = true ,num = 1}
FURNITURE13[6]={iname="tool_car",bool = true,num=1,ifchangesprite=false}
FURNITURE13[7]={iname="dangangui",bool = true,num=1,guimenopen=false}
FURNITURE13[8]={iname="light_screen",bool = true,num=1}
FURNITURE13[9]={iname="first_aid",bool = true,num=1}
FURNITURE13[10]={iname="Curtain_btn",bool = true,num=1,passpad = false}
FURNITURE13[11]={iname="wash_cabinet",bool = true,num=1,appear = false,ifchangesprite = false}

FURNITURE13[12]={iname="screen",bool = true,num=1,use = false,cabinetopen=false}

FURNITURE13[13]={iname="passpad",bool = true,num=1}
FURNITURE13[14]={iname="glass_btn_L",bool = true,num=1}
FURNITURE13[15]={iname="glass_btn_R",bool = true,num=1,weiniang = false,dishui=false}
FURNITURE13[16]={iname="human_model",bool = true,num=1}
FURNITURE13[17]={iname="rack",bool = true,num=1,ifchangesprite = false}

FURNITURE13[18]={iname="screen_cabinet",bool = true,num=1,ifchangesprite = false}
FURNITURE13[19]={iname="tap",bool = true,num=1}
FURNITURE13[20]={iname="operating_table",bool = true,num=1}
FURNITURE13[21]={iname="heiban",bool = true,num=1}




--使用错误物品点击的文本
COMMTALK={"我觉得这样不行。","这个东西应该不是用在这里的吧⋯⋯","看上去好像不能这样做。","还是试试别的东西比较好。","不太合适⋯⋯"}
GAYTALK={"如果你可以给我我想要的，作为交换，说不定我会给你一些有用的东西。","我很喜欢花，你呢？","你的头发真漂亮啊，亮闪闪的金色，真让人羡慕呢。","你要给我什么？"}


























