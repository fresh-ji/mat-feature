
function processByMatlab(pattern, param1, param2, param3)
if(strcmp('init', pattern))
    assignin('base', 'startTime', param1)
    assignin('base', 'step', param2)
    disp('[INFO] start time and step saved to workspace')
end
if(strcmp('data', pattern))
    % ---收到数据---
    disp('[INFO] data come : ')
    disp('time : ')
    disp(param1)
    disp('name : ')
    disp(param2)
    disp('content : ')
    disp(param3)
end
if(strcmp('push', pattern))
    % ---收到步进指令---
    disp('[INFO] push come')
end
end