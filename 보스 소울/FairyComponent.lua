--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	local protection = self.Entity:GetChildByName("SpiritProtection")
	protection.Enable = false
	
	_TimerService:SetTimerOnce(function() protection.Enable = true end, 5.0)
	_TimerService:SetTimerOnce(function() self.Entity:Destroy() end, 6.2)
}


--Events--

