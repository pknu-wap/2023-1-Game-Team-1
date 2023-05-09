--Properties--



--Methods--

[Server Only]
void OnBeginPlay()
{
	local spawn = function()
		_SpawnService:SpawnByModelId("model://db3af4e8-82fe-4f77-b326-9522d127f13a", "WillAttack", Vector3(5, 0.11, 0), self.Entity)
	end
	
	_TimerService:SetTimerRepeat(spawn, 3.0)
}


--Events--

