
function processByMatlab(pattern, param1, param2, param3)
if(strcmp('init', pattern))
    disp('init come')
    assignin('base', 'startTime', param1)
    assignin('base', 'step', param2)
end
if(strcmp('data', pattern))
    disp('data come')
end
if(strcmp('push', pattern))
    disp('push come')
end
end