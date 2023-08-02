--Properties--

string className = ""
Component classNameText
Entity firstSlot
dictionary<integer, string> itemSlots
dictionary<integer, string> gauges


--Methods--

[Client Only]
void OnBeginPlay()
{
	
}

[Client]
void Init(integer slotCount, string className)
{
	self.itemSlots[1] = self.firstSlot.ItemSlot
	self.gauges[1] = self.firstSlot.Gauge
	
	for i = 2, slotCount do
		local slot = self.firstSlot:Clone(nil)
		
		self.itemSlots[i] = self.firstSlot.ItemSlot
		self.gauges[i] = self.firstSlot.Gauge
	end
	
	self.className = className
	self.classNameText.Text = className
}


--Events--

