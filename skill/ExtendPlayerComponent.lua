--Properties--

integer Mp = 0
integer MaxMp = 1000
integer Up = 0
integer MaxUp = 100
number UpChargeRate = 0
number atkSpeed = 1.3


--Methods--

[Server Only]
void OnBeginPlay()
{
	_TimerService:SetTimerRepeat(self.RecoveryMp, 1.5)
}

[Server]
void RecoveryMp()
{
	if self.Mp < self.MaxMp then
		self.Mp = self.Mp + self.MaxMp * 0.1
	end
	
	if self.Mp > self.MaxMp then 
		self.Mp = self.MaxMp
	end
}

[Server]
void MpConsume(integer amount)
{
	self.Mp = self.Mp - amount
}


--Events--

