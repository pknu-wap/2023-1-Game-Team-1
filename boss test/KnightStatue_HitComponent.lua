--Properties--

Component attackComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.attackComponent = self.Entity.KnightStatue_Attack
}

[Default]
void OnHit(Entity attacker, integer damage, boolean isCritical, string attackInfo, int32 hitCount)
{
	if self.attackComponent.godMode == true then
		damage = 1
	end
	--log("이름 " ..attacker.Name .." " ..attackInfo)
	__base:OnHit(attacker,damage,isCritical,attackInfo,hitCount)
}


--Events--

