--Properties--

string img = nil
string name = nil
string value = nil
boolean isChanged = false
Component icon
Component nameText
Component valueText


--Methods--

[Client Only]
void OnBeginPlay()
{
	if self.Entity:GetChildByName("Icon") ~= nil then
		self.icon = self.Entity:GetChildByName("Icon").SpriteGUIRendererComponent
	end
	
	if self.Entity:GetChildByName("Name") ~= nil then
		self.nameText = self.Entity:GetChildByName("Name").TextComponent
	end
	
	if self.Entity:GetChildByName("Value") ~= nil then
		self.valueText = self.Entity:GetChildByName("Value").TextComponent
	end
}

[Client]
void Update()
{
	if self.isChanged then
		if (self.img and self.icon) ~= nil then self.icon.ImageRUID = self.img end
		if (self.name and self.nameText) ~= nil then self.nameText.Text = self.name end
		if (self.value and self.valueText) ~= nil then self.valueText.Text = self.value end
		
		self.isChanged = false
	end
}

[Client]
void Set(string RUID, string name, string value)
{
	self.img = RUID
	self.name = name
	self.value = value
	self.isChanged = true
}

[Client]
void SetImg(string RUID)
{
	self.img = RUID
	self.isChanged = true
}

[Client]
void SetName(string name)
{
	self.name = name
	self.isChanged = true
}

[Client]
void SetValue(string value)
{
	self.value = value
	self.isChanged = true
}

[Client]
void SetNameValue(string name, string value)
{
	self.name = name
	self.value = value
	self.isChanged = true
}

[Client]
void SetFontColor(Color color)
{
	self.nameText.FontColor = color
	self.valueText.FontColor = color
	self.isChanged = true
}


--Events--

