--Properties--

integer idx = 0
integer max = 0
integer current = 0
integer ratio = 0
Entity back
Component front
Component textEntity
Vector2 size = Vector2(0,0)
boolean vertical = false
boolean customText = false
string text = ""


--Methods--

[Client]
void Init(integer max, boolean vertical, boolean customText)
{
	self.back = self.Entity:GetChildByName("Back")
	self.front = self.Entity:GetChildByName("Front").UITransformComponent
	self.textEntity = self.Entity:GetChildByName("GaugeText").TextComponent
	
	self.size = self.back.UITransformComponent.RectSize
	
	self.max = max
	self.current = max
	self.ratio = 100
	
	if vertical ~= nil then self.vertical = vertical end
	if customText ~= nil then self.customText = customText end
}

[Client]
void SetValue(integer value)
{
	
	if value > self.max then
		self.current = self.max
		self.ratio = 100
	else
		self.current = value
		self.ratio = (value / self.max) * 100
	end
	
	self.text = tostring(value).."/"..tostring(self.max)
	self:Update()
}

[Client]
void SetRatio(integer ratio)
{
	
	if ratio > 100 then 
		self.ratio = 100
		self.current = self.max
	else
		self.ratio = ratio
		self.current = self.max * ratio / 100	
	end
	
	self:Update()
}

[Client]
void Update()
{
	if self.vertical then
		local height = self.size.y * self.ratio / 100
		self.front.RectSize.y = height
		self.front.Position.y = self.size.y / -2 + height / 2
	else
		
		local width = self.size.x * self.ratio / 100 
		self.front.RectSize.x = width
		self.front.Position.x = self.size.x / -2 + width / 2
	end
	
	if self.textEntity ~= nil then
		if self.customText then
			self.textEntity.Text = self.text
		else
			if self.current <= 0 then
				self.textEntity.Text = " "
			else
				self.textEntity.Text = tostring(self.current / 10)
			end
		end
	end
}

[Client]
void SetText(string text)
{
	self.text = text
	self:Update()
}

[Client]
void SetRatioText(integer ratio, string text)
{
	self.ratio = ratio
	self.text = text
	self:Update()
}


--Events--

