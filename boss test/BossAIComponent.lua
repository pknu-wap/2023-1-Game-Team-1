--Properties--

Entity target
string map = ""
Component BossComponent
array<Entity> player
number detectDistance = 4
any ATK = nil


--Methods--

[Server Only]
void OnBeginPlay()
{
	--log("root node를 설정")
	self.map = self.Entity.CurrentMap.Name
	--log("map : " ..self.map)
	--self:GetPlayer()
	
	self.BossComponent = self.Entity.Boss
	
	if isvalid(self.BossComponent) then
			log("보스 컴포넌트 확인")
	end
	
	local root = SequenceNode()	
	
	local repeater = SelectorNode()
	
	local Seq = SequenceNode()
	
	local Succeeder = Checker()
	--Succeeder.player = self.player
	Succeeder.BossAIComponent = self.Entity.BossAIComponent
	
	local CA = CanAttack()
	--CA.player = self.player
	CA.BossAIComponent = self.Entity.BossAIComponent
	
	local Chase = ChaseTarget()
	Chase.ExclusiveExecutionWhenRunning = true
	--Chase.player = self.player
	Chase.BossAIComponent = self.Entity.BossAIComponent
	
	self.ATK = RandomSelectorNode()
	local atk = RandomSelectorNode()
	
	if self.ATK ~= nil then
		--log("ATK 잘들어가있듬")
	end
	
	--[[
	local Pt = {}
	
	if  self.Entity.TagComponent.Tags[2] == "Stump" then
		log("스텀프 패턴 로드???")
		for i = 0,9 do
			Pt[i] = Stump_Pattern()
			Pt[i].PtNo = i
			self.ATK:AttachChild(Pt[i])
			self.ATK:SetChildNodeProbability(Pt[i], 0.15)
		end
	elseif self.Entity.TagComponent.Tags[2] == "Golem" then
		log("골렘 패턴 로드")
		for i = 0,9 do
			Pt[i] = Golem_Pattern()
			Pt[i].PtNo = i
			self.ATK:AttachChild(Pt[i])
			self.ATK:SetChildNodeProbability(Pt[i], 0.15)
		end
	elseif self.Entity.TagComponent.Tags[2] == "KnightStatue" then
		log("기사석상 패턴 로드")
		for i = 0,9 do
			Pt[i] = KnightStatue_Pattern()
			Pt[i].PtNo = i
			self.ATK:AttachChild(Pt[i])
			self.ATK:SetChildNodeProbability(Pt[i], 0.15)
		end
	end
	]]	
	local Pt = Pattern()
	atk:AttachChild(Pt, 1)
	
	local Attacking = Attacking()
	Attacking.BossAIComponent = self.Entity.BossAIComponent
	
	Seq:AttachChild(CA)
	Seq:AttachChild(Chase)
	--Seq:AttachChild(self.ATK)
	Seq:AttachChild(atk)
	Seq:AttachChild(Attacking)
	
	repeater:AttachChild(Seq)
	repeater:AttachChild(Succeeder)
	
	root:AttachChild(repeater)
	
	self:SetRootNode(root)
	
	self:GetPlayer()
}

[Server]
void GetPlayer()
{
	--log("GetPlayer 실행")
	
	local playersArr = _UserService:GetUsersByMapName(self.Entity.CurrentMap.Name)
	--log("GetPlayer 찾는중")
	for i, p in pairs(playersArr) do
		self.player[i] = p
		log(i.."번째의 player " .. self.player[i].Name)
	end
	
	self:SetPlayer()
}

[Server]
void SetPlayer()
{
	local dist
	
	if isvalid(self.target) then
		dist = Vector2.Distance(self.target.TransformComponent.Position:ToVector2(), self.Entity.TransformComponent.Position:ToVector2())
	else
		dist = math.maxinteger
		log("타겟 재설정")
	end
	
	local playersArr = _UserService:GetUsersByMapName(self.Entity.CurrentMap.Name)
	
	--og("어디서 오류 ? 1")
	for i, p in pairs(playersArr) do
		--log("어디서 오류 ? 2")
		if self.target == nil then
			--log("어디서 오류 ? 3")
			self.target = p
		else
			if isvalid(p) and self.target.StateComponent.CurrentStateName ~= "DEAD" then
				--log("어디서 오류 ? 4")
				if p == self.target then
					log("같은 타겟입니다! 스킵합니다." ..p.Name .." , " ..self.target.Name)
					goto skip_set_target
				end
				
				local distTemp = Vector2.Distance(p.TransformComponent.Position:ToVector2(), self.Entity.TransformComponent.Position:ToVector2())
				
				if self.target.StateComponent.CurrentStateName == "DEAD" or distTemp < dist then
					dist = distTemp
					self.target = p
				end
				
				::skip_set_target::
			end
		end
		
	end
}

[Default]
void RemovePlayer(string UserId)
{
	for i, p in pairs(self.player) do
		if self.player[i].Name == UserId then
			table.remove(self.player, i)
		end
	end
}


--Events--

