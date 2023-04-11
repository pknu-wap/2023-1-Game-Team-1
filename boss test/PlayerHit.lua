--Properties--

number ImmuneCooldown = 1
number LastHitTime = 0


--Methods--

[Default]
boolean IsHitTarget()
{
	local currentTime = _UtilLogic.ElapsedSeconds
	if self.LastHitTime + self.ImmuneCooldown < currentTime then
		self.LastHitTime = _UtilLogic.ElapsedSeconds
		return true
	end
	
	return false
}


--Events--

