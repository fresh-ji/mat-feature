
% clear all ;clc
% ����ģ��C�����﷢������ ʵ�����Cÿ����workspace�﷢�����ݶ���һ�� 
runStage = evalin('base','runStage'); 
if runStage == 1
% value1 = 1; % 0312 0923 ��value1 ͨ��C���ﴫ��������
% funcname = 'test0301';

%���ڲ���evalд�� ���� ','������
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
% ʹ��eval ',' �Ӷ��� ����ÿ����������м�� ,',',' �������Ϊ�ַ� ��Ҫ���� ' ��ǰ���'������������ '' 
% ���ֶ������źͶ��� ������Գ����ó����Զ�ִ���� 
% ['set_param(',funcname,',','StopTime',',',num2str(StopTime),')']
funcname = evalin('base','funcname'); 
open(funcname); % ����set_param��simulink�ر�ʱ�޷����� �����һ����ܱ�֤����������� 0312 1050
pause(0.1);
eval(['set_param(''',funcname,''',','''StopTime''',',''',num2str(StopTime),... 
    ''',','''FixedStep''',',''',num2str(FixedStep), ''')'])
set_param('test0301/Constant','Value',num2str(value));
set_param('test0301','SimulationCommand','start'); % ������ʵ����Ҳ�ǽ��ܺ������� ����Ҫ����
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
% result = result(changdu); % Ҫstepһ�������˳�����result
% result % 0312 0923 ͨ����ӡ��C�ܹ����ܵ�����ֵ

end 