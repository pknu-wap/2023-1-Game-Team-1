--Properties--

string EmptyImg = "3e9d52ed52d64794bbd6f72bab8ee3d9"
string LockImg = "737176a452f84f4584c8773a922b520f"
string DefaultSlot = "db2f63211c2a4028b156f88474335bb3"
string SelectedSlot = "f8aabecc323d4b43a0a1ac2687387845"


--Methods--

[Default]
string Comma(string num)
{
	if num == nil then return nil end
		
	local len = num:len()
	if len < 4 then
		return num
	end
	
	local cursor = 1
	local mod = len % 3
	local ret = ""
	
	if mod ~= 0 then
		ret = num:sub(1, mod) .. ","
		cursor = mod + 1
	end
	
	while len - cursor > 3 do
		ret = ret .. num:sub(cursor, cursor + 2) .. ","
		cursor = cursor + 3
	end
	
	ret = ret .. num:sub(len - 2, len)
	
	return ret
}

[Default]
string ClassIdxToString(integer class)
{
	local classArr = {"sword", "wand", "dagger", "bow"}
	
	return classArr[class]
}


--Events--

