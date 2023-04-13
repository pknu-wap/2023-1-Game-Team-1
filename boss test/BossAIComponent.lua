--Properties--

Entity target
string map = ""
Component BossComponent
array<Entity> player
number detectDistance = 4


--Methods--

[Server Only]
void OnBeginPlay()
{
	log("root node를 설정")
	self.map = self.Entity.CurrentMap.Name
	log("map : " ..self.map)
	--self:GetPlayer()
	
	self.BossComponent = self.Entity.Boss
	
	local root = SequenceNode()	
	
	local repeater = SelectorNode()
	
	local Seq = SequenceNode()
	
	local Succeeder = Checker()
	--Succeeder.player = self.player
	Succeeder.BossAiComponent = self.Entity.BossAIComponent
	
	local CA = CanAttack()
	--CA.player = self.player
	CA.BossAIComponent = self.Entity.BossAIComponent
	
	local Chase = ChaseTarget()
	Chase.ExclusiveExecutionWhenRunning = true
	--Chase.player = self.player
	Chase.BossAIComponent = self.Entity.BossAIComponent
	
	local ATK = RandomSelectorNode()
	
	local Pt = {}
	for i = 0,9 do
		Pt[i] = Stump_Pattern()
		Pt[i].PtNo = i
		ATK:AttachChild(Pt[i])
		ATK:SetChildNodeProbability(Pt[i], 0.15)
	end
	
	Seq:AttachChild(CA)
	Seq:AttachChild(Chase)
	Seq:AttachChild(ATK)
	
	repeater:AttachChild(Seq)
	repeater:AttachChild(Succeeder)
	
	root:AttachChild(repeater)
	
	self:SetRootNode(root)
}

[Server]
void GetPlayer()
{
	log("GetPlayer 실행")
	
	local playersArr = _UserService:GetUsersByMapName(self.Entity.CurrentMap.Name)
	log("GetPlayer 찾는중")
	for i, p in pairs(playersArr) do
		self.player[i] = p
		log(i.."번째" .. p.Name)
		log(i.."번째의 player " .. self.player[i].Name)
	end
	
	--self:SetPlayer()
}

[Server]
void SetPlayer()
{
	local dist
	
	if self.target == nil then
		dist = math.maxinteger
	else
		dist = Vector2.Distance(self.target.TransformComponent.Position:ToVector2(), self.Entity.TransformComponent.Position:ToVector2())
	end
	
	--og("어디서 오류 ? 1")
	for i, p in pairs(self.player) do
		--log("어디서 오류 ? 2")
		if self.target == nil then
			--log("어디서 오류 ? 3")
			self.target = p
		else
			if isvalid(p) then
				--log("어디서 오류 ? 4")
				if p == self.target then
					log("같은 타겟입니다! 스킵합니다.")
					goto skip_set_target
				end
				
				local distTemp = Vector2.Distance(p.TransformComponent.Position:ToVector2(), self.Entity.TransformComponent.Position:ToVector2())
				
				if dist < distTemp then
					goto skip_set_target
				end
				
				dist = math.min(dist, distTemp)
				
				if dist <= self.detectDistance then
					self.target = p
					log("타겟 설정 " ..self.target.Name)
				end
				
				::skip_set_target::
			end
		end
		
	end
	
	if self.target ~= nil then
		CanAttack().target = self.target
	end
}


--Events--

