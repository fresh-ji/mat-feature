function varargout = dllMexFunGuide(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dllMexFunGuide_OpeningFcn, ...
                   'gui_OutputFcn',  @dllMexFunGuide_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before dllMexFunGuide is made visible.
function dllMexFunGuide_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dllMexFunGuide (see VARARGIN)

% Choose default command line output for dllMexFunGuide
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dllMexFunGuide wait for user response (see UIRESUME)
% uiwait(handles.figure1);
clear all ;clc

% --- Outputs from this function are returned to the command line.
function varargout = dllMexFunGuide_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in s1r1.
function s1r1_Callback(hObject, eventdata, handles)
% hObject    handle to s1r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of s1r1



function s1e1_Callback(hObject, eventdata, handles)
% hObject    handle to s1e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of s1e1 as text
%        str2double(get(hObject,'String')) returns contents of s1e1 as a double


% --- Executes during object creation, after setting all properties.
function s1e1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s1e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on s1r1 and none of its controls.
function s1r1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to s1r1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in s1c1.
function s1c1_Callback(hObject, eventdata, handles)
% hObject    handle to s1c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag1;
if(get(hObject,'Value')==1)
    msg = dllMexFun200119(1);
    if(msg == 1)
        set(handles.s1e1,'String','成功加载链接');
        set(handles.s1t1,'BackgroundColor','Green');
        disp('step receive mex back msg ');
        flag1 = 1;
    end
    if(msg == 0)
        set(handles.s1e1,'String','链接库加载失败');
        set(handles.s1t1,'BackgroundColor','Red');
        set(hObject,'Value',0);
        flag1 = 0;
    end
else
    set(handles.s1e1,'String','');
    set(handles.s1t1,'BackgroundColor','Red');
end


% set(s1e1,'value','成功加载链接库');

% Hint: get(hObject,'Value') returns toggle state of s1c1


% --- Executes on key press with focus on s1c1 and none of its controls.
function s1c1_KeyPressFcn(hObject, eventdata, handles)

disp('hallo');


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear dllMexFun1023;
disp('delete');


% --- Executes on button press in s3c1.
function s3c1_Callback(hObject, eventdata, handles)
% judge = evalin('base','varname'); 想从base里拿数据
% hObject    handle to s3c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of s3c1
global flag1;
global flag2;
if(flag2 == 0)
    set(handles.s3e1,'String','请先完成前两部操作');
    set(hObject,'Value',0); 
    return;
end
if(get(hObject,'Value') == 1)
    set(handles.s3t1,'BackgroundColor','Green');
    disp('simulation begin');
    assignin('base','runStage',1);
    pause(0.1);
    run0310;
    pause(0.1);
    %
    % assignin('base','runStage',1);
    StopTime = evalin('base','StopTime'); 
    FixedStep = evalin('base','FixedStep'); 
    
    a = dllMexFun200119(0,FixedStep);
    if(a == 2)
        disp('initTool success back msg');
    end
    
    assignin('base','runStage',2);
    

    for i = 0:FixedStep:StopTime
        run0310;
        result = evalin('base','result'); 
        set(handles.s3e1,'String',num2str(result));
        
        sig = 0;
        sig = dllMexFun200119(i,1,'result',result);
        if(sig ~=2 )
            disp('not success call dllMexFunc during simulation')
        end
        
        pause(0.1);
    end
    
    assignin('base','runStage',3);
    set_param('test0301','SimulationCommand','stop');
    
    sig =0;
    sig = dllMexFun200119(StopTime,2);
    if(sig ~=2 )
        disp('not success call dllMexFunc when simulation end')
    end
    
    disp('simulation end');

    % 再崩溃就注释了 0318 1104
    dllMexFun200119();
    
else 
    set(handles.s3e1,'String','');
    set(handles.s3t1,'BackgroundColor','Red');
end


function s3e1_Callback(hObject, eventdata, handles)
% hObject    handle to s3e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of s3e1 as text
%        str2double(get(hObject,'String')) returns contents of s3e1 as a double


% --- Executes during object creation, after setting all properties.
function s3e1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s3e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function s2e1_Callback(hObject, eventdata, handles)
% hObject    handle to s2e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of s2e1 as text
%        str2double(get(hObject,'String')) returns contents of s2e1 as a double


% --- Executes during object creation, after setting all properties.
function s2e1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s2e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function s2e2_Callback(hObject, eventdata, handles)
% hObject    handle to s2e2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of s2e2 as text
%        str2double(get(hObject,'String')) returns contents of s2e2 as a double


% --- Executes during object creation, after setting all properties.
function s2e2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s2e2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in s2c1.
function s2c1_Callback(hObject, eventdata, handles)
% hObject    handle to s2c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag1;
global flag2;
if(flag1 == 0)
    set(handles.s2e2,'String','请先进行步骤 1');
    set(hObject,'Value',0);
    return;
end
if(get(hObject,'Value') == 1 && flag1 == 1)
    % disp('success in s2 ');
    funMsg = get(handles.s2e1,'String');
    disp(funMsg);
    if exist(funMsg,'file')==0
        set(handles.s2e2,'String','模型不存在 请进行检查');
        set(handles.s2t1,'BackgroundColor','Red');
        flag2 = 0;
        set(hObject,'Value',0);
    else
        set(handles.s2e2,'String','模型存在可以进行仿真');
        set(handles.s2t1,'BackgroundColor','Green');
        assignin('base','funcname',funMsg);
        flag2 = 1;
    end
%     if(strcmp(funMsg,'atmosphereModel'))
%     else
%     end
end
% Hint: get(hObject,'Value') returns toggle state of s2c1


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global flag1;
global flag2;
global flag3;
flag1 = 0;
flag2 = 0;
flag3 = 0;
