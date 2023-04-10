--Properties--



--Methods--


--Events--

[Client Only]
HandleButtonClickEvent(ButtonClickEvent event)
{
	-- Parameters
	local Entity = event.Entity
	--------------------------------------------------------
	if Entity.Name~="1" then return end
	--AchieveUI
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/AchieveUI")
	
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/AchieveUI/TitlePanel/ExitButton")
	
	local cancel=function()
		panel.Enable=false
	end
	
	cancelbutton:ConnectEvent(ButtonClickEvent,cancel)
}

[Client Only]
HandleButtonClickEvent2(ButtonClickEvent event)
{
	-- Parameters
	local Entity = event.Entity
	--------------------------------------------------------
	if Entity.Name~="2" then return end
	--MonsterDexUI
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/MonsterDexUI")
	panel.Enable=true
	
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/MonsterDexUI/TitlePanel/ExitButton")
	
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
	--------------------------------------------------------
	if Entity.Name~="3" then return end
	--QuestUI"
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/QuestUI")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/QuestUI/QuestUITitle/ExitButton")
	
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
	if Entity.Name~="4" then return end
	--InventoryUI
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/InventoryUI")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/InventoryUI/TopPanel/ExitButton")
	
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
	if Entity.Name~="5" then return end
	--BasicPopup
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/ShopUI")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/ShopUI/TopPanel/ExitButton")
	
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
	if Entity.Name~="6" then return end
	--BasicPopup
	
	local panel=_EntityService:GetEntityByPath("/ui/PopupGroup/BasicPopup")
	panel.Enable=true
	
	local cancelbutton=_EntityService:GetEntityByPath("/ui/PopupGroup/BasicPopup/PopupBtnOK")
	local cancelbutton2=_EntityService:GetEntityByPath("/ui/PopupGroup/BasicPopup/PopupBtnCancel")
	
	local cancel=function()
		panel.Enable=false
	end
	
	cancelbutton:ConnectEvent(ButtonClickEvent,cancel)
	cancelbutton2:ConnectEvent(ButtonClickEvent,cancel)
}

