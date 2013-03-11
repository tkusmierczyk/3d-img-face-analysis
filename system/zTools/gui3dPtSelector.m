function varargout = gui3dPtSelector(varargin)
% GUI3DPTSELECTOR M-file for gui3dPtSelector.fig
%      GUI3DPTSELECTOR, by itself, creates a new GUI3DPTSELECTOR or raises the existing
%      singleton*.
%
%      H = GUI3DPTSELECTOR returns the handle to a new GUI3DPTSELECTOR or the handle to
%      the existing singleton*.
%
%      GUI3DPTSELECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI3DPTSELECTOR.M with the given input arguments.
%
%      GUI3DPTSELECTOR('Property','Value',...) creates a new GUI3DPTSELECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs
%      are
%      applied to the GUI before gui3dPtSelector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui3dPtSelector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui3dPtSelector

% Last Modified by GUIDE v2.5 13-Aug-2010 14:08:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui3dPtSelector_OpeningFcn, ...
                   'gui_OutputFcn',  @gui3dPtSelector_OutputFcn, ...
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


% --- Executes just before gui3dPtSelector is made visible.
function gui3dPtSelector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui3dPtSelector (see VARARGIN)

% Choose default command line output for gui3dPtSelector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui3dPtSelector wait for user response (see UIRESUME)
% uiwait(handles.mainWindow);

global x y z step ptSize;
 x= 0;
 y=0;
 z = 0;
 ptSize = 3;
 step = 1;


% --- Outputs from this function are returned to the command line.
function varargout = gui3dPtSelector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function guiDrawModel(handles)

        global pts modelHandle ptSize inv;

        try
            delete(modelHandle);
        catch
        end;               
            
        hold on;  
        xlabel('x');ylabel('y');zlabel('z');
        
        if inv 
        modelHandle = scatter3(pts(:,1), pts(:,2), pts(:,3), ...
                        ptSize*ones(size(pts,1),1), pts(:,1), 'filled' );            
        else
        modelHandle = scatter3(pts(:,1), pts(:,2), pts(:,3), ...
                        ptSize*ones(size(pts,1),1), pts(:,3), 'filled' );            
        end;

                    
                    
function guiDrawActivePoint(handles)
        
    global x y z ptSize aPtMarkerHandle;
        
    try

            
            %coordinates:
            s = 25;
            xPos = [x-s x+s    x   x      x   x        x-s  x+s     x+s  x-s   x x       x-s x+s  ];
            yPos = [y   y      y-s y+s    y   y        y-s  y+s     y-s  y+s   y-s y+s   y   y  ];
            zPos = [z   z      z   z      z-s z+s      z    z       z    z     z-s z+s   z-s z+s    ];

            %redraw:
            try
                delete(aPtMarkerHandle(1));        
            catch
            end;
            try
                delete(aPtMarkerHandle(2));        
            catch
            end;
            try
                delete(aPtMarkerHandle(3));        
            catch
            end;
            try
                delete(aPtMarkerHandle(4));        
            catch
            end;
            try
                delete(aPtMarkerHandle(5));        
            catch
            end;
            try
                delete(aPtMarkerHandle(6));        
            catch
            end;
            try
                delete(aPtMarkerHandle(7));        
            catch
            end;
      
            
            aPtMarkerHandle(1) = line(xPos([1 2]), yPos([1 2]), zPos([1 2]), 'Color','r');       
            aPtMarkerHandle(2) = line(xPos([3 4]), yPos([3 4]), zPos([3 4]), 'Color','g');       
            aPtMarkerHandle(3) = line(xPos([5 6]), yPos([5 6]), zPos([5 6]), 'Color','b'); 
            
            aPtMarkerHandle(4) = line(xPos([7 8]), yPos([7 8]), zPos([7 8]), 'Color','m'); 
            aPtMarkerHandle(5) = line(xPos([9 10]), yPos([9 10]), zPos([9 10]), 'Color','g'); 
            aPtMarkerHandle(6) = line(xPos([11 12]), yPos([11 12]), zPos([11 12]), 'Color','b'); 
            aPtMarkerHandle(7) = line(xPos([13 14]), yPos([13 14]), zPos([13 14]), 'Color','r');            
            
            set(handles.posLabel, 'String', [ num2str(x) '  ' num2str(y) '  ' num2str(z)]);
            
        
    catch exception
        rethrow(exception);
    end;                            

% --- Executes on button press in openRawFile.
function openRawFile_Callback(hObject, eventdata, handles)
% hObject    handle to openRawFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts ptSize step x y z inv;

    [FileName, PathName] = uigetfile('*.*', 'Select RAW 3d Model');
    if (FileName ~= 0)      
        
        inv = false;
        ptSize = 3;
        step = 1;
        
        pts = ioLoad3dData([PathName FileName]);    
        
        ms = mean(pts);
        x = ms(1);
        y = ms(2);
        z = ms(3);
        
        fprintf('min: max:\n %.4f %.4f\n', min(pts), max(pts));
        guiDrawModel(handles);            
        guiDrawActivePoint(handles);
    end;
    
    


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global ptSize;
    ptSize = ptSize * 2;
    fprintf('ptSize=%.4f\n', ptSize);
       guiDrawModel(handles);    


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global ptSize;
    ptSize = ptSize / 2;
        fprintf('ptSize=%.4f\n', ptSize);
       guiDrawModel(handles);    


% --- Executes on key press with focus on mainWindow or any of its controls.
function mainWindow_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to mainWindow (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

global step x y z;

switch eventdata.Key
    case 'd'
        x = x + step;
    case 'a'
        x = x - step;
    case 's'
        y = y - step;
    case 'w'
        y = y + step;
    case 'q'
        z = z - step;
    case 'e'
        z = z + step;
end;    

guiDrawActivePoint(handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global step;
    step = step * 2;
        fprintf('step=%.4f\n', step);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global step;
    step = step / 2;
        fprintf('step=%.4f\n', step);    


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global x y z pts;
    
    fprintf('pre: x=%.4f x=%.4f x=%.4f\n', x, y, z);
    
    distances = getDistances([x y z], pts);
    [d ix] = min(distances);
    x = pts(ix, 1);
    y = pts(ix, 2);
    z = pts(ix, 3);
    
    fprintf('post: x=%.4f x=%.4f x=%.4f\n', x, y, z);
    guiDrawActivePoint(handles);
    


% --- Executes on button press in X.
function X_Callback(hObject, eventdata, handles)
% hObject    handle to X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reset(handles.view);




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pts x y z inv; 

    inv = ~inv;

    tmp = pts(:,1);
    pts(:,1) = pts(:,3);
    pts(:,3) = tmp;
    
    tmp = x;
    x = z;
    z = tmp;

    guiDrawActivePoint(handles);
    guiDrawModel(handles); 
        reset(handles.view);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pts x y z;

guiDrawActivePoint(handles);

[mi ix] = max( pts(:,3) );
x = pts(ix, 1);
y = pts(ix, 2);
z = pts(ix, 3);



function posLabel_Callback(hObject, eventdata, handles)
% hObject    handle to posLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posLabel as text
%        str2double(get(hObject,'String')) returns contents of posLabel as a double


% --- Executes during object creation, after setting all properties.
function posLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


