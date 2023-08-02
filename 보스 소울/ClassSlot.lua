--Properties--

integer idx = 0
string krName = ""
string enName = ""
integer level = 0
integer expRatio = 0
boolean isLevelUp = false
boolean isSelected = false
string selectedImage = ""
string deselectedImage = ""
Component character
Component contour
Component krNameText
Component enNameText
Component levelText
Component gauge
Component gaugeText
Entity levelUpEntity


--Methods--

[Client]
void Init(integer idx, string selected, string deselected, string krn, string enn)
{
	self.idx = idx
	self.selectedImage = selected
	self.deselectedImage = deselected
	
	local entity = self.Entity
	local gaugeUI = entity:GetChildByName("Gauge")
	
	self.character = entity:GetChildByName("Character").SpriteGUIRendererComponent
	self.contour = entity:GetChildByName("Contour").SpriteGUIRendererComponent
	self.krNameText = entity:GetChildByName("NameKr").TextComponent
	self.enNameText = entity:GetChildByName("NameEn").TextComponent
	self.levelText = entity:GetChildByName("Level").TextComponent
	self.levelUpEntity = entity:GetChildByName("LevelUp")
	
	self.gauge = gaugeUI:GetChildByName("Front").SpriteGUIRendererComponent
	self.gaugeText = gaugeUI:GetChildByName("Value").TextComponent
	
	self.krNameText.Text = krn
	self.enNameText.Text = enn
}

[Client]
void Update()
{
	if self.isSelected then 
		self.character.ImageRUID = self.selectedImage
		self.contour.Color = Color.white
		self.krNameText.FontColor = _SkillSetEnum.SelectedTextColor
		self.enNameText.FontColor = _SkillSetEnum.SelectedTextColor
		self.levelText.FontColor = _SkillSetEnum.SelectedTextColor
		
		
	else 
		self.character.ImageRUID = self.deselectedImage 
		self.contour.Color = Color.black
		self.krNameText.FontColor = Color.black
		self.enNameText.FontColor = Color.black
		self.levelText.FontColor = Color.black
		
	end
	
	
}

[Client]
void UpdateInfo()
{
	if self.isLevelUp then 
		self.levelUpEntity:SetVisible(true)
		self.gaugeText.Text = "LevelUp!"
		self:SetGauge(100)
		
	else 
		self.levelUpEntity:SetVisible(false) 
		self.gaugeText.Text = tostring(self.expRatio) .. "%"
		self:SetGauge(self.expRatio)
		
	end
	
	self.levelText.Text = "Lv." .. tostring(self.level)
}

[Client]
void SetGauge(integer value)
{
	
}

[Client]
void SetValue(boolean selected, boolean levelUp, integer level, integer exp)
{
	self.isSelected = selected
	self.isLevelUp = levelUp
	self.level = level
	self.expRatio = exp
	
	self:UpdateInfo()
	
	
}

[Client]
void SetSelected(boolean selected)
{
	self.isSelected = selected
}


--Events--

[Default]
HandleButtonClickEvent(ButtonClickEvent event)
{
	--------------- Native Event Sender Info ----------------
	-- Sender: ButtonComponent
	-- Space: Client
	---------------------------------------------------------
	
	-- Parameters
	local Entity = event.Entity
	---------------------------------------------------------
	_SkillSetClient:ClassSlotClicked(self.idx)
	
}

