— randomquantized
– in1: incoming clock
– in2: input voltage as a seed
– out1: pulses, random divisions of incoming clock
– out2: input + random unquantized
– out3: input + random quantized (quantized for octaves)
– out4: input + random quantized (quantized chromatically)

function init()
input[1].mode(‘change’, 1.0, 0.1, ‘rising’)
output[2].slew = 0.03
output[3].slew = 0.03
output[4].slew = 0.03
end

input[1].change = function()
v = input[2].volts
r = math.random() * 10.0 - 5.0/v
output[1](pulse(0.1 * math.abs(math.random(v)) , 5 , 1))
output[2].volts = r
output[3].volts = math.floor(r )
output[4].volts = math.floor(r*12)/12
end