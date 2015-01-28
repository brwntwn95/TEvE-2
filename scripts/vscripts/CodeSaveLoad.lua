-- SaveLoad script for TEvE2 by Yoshi2
-- main functions are:
--	save(username, datatable) (returns code as string)
--	load(username, code) (returns nil, nil if failed to load, else returns true, datatable)


local bit = require "lib.numberlua"
local base = require "lib.BaseEncoding"

-- We define many values which are used in this script as local.
-- Micro Optimization, can be reverted at a later point if it
-- proves to be troublesome
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
local char_num
local start_index

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
				{"Points in Skill 4", 1},
				{"Ultimate Skill", 1}}

print(FORMAT_HERO[1])

-- Take a table and reverse it
local function reverse(list)
    local size = #list
    local newList = {}
    for i = #list, 1, -1 do
        table.insert(newList, list[i])
    end
 
    return newList
end

-- WHY DOESN'T LUA HAVE A BUILT-IN STRING REPRESENTATION OF TABLES
-- Takes a table and creates a shallow string representation of it.
local function repr_table(tabl)
	local str = ""
	for i, v in pairs(tabl) do
		str = str.." "..tostring(i)..":"..tostring(v)
	end
	return str
end

-- WHY DOESN'T LUA HAVE A BUILT-IN FUNCTION FOR THIS
-- Returns the character at the position 'pos' in the string 'str'
local function getChar(str, pos)
	return sub(str, pos,pos)
end

-- XOR each value in the data table with one value from the key table
-- Puts new value into the table newTable which is then returned
local function xor_data(data, key)
	local newTable = {}
	local length = #key
	for i, val in pairs(data) do
		insert(newTable, bxor(val, key[(i%length)+1]))
	end
	
	return newTable
end

-- XOR the byte value with each value of the key
-- number of iterations depends on length of key
local function xor_byte(byte, key)
	local byte = byte
	local length = #key
	for i = 1, length do
		byte = bxor(byte, key[(i%length)+1])
	end
	
	return byte
end

-- Take number and break it up into several byte values which are returned in a table 
local function pack_number_in_characters(num, bytes)
	pack_numbers = {}
	
	if log(num)/log(256) > bytes then
		return nil -- the number requires more characters than specified, ABORT!
	end
	
	for i = 0, bytes-1 do
		pack_byte = band(rshift(num, 8*i), 0xFF)
		
		insert(pack_numbers, pack_byte)
	end
	
	return pack_numbers
end

-- function to be used with string.gsub, puts each letter of the string
-- into the table username_table
local function string_to_table(letter)
	insert(username_table, string_byte(letter))
end

CodeSaveLoad = {}
-- The save Function takes username (a string) and userdata (a table)
-- It returns a save code as a string which can be loaded with the load function
function CodeSaveLoad:save(username, userdata)
	
	--
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
	
	-- We pack each value into a number of characters depending on the specified format
	for i, val in ipairs(userdata) do
		valName = FORMAT_HERO[i][1]
		byteUsage = FORMAT_HERO[i][2]
		
		datastring = pack_number_in_characters(val, byteUsage)
		
		for k, num in pairs(datastring) do
			insert(endstring, num)
		end
	end
	
	
	--print(floorlength, #endstring)
	
	-- Simple checksum calculation, calculate the arithmetic mean of the values in the data.
	-- After that, we XOR it several times with the user's name to provide
	-- a bit of randomness.
	chksum = 0
	for i, val in pairs(endstring) do
		chksum = chksum + val
	end
	chksum = xor_byte(floor(chksum/#endstring), username_table)
	chksum = base_encode(chksum)
	
	-- We XOR the data using the user's name to prevent people from reusing other
	-- people's codes too easily.
	endstring = xor_data(endstring, username_table)
	
	code = ""
	floorlength = floor((#endstring)/3)
	
	-- Finally, we pack the data, three values at a time, into single numbers which
	-- we encode using the base encode function.
	for i = 0, floorlength do
		new_i = i*3
		
		if i == floorlength then
			-- If the length of the data is not a multiple of 3, we attempt to 
			-- encode the remaining values into a single number which is then encoded.
			-- This has proven to be very troublesome on code loading, please make sure
			-- that the data format requires a number of bytes that is a multiple of 3.
			remainder = (i+1)*3-#endstring
			if 3-remainder > 0 then
				total = 0
				for k = 1, (3-remainder) do
					val = endstring[new_i+k]
					total = total + val*(255^(k-1))
				end
			else
				break
			end
			
		else
			val1, val2, val3 = endstring[new_i+1], endstring[new_i+2], endstring[new_i+3]
			
			total = bor(bor(lshift(val1, 8*2), lshift(val2,8*1)), val3)
		end 
		
		if code == "" then
			code = base_encode(total)
		else -- we only need the '-' when it is between two bits of the code
			code = code.."-"..base_encode(total)
		end
	end

	return code.."-"..chksum
end


-- The load Function takes username (a string) and code (a string)
-- It returns a two variables: 
-- 		nil, nil: code loading has failed due to checksum mismatch
--		true, datatable: code loding was successful, data is returned as a table
function CodeSaveLoad:load(username, code)
	local num
	local dat = {}
	
	-- We iterate over the parts of the code, decode them and
	-- put them into seperate 1 byte (range should be from 0 to 255) values
	for part in string.gmatch(code, "(%w+)%-") do
		num = base_decode(part)
		
		val3 = band(num, 0xFF)
		val2 = band(rshift(num, 8), 0xFF)
		val1 = band(rshift(num, 16), 0xFF)
		
		table.insert(dat,val1)
		table.insert(dat,val2)
		table.insert(dat,val3)
	end
	
	-- The last bit of the code is the checksum, we need it for basic code verification
	local endchksum = string.gmatch(code, "%-(%w+)$")()
	local norm_chksum = base_decode(endchksum)
	
	-- Again, break username into seperate characters which are put into the table
	username_table = {}
	gsub(username, "(.)", string_to_table)
	
	
	
	local decoded_data = xor_data(dat, username_table)
	
	-- Simple checksum calculation, calculate the arithmetic mean of the data
	chksum = 0
	for i, val in pairs(decoded_data) do
		chksum = chksum + val
	end
	chksum = floor(chksum / #decoded_data)
	
	-- We reverse the username table to receive the original checksum for the code
	local reversed_name = reverse(username_table)
	norm_chksum = xor_byte(norm_chksum, reversed_name)
	
	-- If original checksum is not equal to calculated checksum, loading failed.
	-- Otherwise, the checksum comparsion is successful.
	if norm_chksum ~= chksum then
		return nil, nil
	else
		local playerData = {}
		local index = 1
		local bytes
		local entry
		local newIndex
		
		-- We iterate over the format entries to take the seperated values 
		-- and put them together into a single value
		for i,val in ipairs(FORMAT_HERO) do
			bytes = val[2] -- the number of bytes the value takes
			entry = 0
			newIndex = index
			for j = index, index+bytes-1 do
				local toShift = (j - index)
				local num = decoded_data[j]
				entry = bor(entry, lshift(num, 8*toShift))
				
				newIndex = newIndex + 1
			end
			index = newIndex
			table.insert(playerData, entry)
		end
		
		-- And now we're done
		return true, playerData
	end
		
end

playername = "SinZ"
playerdata = {51, 896782, 100, 6, 67, 2, 13}

print("starting")
print("Player: "..playername.." |Playerdata: "..repr_table(playerdata))

code = save(playername, playerdata)
print(code)

successfullyLoaded, loadedData = load(playername, code)
print(successfullyLoaded, repr_table(loadedData))

