--Properties--

number MaxHp = 100
number Hp = 0
boolean IsDead = false
number speed = 0.5
number detectDistance = 0
number DestroyDelay = 0.6
Component stateComponent
Component stateAnimationComponent
Component BossMovementComponent
Component BossAIComponent
Component BossTransformComponent
Entity map
boolean attackEnd = true
boolean InRange = false
Component SpriteComponent
number BossLevel = 1
boolean LastPhase = false
boolean isHide = true
number sheild = 0


--Methods--

[Server Only]
void OnBeginPlay()
{
	self.Hp = self.MaxHp
	self.stateAnimationComponent = self.Entity.StateAnimationComponent
	self.stateComponent = self.Entity.StateComponent
	self.BossMovementComponent = self.Entity.MovementComponent
	self.BossAIComponent = self.Entity.BossAIComponent
	self.BossTransformComponent = self.Entity.TransformComponent
	self.SpriteComponent = self.Entity.SpriteRendererComponent
	self.attackEnd = true
	self.stateComponent:RemoveState("HIT")
	
	if _RoomService:IsInstanceRoom() then
		log("현재 인스턴스룸입니다!")
	else
		log("인스턴스룸이 아닙니다")
	end
	
	--log("현재 체력 " ..self.Hp)
}

[Server Only]
void Dead()
{
	self.IsDead = true
	
	if self.stateComponent then
		self.stateComponent:ChangeState("DEAD")
		--log("죽음")
	end
	
	if self.isHide == true then
		self.Entity:SetVisible(false)
		_TimerService:SetTimerOnce(function() self.Entity:SetEnable(false) end, self.DestroyDelay)
	end
	
	if self.LastPhase == true then
		local delayHide = function()
			self.Entity:Destroy()
			
			local users = {}
	        -- 현재 룸에 존재하는 플레이어들을 가져옵니다.
	        for k, v in pairs(_UserService.UserEntities) do
	            users[#users+1] = v.Name
	        end
			log("맵 이동합니다" .._RoomService.StaticRoomKey)
			_RoomService:MoveUsersToStaticRoom(users, "Town")
		end
		
		_TimerService:SetTimerOnce(delayHide, 1)
	end
}

[Server Only]
void OnUpdate(number delta)
{
	--log("보스 현재 스테이트 상태 : " ..self.stateComponent.CurrentStateName)
}


--Events--

[Default]
HandleHitEvent(HitEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: HitComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local AttackCenter = event.AttackCenter
	local AttackerEntity = event.AttackerEntity
	local Damages = event.Damages
	local Extra = event.Extra
	local FeedbackAction = event.FeedbackAction
	local IsCritical = event.IsCritical
	local TotalDamage = event.TotalDamage
	---------------------------------------------------------
	if self:IsClient() then return end
	
	local originalHp = self.Hp
	
	self.Hp = self.Hp - TotalDamage
	
	if self.Hp > 0 or originalHp <= 0 then
		--self:Hit()
		return
	end
	
	self:Dead()
}

