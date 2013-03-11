function varargout = quark(varargin)
% QUARK M-file for quark.fig
%      QUARK, by itself, creates a new QUARK or raises the existing
%      singleton*.
%
%      H = QUARK returns the handle to a new QUARK or the handle to
%      the existing singleton*.
%
%      QUARK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QUARK.M with the given input arguments.
%
%      QUARK('Property','Value',...) creates a new QUARK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before quark_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to quark_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help quark

% Last Modified by GUIDE v2.5 09-Apr-2009 16:34:21

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @quark_OpeningFcn, ...
                       'gui_OutputFcn',  @quark_OutputFcn, ...
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



% --- Executes just before quark is made visible.
function quark_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to quark (see VARARGIN)

    % Choose default command line output for quark
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes quark wait for user response (see UIRESUME)
    % uiwait(handles.quark);
        
    %My initialization:
       
    try
        cla;
        %set(handles.outBox, 'String', 'Face processor by Tomasz Kusmierczyk');        
    catch 
    end;
    try
        installJava;
    catch 
    end;
    
	global    ptSize ptsDensity meanPtsDistance;
    
    ptSize = 3;
    ptsDensity = 0.5;
    meanPtsDistance = 3;
    panelPos = get(handles.cfgPrePanel, 'Position');
    set(handles.matchingPanel, 'Position', panelPos);
    set(handles.descPanel, 'Position', panelPos);

    

% --- Outputs from this function are returned to the command line.
function varargout = quark_OutputFcn(hObject, eventdata, handles) 
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


function DisableAllPanels(handles)

    set(handles.cfgPrePanel, 'Visible', 'off');
    set(handles.matchingPanel, 'Visible', 'off');   
    set(handles.descPanel, 'Visible', 'off');   
    
    set(handles.matchingButton, 'FontWeight', 'normal');   
    set(handles.cfgPreButton, 'FontWeight', 'normal');   
    set(handles.descButton, 'FontWeight', 'normal');   

% --- Executes on button press in matchingButton.
function matchingButton_Callback(hObject, eventdata, handles)
% hObject    handle to matchingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    DisableAllPanels(handles);
    set(handles.matchingButton, 'FontWeight', 'bold'); 
     set(handles.matchingPanel, 'Visible', 'on');  

% --- Executes on button press in cfgPreButton.
function cfgPreButton_Callback(hObject, eventdata, handles)
% hObject    handle to cfgPreButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   DisableAllPanels(handles);
    set(handles.cfgPreButton, 'FontWeight', 'bold');   
     set(handles.cfgPrePanel, 'Visible', 'on');

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
    

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
           
function guiDrawModel(handles)

        global pts n modelHandle ptSize ptsDensity;

        try
            delete(modelHandle);
        catch
        end;               
        
        try            
            sparseStep = ( size(pts,1) /  (size(pts,1)*ptsDensity) );
            ixs = floor( 1:sparseStep:size(pts,1) );
            
            hold on;
            
            defaultRendering = false;            
            if (get(handles.displayMode, 'Value'))   
                try
                    colormap('Gray');
                    modelHandle = scatter3(pts(ixs,1), pts(ixs,2), pts(ixs,3), ...
                        ptSize*ones(size(ixs,1),1), n(ixs, :)*[1;1;1], 'filled' );
                catch e
                    out(handles, ['Rendering model failure: Check if normal'...
                        ' vectors are calculated']);
                    defaultRendering = true;
                end;
            else
                defaultRendering = true;
            end;
            
            if defaultRendering
                colormap('Default');
                modelHandle = scatter3(pts(ixs,1), pts(ixs,2), pts(ixs,3), ...
                    ptSize*ones(size(ixs,1),1), pts(ixs,3), 'filled' );
            end;
            
        catch exception
             out(handles, ['Rendering model failure: ' exception.message]);
             rethrow(exception);
        end;        
        
        
function guiDrawClusteredModel(handles)

        global pts ptsClusters modelHandle ptSize ptsDensity;

        try
            delete(modelHandle);
        catch
        end;               
        
        try            
            sparseStep = ( size(pts,1) /  (size(pts,1)*ptsDensity) );
            ixs = floor( 1:sparseStep:size(pts,1) );
            
            hold on;
            colormap('Default');
            modelHandle = scatter3(pts(ixs,1), pts(ixs,2), pts(ixs,3), ptSize*ones(size(ixs,1),1), ptsClusters(ixs), 'filled' );
        catch exception
             out(handles, ['Rendering model failure: ' exception.message]);
             rethrow(exception);
        end;  
        

