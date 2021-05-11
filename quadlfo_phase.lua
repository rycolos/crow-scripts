--Output 1 - 0
--Output 2 - 45
--Output 3 - 90
--Output 4 - 180

speed = 5
lvl = 10
shapes = 'expo'

delay(function() output[1](lfo(speed, lvl, shapes)) end, 1, 1)
delay(function() output[2](lfo(speed, lvl, shapes)) end, 1.25, 1)
delay(function() output[3](lfo(speed, lvl, shapes)) end, 1.5, 1)
delay(function() output[4](lfo(speed, lvl, shapes)) end, 1.75, 1)