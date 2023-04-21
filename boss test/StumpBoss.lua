--Properties--

number test = 2
number speed = 0.5


--Methods--

[Server Only]
void OnBeginPlay()
{
	__base:OnBeginPlay()
	self.stateComponent:AddState("Chase")
	self.stateComponent:AddState("ATTACK1")
	self.stateComponent:AddState("ATTACK2")
	self.stateComponent:AddState("ATTACK3")
	self.Entity.MovementComponent.InputSpeed = self.speed
	
}

[Server Only]
void SetIdle()
{
	self.stateComponent:ChangeState("IDLE")
}


--Events--

[Default]
HandleStump_Pattern_Event(Stump_Pattern_Event event)
{
	-- Parameters
	local PtNo = event.PtNo
	---------------------------------------------------------
	log("스텀프 패턴 이벤트 발생 "..PtNo)
	
	if PtNo >= 0 and PtNo <= 4 then
		self.stateComponent:ChangeState("ATTACK1")
	elseif PtNo >= 5 and PtNo <= 7 then
		self.stateComponent:ChangeState("ATTACK2")
	elseif PtNo >= 8 and PtNo <= 9 then
		self.stateComponent:ChangeState("ATTACK3")
	end
	
	function SetIdle ()
		self.stateComponent:ChangeState("IDLE")
	end
	
	_TimerService:SetTimerOnce(SetIdle, 3)
}

[Default]
HandleStateChangeEvent(StateChangeEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: StateComponent
	-- Space: Server, Client
	---------------------------------------------------------
	
	-- Parameters
	local CurrentStateName = event.CurrentStateName
	local PrevStateName = event.PrevStateName
	---------------------------------------------------------
	log("보스 상태 변경 "..PrevStateName .."에서 " ..CurrentStateName)
}

