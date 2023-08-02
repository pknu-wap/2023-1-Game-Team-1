--Properties--

integer Mp = 0
integer MaxMp = 1000
integer Up = 0
integer MaxUp = 100
number UpChargeSpeed = 0
number atkSpeed = 1.0
number atkPoint = 25


--Methods--

[Server Only]
void OnBeginPlay()
{
	_TimerService:SetTimerRepeat(self.SelfRecoverMp, 1.5)
}

[Server]
void SelfRecoverMp()
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

[Server]
void UpConsume(integer amount)
{
	self.Up = self.Up - amount
}

[Server]
void UpCharge(integer amount)
{
	if self.Up + amount > self.MaxUp then
		self.Up = self.MaxUp
	else
		self.Up = self.Up + amount
	end
}

[Server]
void RecoverHp(integer amount)
{
	if self.Hp + amount > self.MaxHp then
		self.Hp = self.MaxHp
	else
		self.Hp = self.Hp + amount
	end
}

[Server]
void UpdateAtkPoint(number atk)
{
	log(atk)
	self.atkPoint = atk/10
}

[Server Only]
void OnMapEnter(Entity enteredMap)
{
	local db = _DataStorageService:GetUserDataStorage(self.Entity.Name)
	local _, atk = db:GetAndWait("Atk")
	if atk == nil then
		atk = 100;
		log("unknown atk")
	end
	self.atkPoint = tonumber(atk)/10
}

[Default]
void Respawn()
{
	__base:Respawn()
	self.Entity.HitComponent.Enable = false
	_TimerService:SetTimerOnce(function() self.Entity.HitComponent.Enable = true end, 3.0)
}


--Events--

