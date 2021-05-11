-- root = 1
-- for i=1,12 do 
-- 	print(root+(i/12)) 
-- 	--send to table
-- end

-- -- To find voltage for given degree. Set root in volts
-- root = 1
-- degree = 5
-- deg_volts = root + (root * ((1/12) * (degree - 1)))


-- -- scale of equally spaced intervals. set degree as interval
-- degree = 5 
-- for i=1,12 do
-- 	deg_volts = root + (root * ((1/12) * (degree - 1)))
-- 	print(deg_volts)
-- 	root = deg_volts
-- end


-- math.floor(root*12)*(1/12)

-- math.floor(root)*((1/12) * (degree-1)) + root

function init()
    input[1].mode('stream',.001)
    input[2].mode('stream',.001)
end

thresh = 4

input[1].stream = function(v)
	if v > thresh then
		vfold = v - 2
	elseif v < (-1 * thresh) then
		vfold = v + 2
	else
		vfold = v
	end

	output[1].volts = v
	output[2].volts = vfold

	--print(output[2].volts)
end

