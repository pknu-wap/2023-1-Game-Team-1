--Properties--

integer TapEnforce = 1
integer TapScroll = 2
integer TapEnchant = 3
integer TapSuccession = 4
integer TapNumber = 4
integer ResourceMax = 6
Color Black = Color.FromHexCode("#000000")
Color Blue = Color.FromHexCode("#313bcc")
Color Red = Color.FromHexCode("#d63c3c")
Color green = Color.FromHexCode("#139e6b")
Color Violet = Color.FromHexCode("#a03cd6")
Color Orange = Color.FromHexCode("#e8b431")
Color White = Color.FromHexCode("#ffffff")
integer TapLeft = 1
integer TapCenter = 2
integer TapLoading = 3
integer LeftInfo = 1
integer LeftSelect = 2
integer CenterEnforce = 1
integer CenterScroll = 2
integer CenterEnchant = 3
integer CenterSuccession = 4
integer LoadingGauge = 1
integer LoadingMsgBoxOK = 2
integer LoadingMsgBoxYN = 3
integer Item = 1
integer Info = 2
integer SelectedEquipment = 1
integer TargetEquipment = 2
integer SelectedAtk = 1
integer SelectedEnforce = 2
integer TargetAtk = 3
integer TargetEnforce = 4
integer LoadingBox = 1
integer MsgOkBox = 2
integer MsgYNBox = 3
table grade
table SpriteEnhanceButton
table ResourceIcons
table ConsumeDataSetKeys
table EquipmentInfos
dictionary<string, string> EquipmentInfoStats


--Methods--

[Client]
void Init()
{
	self.ResourceIcons = {
		"051f6aaf87494b07a091ee63257b89b8",
		"80d1219edc2d4bc8b1c38b79561509a4",
		"f1444a719b4044049b42ea97f4dbf128",
		"0806f6c6ce0b4bc78f06d300d9314a08",
		"926e73e429754eff9ec848833ab679a1",
		"cb9d4b4e4d644b9789fc418b33e5817a"
		}
	
	self.SpriteEnhanceButton = {
		"1cea3e2766414a3c923e10aee2fa4cea",
		"803886e2c1814e8fa677cdb6cd508610"
		}
	
	self.EquipmentInfoStats["grade"] = "등급"
	self.EquipmentInfoStats["enforce"] = "재련"
	self.EquipmentInfoStats["enforceAtk"] = "재련 공격력"
	self.EquipmentInfoStats["baseAtkPoint"] = "기본 공격력"
	self.EquipmentInfoStats["finalAtkPoint"] = "최종 공격력"
	self.EquipmentInfoStats["scrollAtk"] = "스크롤 공격력"
	
	self.EquipmentInfos = {
		"grade",
		"enforce",
		"enforceAtk",
		"scrollAtk",
		"baseAtkPoint",
		"finalAtkPoint"
		}
	
	self.grade = {
		"★",
		"★★",
		"★★★",
		"★★★★",
		"★★★★★",
		"★★★★★★"
		}
	
	self.ConsumeDataSetKeys = {
		"code",
		"name",
		"img",
		"type",
		"typeId",
		"description"
		}
	
	
	_EnhanceClient:Init()
	_EnhanceTapHandler:Init()
}


--Events--

