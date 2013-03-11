function varargout = nProcessor(varargin)
% NPROCESSOR M-file for nProcessor.fig
%      NPROCESSOR, by itself, creates a new NPROCESSOR or raises the existing
%      singleton*.
%
%      H = NPROCESSOR returns the handle to a new NPROCESSOR or the handle to
%      the existing singleton*.
%
%      NPROCESSOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NPROCESSOR.M with the given input arguments.
%
%      NPROCESSOR('Property','Value',...) creates a new NPROCESSOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nProcessor_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nProcessor_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nProcessor

% Last Modified by GUIDE v2.5 07-Sep-2010 00:39:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nProcessor_OpeningFcn, ...
                   'gui_OutputFcn',  @nProcessor_OutputFcn, ...
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


% --- Executes just before nProcessor is made visible.
function nProcessor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nProcessor (see VARARGIN)

% Choose default command line output for nProcessor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nProcessor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nProcessor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function out(handles, text)
% Writes output log value.
    
    prevText = get(handles.outBox, 'String');
    newText = strvcat(prevText, text);
    set(handles.outBox, 'String', newText);   
    set(handles.outBox, 'Value', size(newText, 1) );
    
    
function clearModel(modelHandle)
 
    for h = modelHandle
        try
            delete(h);
        catch
        end;     
    end;
    hold on;
        
function modelHandle = guiDrawModel(handles, pts, ptSize)      
        
        try            

            modelHandle = scatter3(pts(:,1), pts(:,2), pts(:,3), ...
                ptSize*ones(size(pts,1),1), pts(:,3), 'filled' );
            
        catch exception
             out(handles, ['Rendering model failure: ' exception.message]);
             rethrow(exception);
        end;      

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts ptsHandle;

    [FileName, PathName] = uigetfile('*.*', 'Select RAW 3d Model');
    if (FileName ~= 0)
        try            
           out(handles, '[Raw data loading] Loading... ');
            
            pts = ioLoad3dData([PathName FileName]);         
            %pts = pts( randperm( size(pts,1) ), :);
            
            [neigborhoodRadius ptsDensity] = estimatePCANeighborhoodRadius(pts);
            estimatedArea = size(pts,1) / ptsDensity;            
            
            out(handles, [ '[Raw data loading] ' num2str( size(pts,1) ) ' points from ' FileName ' have been read.' ]);
            out(handles, [ '[Raw data loading] Density of points over unit area:' num2str(ptsDensity) ', estimated area: ' num2str(estimatedArea) ]);
            out(handles, [ '[Raw data loading] Suggested neighborhood radius for normal vectors estimation:' num2str(neigborhoodRadius) '.' ]);
            
            clearModel(ptsHandle);
            ptsHandle = guiDrawModel(handles, pts, 1);                
        catch exception
             out(handles, ['[Raw data loading] Error: ' exception.message]);
             rethrow(exception);
        end;
    end;    


% --- Executes on button press in preCheckBox.
function preCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to preCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of preCheckBox


% --- Executes on button press in faceCheckBox.
function faceCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to faceCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of faceCheckBox


% --- Executes on button press in noseCheckBox.
function noseCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to noseCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of noseCheckBox


% --- Executes on button press in ptsDetectionCheckBox.
function ptsDetectionCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to ptsDetectionCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ptsDetectionCheckBox


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pts ptsHandle faceSegmentPts;
global face_Mask center_FaceMask nose_FaceMask noseNear_FaceMask ... 
          leftNose_FaceMask rightNose_FaceMask ...
          prn_FaceMask n_FaceMask sn_FaceMask lal_FaceMask ral_FaceMask ...
          prn n sn lal ral costs t;

