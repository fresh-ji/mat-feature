
% clear all ;clc
% 这里模拟C往这里发了数据 实际情况C每次往workspace里发的数据都不一样 
runStage = evalin('base','runStage'); 
if runStage == 1
% value1 = 1; % 0312 0923 将value1 通过C那里传进来参数
% funcname = 'test0301';

%用于测试eval写法 逗号 ','来加上
% i =3 
% eval(['zeros(',num2str(i),',',num2str(i),')']);

% initial codition
value = 1; 

FixedStep = 0.1;
StopTime = 1;
assignin('base','StopTime',StopTime);
assignin('base','FixedStep',FixedStep);
% set_param('test0301','SolverType','Fixed-step','Solver','FixedStepDiscrete', ...
%     'FixedStep','0.1','StopTime','40');
% 使用eval ',' 加逗号 函数每个输入参数中间加 ,',',' 如果输入为字符 需要增加 ' 在前后的'左右两边增加 '' 
% 各种对奇括号和逗号 这里可以尝试用程序自动执行完 
% ['set_param(',funcname,',','StopTime',',',num2str(StopTime),')']
funcname = evalin('base','funcname'); 
open(funcname); % 下面set_param在simulink关闭时无法运行 这里加一句才能保证下面的能运行 0312 1050
pause(0.1);
eval(['set_param(''',funcname,''',','''StopTime''',',''',num2str(StopTime),... 
    ''',','''FixedStep''',',''',num2str(FixedStep), ''')'])
set_param('test0301/Constant','Value',num2str(value));
set_param('test0301','SimulationCommand','start'); % 在这里实际上也是接受函数名字 后续要更改
set_param('test0301','SimulationCommand','pause');
pause(0.1);

elseif runStage == 2
set_param('test0301/Constant','Value',num2str(value));
set_param('test0301','SimulationCommand','step');
set_param('test0301','SimulationCommand','pause');
pause(0.2);
yout = evalin('base','yout'); 
result = yout.get(1).Values.Data;
changdu = max(size(result));
result = result(changdu);
disp(['result is ',num2str(result)]);
assignin('base','result',result);
elseif  runStage == 3 
    
set_param('test0301','SimulationCommand','stop');
disp('finish');
% result = yout.get(1).Values.Data;
% changdu = max(size(result));
% result = result(changdu); % 要step一步后有了长度再result
% result % 0312 0923 通过打印让C能够接受到返回值

end 