--Properties--

Entity modalWindow
Entity modal
Entity loading
Component loadingZ
Component title
Component message
Entity exitButton
Entity gaugeBox
Component gaugeBoxIcon
Entity gaugeBar
Entity msgBox
Component msgBoxIcon
Entity msgBoxOKButton
Entity msgBoxYesButton
Entity msgBoxNoButton
Entity effect


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.exitButton:ConnectEvent(ButtonClickEvent, function() self:CloseModal() end)
}

[Client]
void OpenGaugeBox(string title, string message, boolean exitButton, string RUID)
{
	self.title.Text = title
	self.message.Text = message
	
	if exitButton == nil then exitButton = true end
	self.exitButton:SetEnable(exitButton)
	
	if RUID == nil then RUID = "144b5e28f1d64ed19541d63d57bb2e34" end
	self.gaugeBoxIcon.ImageRUID = RUID
	
	self.gaugeBox:SetEnable(true)
	self.modalWindow:SetEnable(true)
}

[Client]
void OpenMsgBox(string title, string message, integer buttonType, boolean exitButton, string RUID)
{
	self.title.Text = title
	self.message.Text = message
	
	self.msgBoxOKButton:SetEnable(false)
	self.msgBoxYesButton:SetEnable(false)
	self.msgBoxNoButton:SetEnable(false)
	
	if buttonType == _ModalEnum.MsgBoxOK then
		self.msgBoxOKButton:SetEnable(true)
	elseif buttonType == _ModalEnum.MsgBoxYN then
		self.msgBoxYesButton:SetEnable(true)
		self.msgBoxNoButton:SetEnable(true)
	end
	
	if exitButton == nil then exitButton = true end
	self.exitButton:SetEnable(exitButton)
	
	if RUID == nil then RUID = "fcae6b52354faad4484a9d0c3c6eb72f" end
	self.msgBoxIcon.ImageRUID = RUID
	
	self.msgBox:SetEnable(true)
	self.modalWindow:SetEnable(true)
}

[Client]
void CloseModal()
{
	self:SetGauge(10)
	self.gaugeBox:SetEnable(false)
	self.msgBoxYesButton:SetEnable(false)
	self.msgBoxNoButton:SetEnable(false)
	self.msgBoxOKButton:SetEnable(false)
	self.msgBox:SetEnable(false)
	self.effect:SetEnable(false)
	self.modal:SetEnable(false)
	self.modalWindow:SetEnable(false)
}

[Client]
void SetGauge(integer value)
{
	local width = 500 * value * 0.01
	local posX = -250 + width / 2
	self.gaugeBar.UITransformComponent.RectSize = Vector2(width, 70)
	self.gaugeBar.UITransformComponent.Position.x = posX
}

[Client]
void LoadingOn()
{
	self.modalWindow:SetEnable(true)
	self.loading:SetEnable(true)
}

[Client]
void LoadingOff()
{
	self.loadingZ.ZRotation = 0
	self.loading:SetEnable(false)
	self.modalWindow:SetEnable(false)
}


--Events--

