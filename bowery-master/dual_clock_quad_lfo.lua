--- dual clock quad lfo
-- in1: LFO clock 1 rate
-- in1: LFO clock 2 rate or LFO 1 depth
-- out1-4: LFO 1-4
-- address questions to user damon at ||||||||.co forum (or the relevent thread)
-- or via email to damon@rustleworks.com

function init()

	--[[   begin User Settable Values - most values can be changed while running via druid   ]]--

	--[[	Clock Setup	]]--

	lfoInputs = {
		{
			type = 'clock',
			depth = 5,
		},
		{
			type = 'cv',
			depth = 10,
		}
	}

	--[[	LFO Setup	]]--

	lfoOutputs = {
		{
			clockSource = 1,
			wave = 'saw',
			skew = 0.5,
			mode = 'unipolar',
			rateDivisor = 1,
			depthDivisor = 1
		},
		{
			clockSource = 1,
			wave = 'sawdown',
			skew = 0.5,
			mode = 'unipolar',
			rateDivisor = 2,
			depthDivisor = 2
		},
		{
			clockSource = 2,
			wave = 'tri',
			skew = 0.5,
			mode = 'bipolar',
			rateDivisor = 1,
			depthDivisor = 1
		},
		{
			clockSource = 2,
			wave = 'square',
			skew = 0.5,
			mode = 'unipolar',
			rateDivisor = 3,
			depthDivisor = 3
		}
	}

	--[[	Sundry Setup	]]--

	cvInputRange = 10
	cvRateFastest = 0.01
	cvRateSlowest = 3
	cvRateCurve = 2
	cvDepthMin = 0
	cvDepthMax = 10

	--[[   end user settable values   ]]--

	resolution = 0.0025
	mysteryOffset = 1.165

	for i = 1, #lfoInputs do
		local lfoInput = lfoInputs[i]
		if lfoInput.type == 'clock' then
			lfoInput.rate = nil
			lfoInput.lastClockTime = nil
			input[i]{
				 mode = 'change',
				 threshold = 1,
				 direction = 'rising'
			 }
			 input[i].clockLFO = metro.init{
				 event = cvLFOLoop,
				 time  = resolution,
				 count = -1
			}
			input[i].change = function() clockLFOLoop(i) end
		elseif lfoInput.type == 'cv' then
			input[i]{
				mode = 'stream',
				time = 0.05
			}
			input[i].stream = function(volts) cvLFOStream(lfoInput, volts) end
		elseif lfoInput.type == 'depth' then
			input[i]{
				mode = 'stream',
				time = 0.05
			}
			input[i].stream = function(volts) depthStream(volts) end
		end
	end

	for i = 1, #lfoOutputs do
		lfoOutputs[i].phase = 0
	end

	lfoOutputMetro = metro.init{
		event = lfoOutputLoop,
		time  = resolution,
		count = -1
	}
	lfoOutputMetro:start()
end

function clockLFOLoop(inputindex)
	local lfo = lfoInputs[inputindex]
	if lfo.lastClockTime ~= nil then
		local thisClockTime = time()
		lfo.rate = (thisClockTime - lfo.lastClockTime) / 1000
		lfo.lastClockTime = thisClockTime
		for i = 1, #lfoOutputs do
			if lfoOutputs[i].clockSource == inputindex then
				-- print(i, lfoOutputs[i].phase)
				lfoOutputs[i].phase = 0
			end
		end
	else
		lfo.lastClockTime = time()
	end
end

function cvLFOStream(lfo, volts)
	local processedVolts = volts
	if processedVolts < 0 then
		processedVolts = 0
	elseif processedVolts > cvInputRange then
		processedVolts = cvInputRange
	end
	local reversedVolts = (processedVolts * -1) + cvInputRange
	local scaledVolts = reversedVolts / cvInputRange
	for i = 1, cvRateCurve do
		scaledVolts = (scaledVolts * scaledVolts)
	end
	local rateRange = cvRateSlowest - cvRateFastest

	lfo.rate = (scaledVolts * rateRange) + cvRateFastest
end

function depthStream(volts)
	local processedVolts = volts
	if processedVolts < 0 then
		processedVolts = 0
	elseif processedVolts > cvInputRange then
		processedVolts = cvInputRange
	end
	scaledVolts = processedVolts / cvInputRange
	local depthRange = cvDepthMax - cvDepthMin

	lfoInputs[1].depth = (scaledVolts * depthRange) + cvDepthMin
end

function lfoOutputLoop()
	for i = 1, #lfoOutputs do
		local lfoOutput = lfoOutputs[i]
		local lfoClock = lfoInputs[lfoOutput.clockSource]
		if lfoClock.rate ~= nil then
			local rate = lfoClock.rate / lfoOutput.rateDivisor
			lfoOutput.phase = lfoOutput.phase + ((1 / rate) * (resolution * mysteryOffset))
			if lfoOutput.phase > 1 then
				lfoOutput.phase = lfoOutput.phase - 1
			end
		end

		local polarityShift = 0
		if lfoOutput.mode == 'bipolar' then
			polarityShift = lfoClock.depth / 2
		end

		local depth = lfoClock.depth / lfoOutput.depthDivisor
		local phase = lfoOutput.phase

		if lfoOutput.wave == 'saw' or lfoOutput.wave == 'sawup' or lfoOutput.wave == 'sawdown' then
			local saw = phase * depth
			if lfoOutput.wave ~= 'sawdown' then
				output[i].volts = saw - polarityShift
			else
				output[i].volts = ((saw * -1) + depth) - polarityShift
			end
		elseif lfoOutput.wave == 'tri' then
			if phase < 0.5 then
				output[i].volts = (phase * 2) * depth - polarityShift
			else
				local reversedPhase = (phase * -1) + 1
				output[i].volts = (reversedPhase * 2) * depth - polarityShift
			end
		elseif lfoOutput.wave == 'square' then
			if phase < lfoOutput.skew then
				output[i].volts = depth - polarityShift
			else
				output[i].volts = -polarityShift
			end
		end
	end
end
