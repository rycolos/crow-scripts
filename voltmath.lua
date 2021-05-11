--Input 1 - CV 1
--Input 2 - CV 2
--Output 1-4 - Defined math functions

function init()
    input[1].mode('stream',.01)
    input[2].mode('stream',.01)
end

--Clamps outputs to +peak/-5
peak = 5
function clamp(n)
	return math.max(math.min(n, peak), -5)
end

--Fold thresh
thresh = 4

--MATH FUNCTIONS
	function sum()
		return clamp(a+b)
	end

	function invs()
		return clamp(-a-b)
	end

	function diff()
		return clamp(a-b)
	end

	function mult()
		return clamp(a*b)
	end

	function div()
		return clamp(a/b)
	end

	function min()
		return clamp((math.min(a,b)))
	end

	function max()
		return clamp((math.min(a,b)))
	end

	function avg()
		return clamp((a+b)/2)
	end

	function fold()
		sumf = a + b
		if v > thresh then
			vfold = v - 2
		elseif v < (-1 * thresh) then
			vfold = v + 2
		else
			vfold = v
		end
		return vfold
	end


input[1].stream = function(v1)
	input[2].stream = function(v2)
		a = input[1].volts
		b = input[2].volts

		output[1].volts = sum()
		--print(output[1].volts)

		output[2].volts = diff()
		--print(output[2].volts)

		output[3].volts = mult()
		--print(output[3].volts)

		output[4].volts = fold()
		--print(output[4].volts)
	end
end




