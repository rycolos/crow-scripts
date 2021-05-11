--- digital analog shift register
-- four stages of delay for an incoming cv
-- input 1: cv in
-- input 2: trigger to capture input & shift
-- output 1-4: newest to oldest output

reg = {}
reg_LEN = 4

function init()
    for n=1,4 do
        output[n].slew = 0
    end

    input[1].mode('none')
    input[2]{ mode      = 'change'
            , direction = 'rising'
            }

    for i=1,reg_LEN do --loads voltage into all four buckets at runtime
        reg[i] = input[1].volts
    end
end

function update(r)
    for n=1,4 do
        output[n].volts = math.floor(r[n]*12)/12 --quantized chromatically
        --print('N: ' .. n .. output[n].volts)
    end
end

input[2].change = function()
    capture = input[1].volts
    table.remove(reg) --remove last entry
    table.insert(reg, 1, input[1].volts) --add new entry (in1.volt) to pos 1
    update(reg) -- outputs 1-4 are assigned tables entries 1-4
end


-- Example

--         cl1  cl2    cl3    cl4    cl5    cl6
-- input   1    1.5    1.2    2      1.4    1.1
-- o1      1    1.5    1.2    2      1.4    1.1
-- o2      1    1      1.5    1.2    2      1.4
-- o3      1    1      1      1.5    1.2    2
-- o4      1    1      1      1      1.5    1.2

-- cl1{1, 1, 1, 1}
--     remove last entry (1)
--     insert new entry, present at in 1
--     update and send outputs
-- cl2{1.5, 1, 1, 1}
-- ...
-- cl5{1.4, 2, 1.2, 1.5}

