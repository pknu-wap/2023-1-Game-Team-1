--Properties--

Component message
Component btnOk
Component btnCancel
Entity popupGroup
Entity popup
any onOk = nil
any onCancel = nil
number duration = 0.15
number from = 0.5
number to = 1
boolean isOpen = false
boolean isTweenPlaying = false
number tweenEventId = 0
any okHandler = nil
any cancelHandler = nil


--Methods--

[Default]
void Open(string message, any onOk, any onCancel)
{
	if self.isOpen == true then
		return
	end
	self.isOpen = true
	self.popupGroup.Enable = true
	self.message.Text = message
	self.onOk = onOk
	self.onCancel = onCancel
	
	
	self.okHandler = self.btnOk.Entity:ConnectEvent(ButtonClickEvent,self.OnClickOk)
	self.cancelHandler = self.btnCancel.Entity:ConnectEvent(ButtonClickEvent,self.OnClickCancel)
	self:StartTween(true)
}

[Default]
void OnClickOk()
{
	if self.isTweenPlaying == true then
		return
	end
	if self.onOk ~= nil then
		self.onOk()
		self.onOk = nil
	end
	self:Close()
}

[Default]
void OnClickCancel()
{
	if self.isTweenPlaying == true then
		return
	end
	if self.onCancel ~= nil then
		self.onCancel()
		self.onCancel = nil
	end
	self:Close()
}

[Default]
void Close()
{
	self.btnOk.Entity:DisconnectEvent(ButtonClickEvent,self.okHandler)
	self.btnCancel.Entity:DisconnectEvent(ButtonClickEvent,self.cancelHandler)
	self:StartTween(false)
}

[Default]
void StartTween(boolean open)
{
	
	local transform = self.popup.UITransformComponent
	local canvasGroup = self.popupGroup.CanvasGroupComponent 
	if open == true then
		canvasGroup.GroupAlpha = 0
		transform.UIScale = Vector3(self.from,self.from,1)
	else
		transform.UIScale = Vector3(self.to,self.to,1)
	end
	self.isTweenPlaying = true
	local time = 0
	
	
	local preTime = _UtilLogic.ElapsedSeconds
	
	local tween = function()
		local delta = _UtilLogic.ElapsedSeconds - preTime
		time = time + delta
		local timeValue = time	
		preTime = _UtilLogic.ElapsedSeconds
	
		if time >= self.duration then
			timeValue = self.duration
			if open == false then
				self.popupGroup.Enable = false
				self.isOpen = false
			end
			self.isTweenPlaying = false
			_TimerService:ClearTimer(self.tweenEventId)
	
		end
		if open == false then
			timeValue = self.duration - timeValue
		end
		local tweenValue = _TweenLogic:Ease(self.from, self.to, 
			self.duration, EaseType.SineEaseIn, timeValue)
		transform.UIScale = Vector3(tweenValue,tweenValue,1)
		canvasGroup.GroupAlpha = timeValue / self.duration
	end
	self.tweenEventId = _TimerService:SetTimerRepeat(tween,1/60)
	
}


--Events--

