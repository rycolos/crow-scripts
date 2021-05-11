-- sample & hold
-- int1: sampling clock
-- out1: random sample

function init() -- startup things
	input[1].mode('change',1.0,.1,'rising')
	input[2].mode('stream',.001)
end

input[1].change = function(state)
    input[2].stream = function()
    	v = (input[2].volts) 
    	output[2].volts = v
    end
end