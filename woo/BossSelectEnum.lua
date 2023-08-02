--Properties--

string Can = "6483c6ae1c6f4ef387f3810dbee33fdb"
string Cant = "99fcecac54a04726881161c7a59b8699"
integer Left = 1
integer Right = 2
integer Easy = 1
integer Normal = 2
integer Hard = 3
string Grade = "grade"
string Name = "name"
string Img = "img"
string BattlePointLow = "battlePointLow"
string BattlePoint = "battlePoint"
string Reward = "reward"
string ClearCount = "clearCount"
table difficultText
table difficultColor
Entity boss1
Entity boss2
Entity boss3
Entity boss4
Entity boss5
Entity boss6
Entity boss7
Component bossGrade
Component bossName
Component bossBattlePoint
Component bossReward
Component bossClearCount


--Methods--

[Default]
void SetNull()
{
	self.boss1 = nil
	self.boss2 = nil
	self.boss3 = nil
	self.boss4 = nil
	self.boss5 = nil
	self.boss6 = nil
	self.boss7 = nil
	
	self.bossGrade = nil
	self.bossName = nil
	self.bossBattlePoint = nil
	self.bossReward = nil
}


--Events--

