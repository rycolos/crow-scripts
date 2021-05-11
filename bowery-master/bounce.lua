-- bounce.lua
-- S. Anderson

-- create a bouncing ball set of pulses when sent a trigger pulse

delayTimeArray = {}
indexValue = 0
-- the following have an impact on the values we stuff in the bounce array
bounceTime = 1 -- bounce duration
bounceRepeats = 80 -- number of times to go through loop when creating numbers
done = false
-- the following can be tweaked to adjust the outgoing pulse
pulseTime = 0.01 -- output pulse time
pulseLevel = 3 -- output pulse level


-- make an array of numbers based on bouncing ball
function bounce(delayTime, numberOfRepeats)
		for n=1,numberOfRepeats do
			delayTime = delayTime * 3/4
			-- we could do this instead but the above sounds more musical
	    -- delayTime = delayTime * 3/4^2
			table.insert(delayTimeArray, delayTime)
			if (delayTime<0.05) then break end
		end
end

function outPulse()
		output[1](pulse(pulseTime,pulseLevel,1))
    print("Sending Pulse")
end

function init()
	-- set up watching for an input pulse
	input[1].mode('change',1,0.1,'rising')
	-- populate an array based on preset values
	bounce(bounceTime,bounceRepeats)
end

input[1].change = function(state)
	-- run through a set of delay values each outputing a pulse when done
	print("In change")
  indexValue = 0
	done = false
  doDelay()
end

function doDelay()
	-- recursivly run through our array
	if (indexValue >= #delayTimeArray) then
		indexValue = 0
		done = true
		print("End")
		return
	end
	if (done == true) then
		return
	end
  indexValue = indexValue + 1
	print(indexValue)
  thisDelay = delayTimeArray[indexValue]
	print(thisDelay)
  outPulse()
  delay(doDelay, thisDelay, 1)
end
