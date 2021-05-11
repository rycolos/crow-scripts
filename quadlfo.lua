--INPUT 1: Rate
--INPUT 2: Shape
--OUTPUT 1: Dog	
--OUTPUT 2: Pig
--OUTPUT 3: Sloth
--OUTPUT 4: Drunk Sloth

function init()
	input[1].mode('change',1,.1,'both')
	input[2].mode('stream',.1)
end

-- [[	USER DEFINABLE    ]]--
out1Lev = 5		-- Out 1 Level (5 or 10)
out2Lev = 5		-- Out 2 Level (5 or 10)
out3Lev = 5		-- Out 1 Level (5 or 10)
out4Lev = 5		-- Out 2 Level (5 or 10)

-- [[	SHAPES    ]]--
-- < 1V - Sine
-- 1-2V - Lin
-- 2-3V - Log
-- 3-4V - Exp
-- > 4V - Rebound

input[2].stream = function(v)
	if v < 1 then
		dynShape = 'sine'
	elseif v  > 1 and v < 2 then
		dynShape = 'lin'
	elseif v > 2 and v < 3 then
		dynShape = 'log'
	elseif v > 3 and v < 4 then
		dynShape = 'exp'
	elseif v > 4 then
		dynShape = 'rebound'
	end
end

input[1].change = function(s) --Rate
	--Calculate delta between peak to trough
		--How to deal with initial nil values?
	if s == true then
		t1 = time()
	elseif s == false then
		t2 = time()
		rateMs = t2 - t1   
		--print(rateMs)
		rateSec = rateMs/1000
	end

	output[1](lfo(rateSec, out1Lev, dynShape))
	output[2](lfo((rateSec * 1.6), out2Lev, dynShape))
	output[3](lfo(rateSec * 2.3, out3Lev, dynShape))
	output[4](lfo(rateSec * 6.4, out4Lev, dynShape))
end