out(handles, '[Analysis] -------New analyse started--------');

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%PREPROCESSING:
    
    if get(handles.preCheckBox, 'Value')
        try           
            out(handles, ['[Preprocessing] Preprocessing ran on ' ...
                num2str( size(pts,1) ) ' points.']);
    
            tic;
            [pts faceCost faceMatchingCosts optimalMaxDistanceCoeff ...
            removedToSmall neigborhoodRadius] = modelPreprocessing(pts); 
            time = toc;

            out(handles, ['[Preprocessing] Selected ' num2str(size(pts,1)) ...
                ' pts, faceCost=' num2str(faceCost) ]);
            out(handles, ['[Preprocessing] Dc=' ...
                num2str(optimalMaxDistanceCoeff) ' Removed pts =' ...
                num2str(removedToSmall) ]);
            out(handles, ['[Preprocessing] Time = ' num2str(time) 's']);
            
            clearModel(ptsHandle);
            ptsHandle = guiDrawModel(handles, pts, 3);
        catch e
            out(handles, ['[Preprocessing] Error: ' e.message]);
            rethrow(exception);
        end;
    end;
    faceSegmentPts = pts;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%ANALIZA:

%czasy wykonania:
t = ones(10, 1) * inf;
%koszty przypisania
costs = ones(7, 1) * inf;
%wyniki
success = ones(7,1);

if get(handles.faceCheckBox, 'Value')
    
    try
        out(handles, ['[Face detection] Face detection ran on ' num2str(size(pts,1)) ...
            ' points.']);

        tic;
        [subPts bgPts,  fgSeedPts, bgSeedPts, ...
        hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts ...
        costs(1) face_Mask] = findFace(pts);
        facePts = subPts;
        if size(subPts, 1) <= 0
             out(handles, '[Face localization failure] Face not found. ');
             success(1) = 0;
        end;    
        time = toc;    
        t(1) = time;

        out(handles, ['[Face detection] Selected ' num2str(size(facePts,1)) ...
                    ' pts, matchingCost=' num2str(costs(1)) ]);
        out(handles, ['[Face detection] Time = ' num2str(time) 's']);

        clearModel(ptsHandle);
        ptsHandle = guiDrawModel(handles, facePts, 3);
    catch e
        out(handles, ['[Error]' '[Face localization error] ' e.message '']);

        success(1) = 0;
        face_Mask = logical( ones( size(pts,1), 1) );
        facePts = pts;      
    end;       

    %-----------

    try
        tic;
        [faceCenterPts center_FaceMask] = centerAreaFilter(facePts, 70);
        time = toc;    
        t(2) = time;
    catch e
        out(handles, ['[Error]' '[Face center localization error] ' e.message '']);   

        center_FaceMask = face_Mask;
        faceCenterPts = facePts;    
    end;
    
else
        out(handles, '[Analysis] Using defaults for face.');
    
        face_Mask = logical( ones( size(pts,1), 1) );
        facePts = pts;    
        
        center_FaceMask = face_Mask;
        faceCenterPts = facePts;  
end;
    
%-----------------------------------

if get(handles. noseCheckBox, 'Value')
    
    try
        out(handles, ['[Nose detection] Nose detection ran on ' ...
            num2str(sum(center_FaceMask)) ' points.']);

        tic;
        [subPts bgPts,  fgSeedPts, bgSeedPts, ...
        hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts ... 
        costs(2) nose_FaceMask] = findNose(facePts, center_FaceMask);
        nosePts = subPts;
        if size(subPts, 1) <= 0
             out(handles, '[Nose localization failure] Not found. ')
             success(2) = 0;
        end;   
        time = toc;    
        t(3) = time;

        out(handles, ['[Nose detection] Selected ' num2str(size(nosePts,1)) ...
                    ' pts, matchingCost=' num2str(costs(2)) ]);
        out(handles, ['[Nose detection] Time = ' num2str(time) 's']);    

        clearModel(ptsHandle);
        ptsHandle(1) = guiDrawModel(handles, facePts, 1);
        ptsHandle(2) = guiDrawModel(handles, nosePts, 3);
    catch e
        out(handles, ['[Error]' '[Nose localization error] ' e.message '']);  

        success(2) = 0;    
        nose_FaceMask = center_FaceMask;
        nosePts = faceCenterPts;
    end;    

    %------

    if  costs(2) < 15
        out(handles, '[Nose detection] Nose found. ');
        %noseFoundFlag = true;
    else
        out(handles, '[Nose detection] Nose not found. ');
        %noseFoundFlag = false;
    end;    

    %-----------

    try
        tic;
        [noseNearPts bgPts noseNear_FaceMask] = distanceClassify(facePts, nosePts, 6);
        time = toc;
        t(4) = time;

    catch e
        out(handles, ['[Error]' '[Nose correction error] ' e.message '']);  

        noseNear_FaceMask = nose_FaceMask;
        noseNearPts = nosePts;
    end;  
    
