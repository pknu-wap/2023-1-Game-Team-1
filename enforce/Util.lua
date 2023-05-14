--Properties--

string EmptyImg = "3e9d52ed52d64794bbd6f72bab8ee3d9"


--Methods--

[Default]
string NumberComma(string num)
{
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


--Events--

