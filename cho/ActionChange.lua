--Properties--



--Methods--

[Server]
void SendToServer(Entity player, ActionStateChangedEvent e)
{
	self:SendToClients(player, e)
}

[Client]
void SendToClients(Entity player, ActionStateChangedEvent e)
{
	local body = player.AvatarRendererComponent:GetBodyEntity()
	body:SendEvent(e)
}


--Events--

