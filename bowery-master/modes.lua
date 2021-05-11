-- sam wolk, october 2019

-- Input 1 : Clock
-- Input 2 : Data
-- Output 1,2,3,4 : Configurable
-- scale sets the available notes (in semitones) for the quantized modes.

--[[ mode options: 
'sequence', 'SH', 'SH_slew', 'SH_quantize', 
'SH_rand', 'SH_rand_slew', 'SH_rand_quantize', 
'LFO_saw', 'LFO_tri', 'LFO_ramp', 
'LFO_rect', 'pulse', 'noise' ]]

mode={}
mode[1] = 'sequence' -- Output 1
mode[2] = 'SH_rand'  -- Output 2
mode[3] = 'SH'       -- Output 3
mode[4] = 'LFO_tri'  -- Output 4

-- The divs table sets individual clock divider values for the input clock for each output. 
divider = {}
divider[1] = 1 -- Output 1
divider[2] = 1 -- Output 2
divider[3] = 1 -- Output 3
divider[4] = 1 -- Output 4

-- outputLevels acts as an attenuator for the output.
output[1].level = 1
output[2].level = 1
output[3].level = 1
output[4].level = 1

-- scale set in semitones for quantize modes.
scale = {0,2,4,5,7,9,11,12}

-- sequence set in semitones for Sequencer mode
sequence = {0,4,0,5,7,11,0,4}

-- Initialize Non-user Variables
intervalRegister = {0,0,0,0,0}
outputCounter = {-1,-1,-1,-1}
average = 0
sequenceLoc = {0,0,0,0}

-- Define functions
function quantize(volts,scale) 
	local oct = math.floor(volts)
	local interval = volts - oct
	local semitones = interval / (n2v(1))
	local degree = 1
	while degree < #scale and semitones > scale[degree+1]  do
		degree = degree + 1
	end
	local above = scale[degree+1] - semitones
	local below = semitones - scale[degree]
	if below > above then 
		degree = degree +1
	end
	note = scale[degree]
	note = note + 12*oct
	return note
end

input[1].change = function(state) 
	table.remove(intervalRegister) -- Remove last timestamp
	table.insert(intervalRegister,1,time())	-- Place the current count into the first spot in the register

	-- Calculate the average difference of timestamps 
	average = 0
	for i=1,#intervalRegister-1 do 
		average = average+intervalRegister[i]-intervalRegister[i+1]
	end
	average = average/(#intervalRegister-1)
	
	for i=1,4 do
		outputCounter[i] = (outputCounter[i] + 1) % divider[i]
		if 0 == outputCounter[i] then	
			if mode[i] == 'SH' then
				output[i].slew = 0
				output[i].volts = input[2].volts*output[i].level
			end
			if mode[i] == 'SH_slew' then
				output[i].slew = divider[i]*average/(1000)
				output[i].volts = input[2].volts*output[i].level
			end
			if mode[i] == 'sequence' then
				output[i].slew = 0
				output[i].volts = n2v(sequence[sequenceLoc[i]+1])
				sequenceLoc[i] = (sequenceLoc[i]+1)%#sequence
			end
			if mode[i] == 'SH_quantize' then
				output[i].slew = 0
				output[i].volts = n2v(quantize(input[2].volts*output[i].level,scale))
			end
			if mode[i] == 'SH_rand' then
				output[i].volts = (math.random(10000)/1000-5)*output[i].level
			end
			if mode[i] == 'SH_rand_slew' then
				output[i].slew = divider[i]*average/(1000)
				output[i].volts = (math.random(10000)/1000-5)*output[i].level
			end
			if mode[i] == 'SH_rand_quantize' then
				output[i].volts = n2v(quantize((math.random(10000)/1000-5)*output[i].level,scale))
			end
			if mode[i] == 'LFO_tri' then
				output[i].action = {to(5*output[i].level,(divider[i]*average)/(2*1000.0)),to(-5*output[i].level,(divider[i]*average)/(2*1000.0))}
				output[i]()
			end
			if mode[i] == 'LFO_saw' then
				output[i].action = {to(5*output[i].level,0),to(-5*output[i].level,divider[i]*(average)/1000.0)}
				output[i]()
			end
			if mode[i] == 'LFO_ramp' then
				output[i].action = {to(-5*output[i].level,0),to(5*output[i].level,divider[i]*(average)/1000.0)}
				output[i]()
			end
			if mode[i] == 'LFO_rect' then
				output[i].action = {to(5*output[i].level,0),to(5*output[i].level,(divider[i]*average)/2000.0),to(-5*output[i].level,0),to(-5*output[i].level,(divider[i]*average)/2000.0)}
				output[i]()
			end
			if mode[i] == 'noise' then
				output[i].action = loop{to(function() return math.random(10000)/1000-5 end, 0.008)}
				output[i]()
			end
			if mode[i] == 'pulse' then
				output[i](pulse(0.01,8,1))
			end
		end
	end
end

function init()
	input[1].mode('change', 1, 0.05, 'rising')
	intervalRegister[1] = time()
	print('modes script loaded')
end
