input[1].mode('change',1.0,.1,'rising')

chord = {0,4,7,11}


input[1].change = function(s)
	r1 = math.random(4)
	n1 = chord[r1] 
	r2 = math.random(4)
	n2 = chord[r2] 
	output[1].volts=n2v(n1)
	output[2](ar(2,(math.random()*2),10),'log') --random AR envelope
	output[3].volts=n2v(n2)
	output[4](ar(2,(math.random()*2),10),'exp') --random AR envelope
end