else
        out(handles, '[Analysis] Using defaults for nose.');
    
        nose_FaceMask = center_FaceMask;
        nosePts = faceCenterPts;
    
        noseNear_FaceMask = nose_FaceMask;
        noseNearPts = nosePts;
end;    
%-----------------------------------

if get(handles. ptsDetectionCheckBox, 'Value')

    try
        out(handles, ['[Prn detection] Prn detection ran on ' ...
            num2str(sum(noseNear_FaceMask)) ' points.']);

        tic;
        [subPts bgPts,  fgSeedPts, bgSeedPts, ...
        hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  ...
        costs(3) prn_FaceMask] = findPoint(facePts, noseNear_FaceMask, 1);
        prnPts = subPts;
        if size(subPts, 1) <= 0
             out(handles, '[Prn localization failure] Not found. ')
             success(3) = 0;
        end;  
        time = toc;    
        t(5) = time;

        out(handles, ['[Prn detection] Selected ' num2str(size(subPts,1)) ...
                    ' pts, matchingCost=' num2str(costs(3)) ]);
        out(handles, ['[Prn detection] Time = ' num2str(time) 's']);

        clearModel(ptsHandle);
        ptsHandle(1) = guiDrawModel(handles, facePts, 1);
        ptsHandle(2) = guiDrawModel(handles, prnPts, 3);
    catch e
        out(handles, ['[Error]' '[Prn localization error] ' e.message '']);

        success(3) = 0;
        prn_FaceMask = noseNear_FaceMask;
        prnPts = noseNearPts;    
    end;    
    prn = mean(prnPts);

    try
        out(handles, ['[Nasion detection] Nasion detection ran on ' ...
            num2str(sum(noseNear_FaceMask)) ' points.']);

        tic;
        [subPts bgPts,  fgSeedPts, bgSeedPts, ...
        hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  ...
        costs(4) n_FaceMask] = findPoint(facePts, noseNear_FaceMask, 2);
        nPts = subPts;
        if size(subPts, 1) <= 0
             out(handles, '[Nasion localization failure] Not found. ')
             success(4) = 0;
        end;       
        time = toc;    
        t(6) = time;    

        out(handles, ['[Nasion detection] Selected ' num2str(size(subPts,1)) ...
                    ' pts, matchingCost=' num2str(costs(4)) ]);
        out(handles, ['[Nasion detection] Time = ' num2str(time) 's']);

        clearModel(ptsHandle);
        ptsHandle(1) = guiDrawModel(handles, facePts, 1);
        ptsHandle(2) = guiDrawModel(handles, prnPts, 3);
        ptsHandle(3) = guiDrawModel(handles, nPts, 3);
    catch e
         out(handles, ['[Error]' '[Nasion localization error] ' e.message '']);

         success(4) = 0;
        n_FaceMask = noseNear_FaceMask;
        nPts = noseNearPts;  
    end;    
    n = mean(nPts);

    try
       out(handles, ['[Subnaasale detection] Subnaasale detection ran on ' ...
            num2str(sum(noseNear_FaceMask)) ' points.']);

        tic;
        [subPts bgPts,  fgSeedPts, bgSeedPts, ...
        hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  ...
        costs(5) sn_FaceMask] = findPoint(facePts, noseNear_FaceMask, 5);
        snPts = subPts;
        if size(subPts, 1) <= 0
             out(handles, '[Subnaasale localization failure] Not found. ')
             success(5) = 0;
        end;       
        time = toc;
        t(7) = time;

        sn = mean(snPts);

        out(handles, ['[Subnaasale detection] Selected ' num2str(size(subPts,1)) ...
                    ' pts, matchingCost=' num2str(costs(5)) ]);
        out(handles, ['[Subnaasale detection] Time = ' num2str(time) 's']);

        clearModel(ptsHandle);
        ptsHandle(1) = guiDrawModel(handles, facePts, 1);
        ptsHandle(2) = guiDrawModel(handles, prnPts, 3);
        ptsHandle(3) = guiDrawModel(handles, nPts, 3);
        ptsHandle(4) = guiDrawModel(handles, snPts, 3);
    catch e
        out(handles, ['[Error]' '[Subnaasale localization error] ' e.message '']);

        success(5) = 0;
        sn_FaceMask = noseNear_FaceMask;
        snPts = noseNearPts;  
        sn = mean(snPts);
    end;    

    % jakakolwiek lokalizacja sn jest wa¿na w procesie dzielenia przy lal i ral
    if isnan(sn)
        out(handles, '[Fixing sn coordinates] ');
        sn = mean(snPts);
    end;    

    %--------------------------------------------------------------------------

    try
        tic;

        %Poszerzenie obszaru nosa:
        [noseDNearPts bgPts noseDNear_FaceMask] = distanceClassify(facePts, nosePts, 7);

        %Podzielenie nosa na lew¹ i praw¹ czêœæ:
        left_DNoseMask      = splitByPlane(noseDNearPts,  n, sn, prn);
        %leftNoseNearPts     = noseDNearPts(left_DNoseMask, :);
        %rightNoseNearPts	= noseDNearPts(~left_DNoseMask, :);

        %Aktualizacja masek:
        leftNose_FaceMask = doubleMask(noseDNear_FaceMask, left_DNoseMask);
        rightNose_FaceMask = doubleMask(noseDNear_FaceMask, ~left_DNoseMask); 

        time = toc;
        t(8) = time;

    catch e
         out(handles, ['[Error]' '[Nose splitting error] ' e.message '']);

         leftNose_FaceMask = noseNear_FaceMask;
         rightNose_FaceMask = noseNear_FaceMask;
    end;    

    %-------------------------------------------------------------------------

    try
        out(handles, ['[Left alare detection] Left alare detection ran on ' ...
            num2str(sum(leftNose_FaceMask>0)) ' points.']);

        tic;
        [subPts bgPts,  fgSeedPts, bgSeedPts, ...
        hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts  ...
        costs(6) lal_FaceMask] = findPoint(facePts, leftNose_FaceMask, 3);
        lalPts = subPts;
        if size(subPts, 1) <= 0
             out(handles, '[Left alare localization failure] Not found. ')
             success(6) = 0;
        end;     
        time = toc;    
        t(9) = time;


        out(handles, ['[Left alare detection] Selected ' num2str(size(subPts,1)) ...
                    ' pts, matchingCost=' num2str(costs(6)) ]);
        out(handles, ['[Left alare detection] Time = ' num2str(time) 's']);

        clearModel(ptsHandle);
        ptsHandle(1) = guiDrawModel(handles, facePts, 1);
        ptsHandle(2) = guiDrawModel(handles, prnPts, 3);
        ptsHandle(3) = guiDrawModel(handles, nPts, 3);
        ptsHandle(4) = guiDrawModel(handles, snPts, 3);
        ptsHandle(5) = guiDrawModel(handles, lalPts, 3);    
    catch e
         out(handles, ['[Error]' '[Left alare localization error] ' e.message '']);

         success(6) = 0;
        lal_FaceMask = noseNear_FaceMask;
        lalPts = noseNearPts;  
    end;   
    lal = mean(lalPts);

    try
       out(handles, ['[Right alare detection] Right alare detection ran on ' ...
            num2str(sum(rightNose_FaceMask>0)) ' points.']);

        tic;
        [subPts bgPts,  fgSeedPts, bgSeedPts, ...
        hBgSeedPts hBgSeedBadPts hFaceSeedPts hFaceSeedBadPts ...
        costs(7) ral_FaceMask] = findPoint(facePts, rightNose_FaceMask, 4);
        ralPts = subPts;
        if size(subPts, 1) <= 0
             out(handles, '[Right alare localization failure] Not found. ')
             success(7) = 0;
        end;     
        time = toc;
        t(10) = time;

        out(handles, ['[Right alare detection] Selected ' num2str(size(subPts,1)) ...
                    ' pts, matchingCost=' num2str(costs(7)) ]);
        out(handles, ['[Right alare detection] Time = ' num2str(time) 's']);    

        clearModel(ptsHandle);
        ptsHandle(1) = guiDrawModel(handles, facePts, 1);
        ptsHandle(2) = guiDrawModel(handles, prnPts, 3);
        ptsHandle(3) = guiDrawModel(handles, nPts, 3);
        ptsHandle(4) = guiDrawModel(handles, snPts, 3);
        ptsHandle(5) = guiDrawModel(handles, lalPts, 3);  
        ptsHandle(6) = guiDrawModel(handles, ralPts, 3);      
    catch e
        out(handles, ['[Error]' '[Right alare localization error] ' e.message '']);

        success(7) = 0;
        ral_FaceMask = noseNear_FaceMask;
        ralPts = noseNearPts;  
    end;    
    ral = mean(ralPts);
    
