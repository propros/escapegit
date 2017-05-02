Config = class("Config")

Config.res_lang = "cn"
-- 资源根路径.
Config.RES_ROOT_URL = "res/"..Config.res_lang.."/"
--主界面
Config.RES_MAINSCENE = Config.RES_ROOT_URL.."comm/MainScene.csb"
Config.RES_MESSAGE = Config.RES_ROOT_URL.."message/messagescene.csb"
Config.RES_MESSAGETWO = Config.RES_ROOT_URL.."message/message2scene.csb"
Config.RES_PASSWORD = Config.RES_ROOT_URL.."password/password.csb"
Config.RES_MERGE = Config.RES_ROOT_URL.."merge/merge.csb"
Config.RES_LOADING = Config.RES_ROOT_URL.."Load/Scene.csb"