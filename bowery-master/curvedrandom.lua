--- curvedrandom.lua
-- out 1: random values

-- curveLevel and bellFactor accept values 1 - 6 (integers)
-- 1 = no curve/bell
-- 6 = maximum curve/bell
curveLevel = 1
bellFactor = 1
curveDirection = 'up' -- 'up', 'down'
octaves = 3

function init()
   metro[1].event = function()
      output[1].volts = getCurvedRandom(0, octaves, curveLevel, bellFactor, curveDirection)
   end
   metro[1].time  = 0.2
   metro[1]:start()

   print('curved random initialized')
   print('curveLevel = ', curveLevel)
   print('bellFactor = ', bellFactor)
   print('curveDirection = ', curveDirection)
   print('octaves = ', octaves)
end

function getCurvedRandom(min, max, curvelevel, bellfactor, direction)
	local curveLevels = {1, 0.75, 0.5, 0.25, 0.125, 0.0625}
	local bellLevels = {1, 2, 4, 8, 16, 32}
	local curve = curveLevels[curvelevel]
	local bellFactor = bellLevels[bellfactor]

	local wRand = 0
	for i = 1, bellFactor do
		wRand = wRand + (math.pow(math.random(), curve) * (1/bellFactor))
	end
	if direction == 'down' then
		wRand = (wRand - 1) * -1;
	end

   return wRand * (max - min) + min
end
