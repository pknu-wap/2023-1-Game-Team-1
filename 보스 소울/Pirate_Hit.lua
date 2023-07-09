--Properties--

Component attackComponent
Component bossComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.attackComponent = self.Entity.Pirate_Attack
	self.bossComponent = self.Entity.Boss
}

[Default]
void OnHit(Entity attacker, integer damage, boolean isCritical, string attackInfo, int32 hitCount)
{
	if self.attackComponent.attackName == "Nautilus" then
		damage = damage / 2
		--self.Hp = self.Hp + damage
		self.attackComponent.shield = self.attackComponent.shield - damage
		self.bossComponent.Hp = self.bossComponent.Hp + damage
	
	end
	
	__base:OnHit(attacker,damage,isCritical,attackInfo,hitCount)
	if self.bossComponent.Hp <= 0 and self.attackComponent.phaseNum == 1 then --and self.attackComponent.phaseNum == 1 then
		self.attackComponent:Phase2State()
	elseif self.bossComponent.Hp <= 0 and self.attackComponent.phaseNum == 2 then
		self.attackComponent:Phase3State()
	end
	
}


--Events--

