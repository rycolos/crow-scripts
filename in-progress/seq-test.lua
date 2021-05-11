function init()
    input[1]{ mode      = 'change'
            , direction = 'rising'
            }
end

step = 0
seq = {1, 2, 1.5, 1.33}

input[1].change = function()
	step = step + 1
	output[1].volts = seq[step]
	if step == #seq then
		step = 0
	end
end
