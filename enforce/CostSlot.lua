--Properties--

string value = ""
boolean disable = false


--Methods--

[Client Only]
void OnBeginPlay()
{
	self.value = "0"
	self:Update()
}

[Client Only]
void Update()
{
	local children = self.Entity.Children
	children[2].TextComponent.Text = _Util:NumberComma(self.value)
	if self.disable and (self.value == "0" or self.value == "") then
		self.Entity:SetEnable(false)
	else
		self.Entity:SetEnable(true)
	end
	
}

[Client Only]
void SetValue(string _value)
{
	self.value = _value
	self:Update()
}


--Events--

