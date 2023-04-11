--Properties--

Entity player
string map = ""
Component BossComponent


--Methods--

[Server Only]
void OnBeginPlay()
{
	log("root node를 설정")
	self.map = _EntityService:GetEntityByPath("/maps/map01").Name
	log("map : " ..self.map)
	
	self.BossComponent = self.Entity.Boss
	
	local root = SequenceNode()	
	
	local repeater = SelectorNode()
	
	local Seq = SequenceNode()
	local Succeeder = Checker()
	Succeeder.player = self.player
	
	local CA = CanAttack()
	CA.player = self.player
	local Chase = ChaseTarget()
	Chase.player = self.player
	
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
void SetPlayer()
{
	
	log("SetPlayer : map " ..self.map)
	local playersArr = _UserService:GetUsersByMapName(self.map)
	for i, p in pairs(playersArr) do
		local dir = p.TransformComponent.Position - self.
		
		if self.player == nil or p.TransformComponent
		self.player = p
		log("PlayerName : CurrentMap = "..p.Name.." : "..p.CurrentMap.Name)
	end
}


--Events--