function guiDrawSeedPoints(handles)

        global pts selIxs descPtHandles;
        
        ptSize = 20;
        
        try
            delete(descPtHandles);
        catch
        end;    

        try
            descPtHandles = scatter3(pts(selIxs,1), pts(selIxs,2), pts(selIxs,3), ptSize, 'r', 'filled');       
        catch exception
            out(handles, ['Rendering feature points failure: ' exception.message]);
            rethrow(exception);
        end;       
        
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------      

% --- Executes on button press in loadRawModel.
function loadRawModel_Callback(hObject, eventdata, handles)
% hObject    handle to loadRawModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    global pts;

    [FileName, PathName] = uigetfile('*.*', 'Select RAW 3d Model');
    if (FileName ~= 0)
        try            
            pts = ioLoad3dData([PathName FileName]);         
            %pts = pts( randperm( size(pts,1) ), :);
            
            [neigborhoodRadius ptsDensity] = estimatePCANeighborhoodRadius(pts);
            estimatedArea = size(pts,1) / ptsDensity;
            
            set(handles.neighborhoodRadiusCoeff, 'String', num2str(neigborhoodRadius) );
            set(handles.neighRadiusEdit, 'String', num2str(neigborhoodRadius) );
            
            out(handles, [ '[Raw data loading] ' num2str( size(pts,1) ) ' points from ' FileName ' have been read.' ]);
            out(handles, [ '[Raw data loading] Density of points over unit area:' num2str(ptsDensity) ', estimated area: ' num2str(estimatedArea) ]);
            out(handles, [ '[Raw data loading] Suggested neighborhood radius for normal vectors estimation:' num2str(neigborhoodRadius) '.' ]);
            
            guiDrawModel(handles);            
        catch exception
             out(handles, ['[Raw data loading] Error: ' exception.message]);
             rethrow(exception);
        end;
    end;    


% --- Executes on button press in clusterPointsButton.
function clusterPointsButton_Callback(hObject, eventdata, handles)
% hObject    handle to clusterPointsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts ptsClusters clusterSize clusterCum meanPtsDistance;
    
    try 
        maxDistanceCoeff = str2double( get(handles.maxDistanceCoeffEdit, 'String') );
        out(handles, [ '[Clustering] Neighboorhood coefficient: ' num2str( maxDistanceCoeff ) ]);   
        
        [ptsClusters noOfClusters meanPtsDistance clusteringRadius] = connectionClustering(pts, maxDistanceCoeff);
        [clusterSize clusterCum] = analiseClusters(ptsClusters);
        
        out(handles, [ '[Clustering] Average distance between two neighbors: ' num2str( meanPtsDistance ) '.' ]);
        out(handles, [ '[Clustering] Clustering radius: ' num2str( clusteringRadius ) '.' ]);
        out(handles, [ '[Clustering] ' num2str( noOfClusters ) ' clusters have been created.' ]);
        out(handles, '[Clustering] Clusters:' );
        out(handles, num2str(clusterSize) );                       

        guiDrawClusteredModel(handles);   
        out(handles, '[Clustering] Done.' );
    catch exception
         out(handles, ['[Clustering] Error: ' exception.message]);
         rethrow(exception);
    end;
    



function maxDistanceCoeffEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maxDistanceCoeffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxDistanceCoeffEdit as text
%        str2double(get(hObject,'String')) returns contents of maxDistanceCoeffEdit as a double


% --- Executes during object creation, after setting all properties.
function maxDistanceCoeffEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxDistanceCoeffEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fliterTooSmallClusters.
function fliterTooSmallClusters_Callback(hObject, eventdata, handles)
% hObject    handle to fliterTooSmallClusters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts ptsClusters clusterSize clusterCum;

    try
        minFractionOfPtsInCluster = str2double( get(handles.minFractionOfPtsInClusterEdit, 'String') );
        noOfInPts = size(pts, 1);
        
        [pts ptsClusters] = keepEnoughBigClusters(pts, ptsClusters, clusterSize, minFractionOfPtsInCluster);
        
        noOfOutPts = size(pts, 1); 
        [clusterSize clusterCum] = analiseClusters(ptsClusters);
        
        out(handles, ['[Filtering clusters] ' num2str(noOfInPts-noOfOutPts) ' points removed. ' num2str(noOfOutPts) ' left']);
        out(handles, '[Clustering] Clusters:' );
        out(handles, num2str(clusterSize) );   
        
        guiDrawClusteredModel(handles);     
    catch exception
         out(handles, ['[Filtering clusters] Error: ' exception.message]);
         rethrow(exception);
    end;


