local bit = require "lib.numberlua"
local base = require "lib.BaseEncoding"

local total
local val
local remainder
local val1, val2, val3
local new_i
local valName
local byteUsage
local username_table
local endstring
local pack_numbers
local chksum
local code
local datastring
local pack_byte
local floorlength

local bxor = bit.bxor
local band, bor = bit.band, bit.bor
local lshift, rshift = bit.lshift, bit.rshift

local insert = table.insert
local log = math.log
local string_byte = string.byte
local gsub = string.gsub
local sub = string.sub
local floor = math.floor


local FORMAT_HERO	= {	{"ClassID",	1},
				{"Experience", 3},
				{"Points in Skill 1", 1},
				{"Points in Skill 2", 1},
				{"Points in Skill 3", 1},
				{"Points in Skill 4", 1}}

print(FORMAT_HERO[1])

function reverse(list)
    local size = #list
    local newList = {}
 
    for i,val in ipairs(list) do
        newList[size-i] = v
    end
 
    return newList
end

function getChar(str, pos)
	return sub(str, pos,pos)
end

function xor_data(data, key)
	local newTable = {}
	local length = #key
	for i, val in pairs(data) do
		--print((i%length)+1)
		--print(bit.bxor(val, key[(i%length)+1]))
		insert(newTable, bxor(val, key[(i%length)+1]))
		
	end
	
	return newTable
end

function xor_byte(byte, key)
	local byte = byte
	local length = #key
	for i = 2, length do
		byte = bxor(byte, key[(i%length)+1])
	end
	
	return byte
end

function pack_number_in_characters(num, bytes)
	pack_numbers = {}
	
	if log(num)/log(256) > bytes then
		return nil -- the number requires more characters than the bytes variable says!
	end
	
	for i = 0, bytes-1 do
		pack_byte = band(rshift(num, 8*i), 0xFF)
		
		insert(pack_numbers, pack_byte)
		--number_string = number_string..string.char(byte)
		
		
	end
	--print(number_string)
	return pack_numbers
	--print(string.byte(number_string, 1, string.len(number_string)))
end





function string_to_table(letter)
	insert(username_table, string_byte(letter))
end

function save(username, userdata)
	--print(username, userdata)
	
	username_table = {}
	gsub(username, "(.)", string_to_table)
	--print(username_table[2])
	--for i = 1, #username do
	--	table.insert(username_table, string.byte(username, i))--getChar(username, i))
	--	--print(string.byte(username, i))
	--end
	
	endstring = {}
	
	-- ensuring that there is just enough data in the userdata
	-- as in our format specification
	if #userdata ~= #FORMAT_HERO then
		return nil
	end
	
	for i, val in ipairs(userdata) do
		valName = FORMAT_HERO[i][1]
		byteUsage = FORMAT_HERO[i][2]
	
		--print(string.format("%s: %s (Uses %s byte(s))",valName, val, byteUsage))
		
		datastring = pack_number_in_characters(val, byteUsage)
		
		for k, num in pairs(datastring) do
			insert(endstring, num)
		end
		
		--print(datastring:byte(1, datastring:len()))
		--endstring = endstring..datastring
	end
	
	code = ""
	floorlength = floor((#endstring)/3)
	--print(floorlength, #endstring)
	
	chksum = 0
	for i, val in pairs(endstring) do
		chksum = chksum + val
	end
	chksum = xor_byte(floor(chksum/#endstring), username_table)
	chksum = base_encode(chksum)
	--print("CHKSUM", chksum)
	
	--print("----------")
	endstring = xor_data(endstring, username_table)
	--print("----------")
	
	for i = 0, floorlength do
		new_i = i*3
		if i == floorlength then
			remainder = (i+1)*3-#endstring
			total = 0
			for k = 1, (3-remainder) do
				val = endstring[new_i+k]
				--print(val)
				total = total + val*(255^(k-1))
			end
			
			--print(total, "WUT")
		else
			val1, val2, val3 = endstring[new_i+1], endstring[new_i+2], endstring[new_i+3]
			
			total = bor(bor(lshift(val1, 8*2), lshift(val2,8*1)), val3)
			--print(total)
		end 
		--print(total)
		
		if code == "" then
			code = base_encode(total)
		else
			code = code.."-"..base_encode(total)
		end
	end
	
	
	
	--print(chksum)
	return code.."-"..chksum
end

playername = "SinZ"
playerdata = {51, 896782, 5, 6, 3, 2}
print("starting")
count = 0
start = os.clock()

for exp = 1, 500000 do
	playerdata[2] = exp
	save(playername, playerdata)
	--print()
	count = count + 1
end
endtime = os.clock()-start
print("end")
print(string.format("%s codes generated in %s seconds", count, endtime))
print(string.format("Rate: %s per second", count/endtime))
print(string.format("Rate: %s seconds per code", endtime/count))

