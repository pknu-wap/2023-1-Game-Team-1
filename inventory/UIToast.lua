--Properties--

Component message
Entity toastGroup
number duration = 2
number tweenDuration = 0.1
number tweenEventId = 0
boolean isTweenPlaying = false
boolean inited = false
number offset = 0


--Methods--

[Client]
void ShowMessage(string message)
{
	if self.inited == false then
		self.inited = true
		self.offset = -self.message.Entity.UITransformComponent.anchoredPosition.y
	end
	self.message.Text = message
	self:StartTween()
}

[Default]
void StartTween()
{
	local canvasGroup = self.message.Entity.CanvasGroupComponent
	local transform = self.message.Entity.UITransformComponent
	if self.tweenEventId > 0 then
		_TimerService:ClearTimer(self.tweenEventId)
		self.tweenEventId = 0
	else
		canvasGroup.GroupAlpha = 0
	end
	self.toastGroup.Enable = true
	local time = 0
	
	local preTime = _UtilLogic.ElapsedSeconds
	
	local tween = function()
		local delta = _UtilLogic.ElapsedSeconds - preTime
		time = time + delta
		preTime = _UtilLogic.ElapsedSeconds
	
		local alpha = canvasGroup.GroupAlpha 
		if time >= (self.duration + self.tweenDuration) then		
			self.toastGroup.Enable = false
			_TimerService:ClearTimer(self.tweenEventId)
			self.tweenEventId = 0
			alpha = 0
		else
			if time > self.duration then			
				alpha = alpha - delta / self.tweenDuration
			else
				alpha = alpha + delta / self.tweenDuration
			end			
		end	
		alpha = math.min(1,math.max(alpha,0))
		
		canvasGroup.GroupAlpha = alpha
		local tweenValue = _TweenLogic:Ease(0,1,1,EaseType.SineEaseIn,alpha)
		transform.anchoredPosition = Vector2(0,-self.offset * tweenValue)
	end
	
	self.tweenEventId = _TimerService:SetTimerRepeat(tween,1/60)
	
	
}


--Events--

