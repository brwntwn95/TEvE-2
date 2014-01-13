--[[
Base N Encoding & Decoding, taken from http://stackoverflow.com/a/14259141
Ported to Lua.
]]--
-- Edit this list of characters as desired.
local BASE_ALPH = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
local BASE_LEN = BASE_ALPH:len()

local function getChar(str, pos)
	return string.sub(str, pos, pos)
end


local BASE_DICT = {}
for i = 1, BASE_LEN do
	local char = getChar(BASE_ALPH, i)
	BASE_DICT[char] = i-1

end


function base_decode(string)
    local num = 0
    for i = 1, string:len() do
    	local char = getChar(string, i)
        num = num * BASE_LEN + BASE_DICT[char]
    end
    return num
end

function base_encode(num)
    if num == 0 then
        return getChar(BASE_ALPH, 1)
	end
	
    local encoding = ""
    
    while num > 0 do 
    	local rem = num % BASE_LEN
    	num = math.floor(num/BASE_LEN)
    	
        encoding = getChar(BASE_ALPH, rem+1)..encoding
    end
    return encoding
end