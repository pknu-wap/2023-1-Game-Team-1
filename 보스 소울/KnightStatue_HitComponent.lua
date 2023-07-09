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
		_SoundService:PlaySound("e1dacc286f764f13bc578bcdb2d1ec1e", 1, attacker)
		damage = 1
	end
	--log("이름 " ..attacker.Name .." " ..attackInfo)
	__base:OnHit(attacker,damage,isCritical,attackInfo,hitCount)
}


--Events--

