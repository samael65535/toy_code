-- https://forums.coronalabs.com/topic/42019-split-utf-8-string-word-with-foreign-characters-to-letters/
local UTF8ToCharArray = function(str)
	local charArray = {};
	local iStart = 0;
	local strLen = str:len();
	
	local function bit(b)
		return 2 ^ (b - 1);
	end
 
	local function hasbit(w, b)
		return w % (b + b) >= b;
	end
	
	local checkMultiByte = function(i)
		if (iStart ~= 0) then
			charArray[#charArray + 1] = str:sub(iStart, i - 1);
			iStart = 0;
		end        
	end
	
	for i = 1, strLen do
		local b = str:byte(i);
		local multiStart = hasbit(b, bit(7)) and hasbit(b, bit(8));
		local multiTrail = not hasbit(b, bit(7)) and hasbit(b, bit(8));
 
		if (multiStart) then
			checkMultiByte(i);
			iStart = i;
			
		elseif (not multiTrail) then
			checkMultiByte(i);
			charArray[#charArray + 1] = str:sub(i, i);
		end
	end
	
	-- process if last character is multi-byte
	checkMultiByte(strLen + 1);
 
	return charArray;
end
local sd ="然软硬就安静啦啦啦啦睡觉觉吾问无为谓乔沃维奇";
local t = UTF8ToCharArray(sd)
_.each(t, print)