--Properties--



--Methods--

[Default]
table GetStringTable(string str)
{
	local delimiter = ", "
	
	local result = {}
	for token in string.gmatch(str, "[^" .. delimiter .. "]+") do
	    table.insert(result, token)
	end
	
	return result
}

[Default]
table GetNumberTable(string str)
{
	local delimiter = ", "
	
	local result = {}
	for token in string.gmatch(str, "[^" .. delimiter .. "]+") do
	    table.insert(result, tonumber(token))
	end
	
	return result
}


--Events--

