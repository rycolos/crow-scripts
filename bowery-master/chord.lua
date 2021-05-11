--- generate a chord from a single input 
-- in1: gate in
-- in2: chord root quantized to v/oct 
-- out1-4: chord degrees

--needs work to make it interesting/musical

--chords from music-thing-modular chord-organ

c1 = {0,4,7,12,0} --Major
c2 = {4,7,12,16,-5} --Major inv 1
c3 = {7,12,16,-5,0} --Major inv 2
c4 = {-12,-8,-5,0,4} --Major inv 3
c5 = {-8,-5,0,4,7} --Major inv 4
c6 = {-5,0,4,7,12} --Major inv 5
c7 = {0,4,7,11,0} --Major 7th
c8 = {4,7,11,0,16} --Major 7th inv 2
c9 = {7,11,0,16,19} --Major 7th inv 3
c10 = {-12,-8,-5,-1,0} --Major 7th inv 4
c11 = {-8,-5,-1,0,4} --Major 7th inv 5
c12 = {-8,4,7,11,23} --Major 7th no root
c13 = {0,0,0,0,0} --Root
c14 = {-24,-12,0,12,24} --organ
c15 = {-8,-5,4,7,16} --Major no root
c16 = {-12,0,0,12,24} --2 up 1 down octave

--set the chord to play. also change this from druid
chord = c1

--clock in
function init()
	input[1]{mode = 'change', direction = 'rising'}
end

input[1].change = function()
	--get the voltage from input 2 - 'the root'
	v = input[2].volts
	
	--get the chord degrees, /12 to get semitones in v/oct
	i = chord[1]/12
	ii = chord[2]/12
	iii = chord[3]/12
	iv = chord[4]/12
	
	--output the chord
	output[1].volts = (v + i)
	output[2].volts = (v + ii)
	output[3].volts = (v + iii)
	output[4].volts = (v + iv)
end