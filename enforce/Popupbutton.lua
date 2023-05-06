--Properties--



--Methods--


--Events--

[Client Only]
HandleButtonClickEvent(ButtonClickEvent event)
{
	-- Parameters
	local Entity = event.Entity
	--------------------------------------------------------
	--MenuButton
	
	local panel=_EntityService:GetEntityByPath("/ui/ButtonGroup/Menu_Panel")
	
	if panel.Enable==false then
		panel.Enable=true
	else
		panel.Enable=false
	end
}

[Client Only]
HandleButtonClickEvent2(ButtonClickEvent event)
{
	-- Parameters
	local Entity = event.Entity
	--------------------------------------------------------
	--BasicPopup
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/BasicPopup")
	panel.Enable=true
	
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/BasicPopup/Panel/OKButton")
	
	local cancel=function()
		panel.Enable=false
	end
	
	cancelbutton:ConnectEvent(ButtonClickEvent,cancel)
}

[Client Only]
HandleButtonClickEvent3(ButtonClickEvent event)
{
	-- Parameters
	local Entity = event.Entity
	--------------------------------------------------------"
	--TabPopup
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/TabPopup")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/TabPopup/Panel/TitlePanel/ExitButton")
	
	local cancel=function()
		panel.Enable=false
	end
	
	cancelbutton:ConnectEvent(ButtonClickEvent,cancel)
}

[Client Only]
HandleButtonClickEvent4(ButtonClickEvent event)
{
	-- Parameters
	local Entity = event.Entity
	--------------------------------------------------------
	--AchievementPopup
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/AchievementPopup")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/AchievementPopup/Panel/TitlePanel/ExitButton")
	
	local cancel=function()
		panel.Enable=false
	end
	
	cancelbutton:ConnectEvent(ButtonClickEvent,cancel)
}

[Client Only]
HandleButtonClickEvent5(ButtonClickEvent event)
{
	-- Parameters
	local Entity = event.Entity
	--------------------------------------------------------
	--InventoryPopup
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/InventoryPopup")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/InventoryPopup/Panel/TitlePanel/ExitButton")
	
	local cancel=function()
		panel.Enable=false
	end
	
	cancelbutton:ConnectEvent(ButtonClickEvent,cancel)
}

[Client Only]
HandleButtonClickEvent6(ButtonClickEvent event)
{
	-- Parameters
	local Entity = event.Entity
	--------------------------------------------------------
	--DailyRewardPopup
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/DailyRewardPopup")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/DailyRewardPopup/Panel/TitlePanel/ExitButton")
	
	local cancel=function()
		panel.Enable=false
	end
	
	cancelbutton:ConnectEvent(ButtonClickEvent,cancel)
}

[Client Only]
HandleButtonClickEvent7(ButtonClickEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: ButtonComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local Entity = event.Entity
	---------------------------------------------------------
	
	--ShopPopup
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/ShopPopup")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/ShopPopup/Panel/TitlePanel/ExitButton")
	
	local cancel=function()
		panel.Enable=false
	end
	
	cancelbutton:ConnectEvent(ButtonClickEvent,cancel)
	
}

[Client Only]
HandleButtonClickEvent8(ButtonClickEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: ButtonComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local Entity = event.Entity
	---------------------------------------------------------
	
	--Shop_DetailInfoPopup
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/Shop_DetailInfoPopup")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/Shop_DetailInfoPopup/DetailInfoPopup/Panel/ExitButton")
	
	local cancel=function()
		panel.Enable=false
	end
	
	cancelbutton:ConnectEvent(ButtonClickEvent,cancel)
	
}

