--Properties--

number ImmuneCooldown = 1
number LastHitTime = 0
boolean isCounter = false


--Methods--

[Default]
boolean IsHitTarget(string attackInfo)
{
	local currentTime = _UtilLogic.ElapsedSeconds
	if self.LastHitTime + self.ImmuneCooldown < currentTime then
		self.LastHitTime = _UtilLogic.ElapsedSeconds
		return true
	end
	
	return false
}

[Default]
void OnHit(Entity attacker, integer damage, boolean isCritical, string attackInfo, int32 hitCount)
{
	if self.isCounter then
		damage = 0
		attackInfo = "Counter"
		self.isCounter = false
	end
	__base:OnHit(attacker,damage,isCritical,attackInfo,hitCount)
}

[Server]
void Counter(number sec)
{
	self.isCounter = true
	_TimerService:SetTimerOnce(function() self.isCounter = false end, sec)
}


--Events--

