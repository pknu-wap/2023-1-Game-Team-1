--Properties--

string name = ""
string value = ""
boolean isNum = false


--Methods--

[Client Only]
void OnBeginPlay()
{
	local children = self.Entity.Children
	self.name = children[1].TextComponent.Text
	self.value =children[2].TextComponent.Text
}

[Client Only]
void SetAll(string _name, string _value, boolean _isNum)
{
	self.name = _name
	self.value = _value
	self.isNum = _isNum or true
	self:Update()
}

[Client Only]
void SetName(string _name)
{
	self.name = _name
	self:Update()
}

[Client Only]
void SetValue(string _value, boolean _isNum)
{
	self.value = _value
	self.isNum = _isNum or true
	self:Update()
}

[Client Only]
void Update()
{
	local children = self.Entity.Children
	children[1].TextComponent.Text = self.name
	if self.isNum then
		children[2].TextComponent.Text = _Util:NumberComma(self.value)
	else
		children[2].TextComponent.Text = self.value
	end
	
}


--Events--