function minFractionOfPtsInClusterEdit_Callback(hObject, eventdata, handles)
% hObject    handle to minFractionOfPtsInClusterEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minFractionOfPtsInClusterEdit as text
%        str2double(get(hObject,'String')) returns contents of minFractionOfPtsInClusterEdit as a double


% --- Executes during object creation, after setting all properties.
function minFractionOfPtsInClusterEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minFractionOfPtsInClusterEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in keepTheBiggestClusterButton.
function keepTheBiggestClusterButton_Callback(hObject, eventdata, handles)
% hObject    handle to keepTheBiggestClusterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts ptsClusters;
        
    %for i = 1:100
    try
        %------------------------------------------------------------------
        %
        patternDescFile = ( get(handles.faceDescFileEdit, 'String') );        
        neigborhoodRadius = str2double( get(handles.neighRadiusEdit, 'String') );
        noOfSeedPoints = str2double( get(handles.noOfFeaturePtsEdit, 'String') );
        
        
        %desc params:
        spinDistance = str2double( get(handles.descRadiusEdit, 'String') );
        alfaBins = str2double( get(handles.noOfAlfaBinsEdit, 'String') );
        betaBins = str2double( get(handles.noOfBetaBinsEdit, 'String') );
        
        %matching
        matchingFilterRuleNo = ( get(handles.matchingFilterMenu, 'Value') );
        matchingDistanceTypeNo = ( get(handles.matchingDistanceTypeMenu, 'Value') );
        
        %dep params:
        if matchingFilterRuleNo == 1
            matchingRule = 'OR';
        elseif matchingFilterRuleNo == 2
            matchingRule = 'AND';
        elseif matchingFilterRuleNo == 3    
            matchingRule = 'NONE';            
        else
            error('UNKNOWN ITEM FOR matchingFilterRule !');            
        end;
        
        if matchingDistanceTypeNo == 1
            matchingDistanceType = 1;
        elseif matchingDistanceTypeNo == 2
            matchingDistanceType = 2;
        else
            error('UNKNOWN ITEM FOR matchingDistanceTypeNo !');    
        end;            
        
        alfaAxes = alfaAxeType(handles) ;
        betaAxes = betaAxeType(handles) ;
        
        %patternDescFile, neigborhoodRadius, noOfSeedPoints, spinDistance, alfaBins, betaBins, alfaAxes, betaAxes, matchingRule, matchingDistanceType
        %------------------------------------------------------------------

        [facePatternSpinImgs] = ioRestoreModelDescriptor(patternDescFile);
        [faceClusterNo faceMatchingCosts] = findPatternCluster(pts, ptsClusters, facePatternSpinImgs, noOfSeedPoints, neigborhoodRadius, spinDistance, alfaBins, betaBins, alfaAxes, betaAxes, matchingRule, matchingDistanceType);
        out(handles, ['[Face cluster] Face cluster no: ' num2str(faceClusterNo)]);
        out(handles, ['[Face cluster] Matching costs: ' num2str(faceMatchingCosts') ]);        
        %fprintf('%.4f ', faceMatchingCosts); fprintf('\n');
        
         pts = pts(ptsClusters == faceClusterNo, :);
         guiDrawModel(handles);   
        
    catch exception
         out(handles, ['[Face cluster] Error: ' exception.message]);
         rethrow(exception);
    end;        
    %end;    
        
 

% --- Executes on button press in generateNUVButton.
function generateNUVButton_Callback(hObject, eventdata, handles)
% hObject    handle to generateNUVButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    global pts spts mpts n u v meanPtsDistance;
       
    try
       
        neigborhoodRadius = meanPtsDistance * str2double( get(handles.neighborhoodRadiusCoeff, 'String') );
        out(handles, ['[Smoothing and nuv calculating] Neigborhood radius:' num2str(neigborhoodRadius) ])
        [n u v pts spts mpts] = smoothData(pts, neigborhoodRadius);
        out(handles, '[Smoothing and nuv calculating] (n,u,v) calculated.')
        
        guiDrawModel(handles);  
    catch exception
         out(handles, ['[Smoothing and nuv calculating] Error: ' exception.message]);
         rethrow(exception);         
    end;

function neighborhoodRadiusCoeff_Callback(hObject, eventdata, handles)
% hObject    handle to neighborhoodRadiusCoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neighborhoodRadiusCoeff as text
%        str2double(get(hObject,'String')) returns contents of neighborhoodRadiusCoeff as a double


% --- Executes during object creation, after setting all properties.
function neighborhoodRadiusCoeff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neighborhoodRadiusCoeff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadModelButton.
function loadModelButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadModelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts n u v;

    [FileName, PathName] = uigetfile('*.*', 'Select RAW 3d Model');
    if (FileName ~= 0)
        try            
            [pts n u v] = ioRestore3dData([PathName FileName]);
            out(handles, [ '[Model loading] ' num2str( size(pts,1) ) ' points have been read.' ]);
            guiDrawModel(handles);            
        catch exception
             out(handles, ['[Model loading] Error: ' exception.message]);
             rethrow(exception);
        end;
    end;    


% --- Executes on button press in fixNormalsButton.
function fixNormalsButton_Callback(hObject, eventdata, handles)
% hObject    handle to fixNormalsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts n;
    
    try  
        n = fixNormalVectors(pts, n);
        guiDrawModel(handles); 
        out(handles, '[Normal vectors fixing] Normal vectors fixed.');
    catch exception
        out(handles, ['[Normal vectors fixing] Error: ' exception.message]);
        rethrow(exception);
    end;


% --- Executes on button press in storeModelButton.
function storeModelButton_Callback(hObject, eventdata, handles)
% hObject    handle to storeModelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts n u v;

    try        
        [FileName, PathName] = uiputfile('*.*', 'Enter 3d face model File');
        if (FileName ~= 0)
            ioStore3dData([PathName FileName], pts, n, u, v);
            out(handles, ['[Saving model] Stored ' num2str( size(pts,1) ) ' points.']);
        end;
    catch exception
        out(handles, ['[Saving model] Error: ' exception.message]);
        rethrow(exception);
    end;  
    
    
    
function alfaAxes = alfaAxeType(handles)
%Zwraca jaki jest ustawiony typ skali dla wspó³rzêdnej alfa.        
        alfaAxesNo = ( get(handles.alfaAxesList, 'Value') );
        if alfaAxesNo == 2
            alfaAxes = 'lin';
        elseif alfaAxesNo == 1
            alfaAxes = 'log';
        else
            error('UNKNOWN ITEM FOR AlfaAxes !');
        end;
        
function betaAxes = betaAxeType(handles)        
%Zwraca jaki jest ustawiony typ skali dla wspó³rzêdnej beta.
        betaAxesNo = ( get(handles.betaAxesList, 'Value') );
        if betaAxesNo == 2
            betaAxes = 'lin';
        elseif betaAxesNo == 1
            betaAxes = 'log';
        else
            error('UNKNOWN ITEM FOR betaAxes !');
        end;

% --- Executes on button press in buildDescButton.
function buildDescButton_Callback(hObject, eventdata, handles)
% hObject    handle to buildDescButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts n selIxs spinImgs;

    try 
        distance = str2double( get(handles.descRadiusEdit, 'String') );
        alfaBins = str2double( get(handles.noOfAlfaBinsEdit, 'String') );
        betaBins = str2double( get(handles.noOfBetaBinsEdit, 'String') );
       
        alfaAxes = alfaAxeType(handles) ;
        betaAxes = betaAxeType(handles) ;
        
        out(handles, ['[Building descriptor] Building [' num2str(distance) ' -> (' alfaAxes ',' betaAxes ') -> ' num2str(alfaBins) ',' num2str(betaBins) '] descriptors.']);
        spinImgs = buildModelDescriptor(pts, n, selIxs, distance, alfaBins, betaBins, alfaAxes, betaAxes);
        
        if get(handles.showDescriptorCheckBox, 'Value')
            figure
            imshow(spinImgs);
        end;
        
    catch exception
        out(handles, ['[Building descriptor] Error: ' exception.message]);
        rethrow(exception);
    end;  

% --- Executes on button press in selSeedPtsButton.
function selSeedPtsButton_Callback(hObject, eventdata, handles)
% hObject    handle to selSeedPtsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts selIxs;
    
    try            
         
        selMethodNo = ( get(handles.selMethod, 'Value') );
        switch selMethodNo
            case 1
                method = 'rand';
            case 2
                method = 'oct';
            case 3
                method = 'kmeans';
            otherwise
            error('Bad value for selection-method name !');
        end;
        
        
        noOfSeedPts = str2double( get(handles.seedPtsNoEdit, 'String') );
        selIxs = getSeedPointsNo(pts, noOfSeedPts, method);

        out(handles, ['[Finding feature points] ' num2str( size(selIxs,1) ) ' points have been selected.'] );        
        guiDrawSeedPoints(handles);
    catch exception
        out(handles, ['[Finding feature points] Error: ' exception.message]);
        rethrow(exception);
    end;  
    


% --- Executes on selection change in betaAxesList.
function betaAxesList_Callback(hObject, eventdata, handles)
% hObject    handle to betaAxesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns betaAxesList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from betaAxesList


% --- Executes during object creation, after setting all properties.
function betaAxesList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betaAxesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in alfaAxesList.
function alfaAxesList_Callback(hObject, eventdata, handles)
% hObject    handle to alfaAxesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns alfaAxesList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from alfaAxesList


% --- Executes during object creation, after setting all properties.
function alfaAxesList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alfaAxesList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function descRadiusEdit_Callback(hObject, eventdata, handles)
% hObject    handle to descRadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of descRadiusEdit as text
%        str2double(get(hObject,'String')) returns contents of descRadiusEdit as a double


% --- Executes during object creation, after setting all properties.
function descRadiusEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to descRadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noOfAlfaBinsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to noOfAlfaBinsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noOfAlfaBinsEdit as text
%        str2double(get(hObject,'String')) returns contents of noOfAlfaBinsEdit as a double


% --- Executes during object creation, after setting all properties.
function noOfAlfaBinsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noOfAlfaBinsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noOfBetaBinsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to noOfBetaBinsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noOfBetaBinsEdit as text
%        str2double(get(hObject,'String')) returns contents of noOfBetaBinsEdit as a double


% --- Executes during object creation, after setting all properties.
function noOfBetaBinsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noOfBetaBinsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showDescriptorCheckBox.
function showDescriptorCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to showDescriptorCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showDescriptorCheckBox


% --- Executes on button press in descButton.
function descButton_Callback(hObject, eventdata, handles)
% hObject    handle to descButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   DisableAllPanels(handles);
    set(handles.descButton, 'FontWeight', 'bold');   
     set(handles.descPanel, 'Visible', 'on');


% --- Executes on button press in sparseModelButton.
function sparseModelButton_Callback(hObject, eventdata, handles)
% hObject    handle to sparseModelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global pts;
    
    try
        leftPts = str2double( get(handles.keepPointsEdit, 'String') );
        pts = reduceDataSize(pts, leftPts);
    
        out(handles, ['[Reducing data size] ' num2str( size(pts,1) ) ' left.'] );        
        guiDrawModel(handles);
    catch exception
        out(handles, ['[Reducing data size] Error: ' exception.message]);
        rethrow(exception);
    end;  


function keepPointsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to keepPointsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of keepPointsEdit as text
%        str2double(get(hObject,'String')) returns contents of keepPointsEdit as a double


% --- Executes during object creation, after setting all properties.
function keepPointsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to keepPointsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in outBox.
function outBox_Callback(hObject, eventdata, handles)
% hObject    handle to outBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns outBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outBox


% --- Executes on button press in clearOutBox.
function clearOutBox_Callback(hObject, eventdata, handles)
% hObject    handle to clearOutBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.outBox, 'String', '');


% --- Executes on button press in storeRaw.
function storeRaw_Callback(hObject, eventdata, handles)
% hObject    handle to storeRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    global pts;

    try        
        [FileName, PathName] = uiputfile('*.*', 'Enter 3d face raw model File');
        if (FileName ~= 0)
            ioStore3dRawData([PathName FileName], pts);
            out(handles, ['[Saving raw model] Stored ' num2str( size(pts,1) ) ' points.']);
        end;
    catch exception
        out(handles, ['[Saving raw model] Error: ' exception.message]);
        rethrow(exception);
    end;  


% --- Executes on button press in saveFigureButton.
function saveFigureButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveFigureButton (see GCBO)
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




% --- Executes on button press in storeDescriptorsButton.
function storeDescriptorsButton_Callback(hObject, eventdata, handles)
% hObject    handle to storeDescriptorsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global selIxs spinImgs;

    try        
        [FileName, PathName] = uiputfile('*.*', 'Enter descriptor file to be stored');
        if (FileName ~= 0)
            ioStoreModelDescriptor([PathName FileName], spinImgs, selIxs);
            out(handles, ['[Saving descriptor] Stored to ' [PathName FileName] '.']);
        end;
    catch exception
        out(handles, ['[Saving descriptor] Error: ' exception.message]);
        rethrow(exception);
    end;  



% --- Executes on button press in calcNormalForFeatureButton.
function calcNormalForFeatureButton_Callback(hObject, eventdata, handles)
% hObject    handle to calcNormalForFeatureButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    
    global pts n u v meanPtsDistance selIxs;
       
    try       
        neigborhoodRadius = meanPtsDistance * str2double( get(handles.neighborhoodRadiusCoeff, 'String') );
        out(handles, ['[(n,u,v) calculating] Neigborhood radius:' num2str(neigborhoodRadius) ]);
        [n u v] = findNUV(pts, neigborhoodRadius, selIxs);
        out(handles, '[(n,u,v) calculating] (n,u,v) calculated.');
    catch exception
         out(handles, ['[(n,u,v) calculating] Error: ' exception.message]);
         rethrow(exception);         
    end; 


% --- Executes on button press in loadDescriptorsButton.
function loadDescriptorsButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadDescriptorsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



    global spinImgs selIxs;

    [FileName, PathName] = uigetfile('*.*', 'Select Descriptor File');
    if (FileName ~= 0)
        try            
            [spinImgs selIxs] = ioRestoreModelDescriptor([PathName FileName]);
            out(handles, [ '[Descriptor loading] ' num2str( length(selIxs) ) ' feature points have been read.' ]);
            
            guiDrawSeedPoints(handles);
        catch exception
             out(handles, ['[Descriptor loading] Error: ' exception.message]);
             rethrow(exception);
        end;
    end;    


% --- Executes on selection change in matchingFilterMenu.
function matchingFilterMenu_Callback(hObject, eventdata, handles)
% hObject    handle to matchingFilterMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns matchingFilterMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from matchingFilterMenu


% --- Executes during object creation, after setting all properties.
function matchingFilterMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matchingFilterMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in distanceTypeMenu.
function distanceTypeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to distanceTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns distanceTypeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from distanceTypeMenu


% --- Executes during object creation, after setting all properties.
function distanceTypeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distanceTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in matchingDistanceTypeMenu.
function matchingDistanceTypeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to matchingDistanceTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns matchingDistanceTypeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from matchingDistanceTypeMenu


% --- Executes during object creation, after setting all properties.
function matchingDistanceTypeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matchingDistanceTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function faceDescFileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to faceDescFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of faceDescFileEdit as text
%        str2double(get(hObject,'String')) returns contents of faceDescFileEdit as a double


% --- Executes during object creation, after setting all properties.
function faceDescFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to faceDescFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function neighRadiusEdit_Callback(hObject, eventdata, handles)
% hObject    handle to neighRadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neighRadiusEdit as text
%        str2double(get(hObject,'String')) returns contents of neighRadiusEdit as a double


% --- Executes during object creation, after setting all properties.
function neighRadiusEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neighRadiusEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noOfFeaturePtsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to noOfFeaturePtsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noOfFeaturePtsEdit as text
%        str2double(get(hObject,'String')) returns contents of noOfFeaturePtsEdit as a double


% --- Executes during object creation, after setting all properties.
function noOfFeaturePtsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noOfFeaturePtsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in displayMode.
function displayMode_Callback(hObject, eventdata, handles)
% hObject    handle to displayMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of displayMode
guiDrawModel(handles);



function seedPtsNoEdit_Callback(hObject, eventdata, handles)
% hObject    handle to seedPtsNoEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of seedPtsNoEdit as text
%        str2double(get(hObject,'String')) returns contents of seedPtsNoEdit as a double


% --- Executes during object creation, after setting all properties.
function seedPtsNoEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seedPtsNoEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in selMethod.
function selMethod_Callback(hObject, eventdata, handles)
% hObject    handle to selMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns selMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selMethod


% --- Executes during object creation, after setting all properties.
function selMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton26.
function pushbutton26_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox('Program do analizy i testowania algorytmów przetwarzania obrazów 3D. Autor: Tomasz Kuœmierczyk');


