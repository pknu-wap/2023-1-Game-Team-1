--Properties--



--Methods--

[Client Only]
void OnBeginPlay()
{
	-- 플레이어 활성화
	
	local scale = _UserService.LocalPlayer.TransformComponent.Scale
	scale.x = 1
	scale.y = 1
}


--Events--

