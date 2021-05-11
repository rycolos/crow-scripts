-- Input 1: Rate for both LFOs (Clock)
-- Input 2: Shape for LFO 2 (0-5V)
-- Out 1: Sine LFO (Bipolar)
-- Out 2: Shaped LFO (Bipolar)
-- Out 3: Random at clock rate (Unipolar/Bipolar)
-- Out 4: Slewed, distinct random at clock rate (Unipolar/Bipolar)

function init()
	input[1].mode('change',1,.1,'both')
	input[2].mode('stream',.1)
end

-- [[	USER DEFINABLE    ]]--
out1Lev = 5			-- Out 1 Level (5 or 10)
out2Lev = 5			-- Out 2 Level (5 or 10)
out2Mult =	1		-- Mult Out 2 by N. Resets on Clock
out4Slew = 0.1 		-- Out 4 Slew
out3Pol = 5 		-- 0 for Unipolar 10v, 5 for Bipolar 5v
out4Pol = 0 		-- 0 for Unipolar 10v, 5 for Bipolar 5v

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

-- [[	INPUT 1 CLOCK    ]]--
input[1].change = function(s)
	--Output 1 and 2
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
	output[1](lfo(rateSec, out1Lev, 'sine'))
	output[2](lfo((rateSec * out2Mult), out2Lev, dynShape))

-- [[	RANDOM OUTS    ]]--
	rand1 = math.random() * 10.0 - out3Pol
    output[3].volts = rand1
	rand2 = math.random() * 10.0 - out4Pol
	output[4].slew = out4Slew
    output[4].volts = rand2
end