else        
        out(handles, '[Analysis] Using defaults for characteristic points.');
    
        prn_FaceMask = noseNear_FaceMask;
        prnPts = noseNearPts;    
		prn = mean(prnPts);
		
		n_FaceMask = noseNear_FaceMask;
        nPts = noseNearPts;  
		n = mean(nPts);
		
		sn_FaceMask = noseNear_FaceMask;
        snPts = noseNearPts;  
        sn = mean(snPts);
		
		leftNose_FaceMask = noseNear_FaceMask;
        rightNose_FaceMask = noseNear_FaceMask;
		
		lal_FaceMask = noseNear_FaceMask;
        lalPts = noseNearPts;  
		lal = mean(lalPts);
		
		ral_FaceMask = noseNear_FaceMask;
        ralPts = noseNearPts;  
		ral = mean(ralPts);    
end;    

success = logical(success);

%-------------------------------------------------------------------------
%PODSUMOWANIE:
out(handles, ['[Analyse results] phase results:'  num2str(success')]);
out(handles, ['[Analyse results] time (s):'  num2str(t', 2)]);
out(handles, ['[Analyse results] Prn coords:'  num2str(prn)]);
out(handles, ['[Analyse results] Nasion coords:'  num2str(n)]);
out(handles, ['[Analyse results] Sn coords:'  num2str(sn)]);
out(handles, ['[Analyse results] Left alare coords:'  num2str(lal)]);
out(handles, ['[Analyse results] Right alare coords:'  num2str(ral)]);

% --- Executes on selection change in outBox.
function outBox_Callback(hObject, eventdata, handles)
% hObject    handle to outBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns outBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outBox


% --- Executes during object creation, after setting all properties.
function outBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.outBox, 'String', '');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    try        
        [FileName, PathName] = uiputfile('*.png', 'Enter image file to be stored');
        if (FileName ~= 0)
            f = getframe;
            imwrite(f.cdata, [PathName FileName]);
            out(handles, ['[Saving snapshot] Stored to ' [PathName FileName] '.']);
        end;
    catch exception
        out(handles, ['[Saving snapshot] Error: ' exception.message]);
        rethrow(exception);
    end;  


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pts ptsHandle faceSegmentPts;
global face_Mask center_FaceMask nose_FaceMask noseNear_FaceMask ... 
          leftNose_FaceMask rightNose_FaceMask ...
          prn_FaceMask n_FaceMask sn_FaceMask lal_FaceMask ral_FaceMask ...
          prn n sn lal ral costs t;

    [FileName, PathName] = uiputfile('*.txt', 'Write effects of analysis');
    if (FileName ~= 0)
        try            

             out(handles, '[Effects of preprocessing] Storing... ');
            
          ioStoreAnalysisResults([PathName FileName], ...
          face_Mask, center_FaceMask, nose_FaceMask, noseNear_FaceMask, ... 
          leftNose_FaceMask, rightNose_FaceMask, ...
          prn_FaceMask, n_FaceMask, sn_FaceMask, lal_FaceMask, ral_FaceMask, ...
          prn, n, sn, lal, ral, ...
          costs, t)
                       
            out(handles, ['[Effects of preprocessing] Analysis results stored to ' [PathName FileName]]);        
        catch exception
             out(handles, ['[Effects of preprocessing] Error: ' exception.message]);
             rethrow(exception);
        end;
    end; 


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.outBox, 'String', '');
out(handles, '[nProcessor] Author: Tomasz Kusmierczyk, krotny@gmail.com');
out(handles, '[nProcessor] Functionality: ');
out(handles, '[nProcessor]  - data filtering');
out(handles, '[nProcessor]  - face detection ');
out(handles, '[nProcessor]  - nose detection');
out(handles, '[nProcessor]  - nose characteristic points detection');

