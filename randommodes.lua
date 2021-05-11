--Input 1: Clock
--Input 2: Step length
--Output 1: Random
--Output 2: Gaussian random
--Output 3: Drunk walk
--Output 4: Drunk walk 2

--5V bipolar outputs

function init()
    input[1].mode('change',1,.1,'rising')
    input[2].mode('stream',.1)
    drunkCliff = 5 --Drunk walk bipolar range
    step = .1 --Initial step size values
    step2 = .1
end


input[1].change = function(s)
	--Random
	r1 = math.random() + math.random(-5,4)
	--print(r1)
	output[1].volts = r1

	--Gaussian (algo from zebra @ lllll.co)
	function Gaussian()
		local D = 5
		x = 0
		for i = 1,D do
			x = x + math.random()
		end
		return x * 2 - D
	end
	r2 = Gaussian()
	--print(r2)
	output[2].volts = r2

	--Drunk walk
	input[2].stream = function(v) --Step length selection
		if v <= 1 then
			step = .1
			step2 = .6
		elseif v  > 1 and v < 2 then
			step = .2
			step2 = .5
		elseif v > 2 and v < 3 then
			step = .3
			step2 = .4
		elseif v > 3 and v < 4 then
			step = .4
			step2 = .3
		elseif v > 4 and v < 5 then
			step = .5
			step2 = .2
		elseif v >= 5 then
			step = .6
			step2 = .1
	end

	a = math.random(0,1) -- Drunk Walk 1
	if a == 0 then 
		dOut = output[3].volts + step
		if dOut > drunkCliff then dOut = step end
		output[3].volts = dOut
	else 
		dOut = output[3].volts - step
		if dOut < (drunkCliff * -1) then dOut = step end
		output[3].volts = dOut
	end
	--print(output[3].volts)

	a2 = math.random(0,1) -- Drunk Walk 2
	if a2 == 0 then 
		dOut2 = output[4].volts + step2
		if dOut2 > drunkCliff then dOut2 = step2 end
		output[4].volts = dOut2
	else 
		dOut2 = output[3].volts - step2
		if dOut2 < (drunkCliff * -1) then dOut2 = step2 end
		output[4].volts = dOut2
	end
	--print(output[4].volts)
	
end
