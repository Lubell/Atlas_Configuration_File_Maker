function varargout = Configuration_File_Maker(varargin)
% CONFIGURATION_FILE_MAKER MATLAB code for Configuration_File_Maker.fig
%      CONFIGURATION_FILE_MAKER, by itself, creates a new CONFIGURATION_FILE_MAKER or raises the existing
%      singleton*.
%
%      H = CONFIGURATION_FILE_MAKER returns the handle to a new CONFIGURATION_FILE_MAKER or the handle to
%      the existing singleton*.
%
%      Developed Using MathLabs's Guide Builder by James Lubell 2016
%      For use with Neurolynx Recording Systems
%
%      CONFIGURATION_FILE_MAKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIGURATION_FILE_MAKER.M with the given input arguments.
%
%      CONFIGURATION_FILE_MAKER('Property','Value',...) creates a new CONFIGURATION_FILE_MAKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Configuration_File_Maker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Configuration_File_Maker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Configuration_File_Maker

% Last Modified by GUIDE v2.5 19-May-2016 10:34:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Configuration_File_Maker_OpeningFcn, ...
    'gui_OutputFcn',  @Configuration_File_Maker_OutputFcn, ...
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


% --- Executes just before Configuration_File_Maker is made visible.
function Configuration_File_Maker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Configuration_File_Maker (see VARARGIN)

% Choose default command line output for Configuration_File_Maker
handles.output = hObject;
blankData = cell(25,2);
handles.uitable1.UserData = blankData;

if ~exist('C:\Users\admin\Desktop\Configuration','dir')
    configLocation = uigetdir([],'Select Config File Folder');
    handles.configurationFolder = configLocation;
else
    handles.configurationFolder = 'C:\Users\admin\Desktop\Configuration';
end
handles.colors = 0;




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Configuration_File_Maker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Configuration_File_Maker_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function ptString_Callback(hObject, eventdata, handles)
% hObject    handle to ptString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ptString as text
%        str2double(get(hObject,'String')) returns contents of ptString as a double
handles.Build.Enable = 'off';
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ptString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ptString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Calc.
function Calc_Callback(hObject, eventdata, handles)
% hObject    handle to Calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% First check for config folder

if ~isfield(handles,'configurationFolder')
    configLocation = uigetdir('Select Config File Folder');
    handles.configurationFolder = configLocation;
    guidata(hObject, handles);
elseif ~exist(handles.configurationFolder,'dir')
    configLocation = uigetdir('Select Config File Folder');
    handles.configurationFolder = configLocation;
    guidata(hObject, handles);
else
    configLocation = handles.configurationFolder;
end

% Grab current location (just in case)
CurrentLocation = pwd;


% array that when it's total is 15 build button can be activiated
noBuild= [3,5,7,11,13,17];
chPass = 'Check/Pass Fail';

% Checks before enabling Build Button 1) sample rate 2) check num elec 3) pt code 
% 3) not over writing 4) TBD


% pressed calculate button: 
% - first check the sample rate if bad warn and no build else

    
sampRate = get(handles.SamplingRate,'Value');

if isequal(sampRate,1)
    noBuild(1) = 0;
    msgbox('Please make sure to choose a sampling rate!',chPass)
else
    noBuild(1) = 3;
end


% - check the pt code if bad warn and no build else
ptName = handles.ptString.String;
if isempty(ptName)
    ptName = 'Blank';
    msgbox('Please make sure to provide a patient name',chPass)
    noBuild(2) = 0;
else
    noBuild(2) = 5;
end


% - check the isnum(elec numbers) if bad warn and no build else

elecTable = handles.uitable1.Data;
numChan = elecTable(:,2);
elecNames = elecTable(:,1);
if isempty(numChan)
    chanDisp = '0ch';
    noBuild(3) = 0;
else
    chan = 0;
    validElec = 0;
    for i = 1:length(numChan)
        if ~isnan(str2double(numChan{i}))
            chan = chan+str2double(numChan{i});
            validElec = validElec + 1;
        elseif ~isempty(elecNames{i})
            noBuild(3) = 0;
        end
    end
    
    if isequal(noBuild(3),7) && ~isnan(chan)
        chanDisp = [num2str(chan), 'ch'];
        
        handles.channelBox.String = num2str(chan);
        handles.stripBox.String = num2str(validElec);
        
    else
        msgbox('Please make sure that all entries for electrode numbers contain numbers and that they''re real',chPass)
        handles.channelBox.String = 'Error';
        chanDisp ='Error';
        handles.stripBox.String = '0';
        noBuild(3) = 0;
    end
end

recDate = datetime('today');
handles.date = [num2str(recDate.Day),'-',num2str(recDate.Month),'-',num2str(recDate.Year)];

fName = ['Pegasus_',ptName, '_' , chanDisp, '_',handles.date,'.cfg'];

handles.fName.String = fName;

% - check some Colors

if ~isequal(handles.colors,0)
    for colorChecker = 1:validElec
        channelColorName = elecTable{colorChecker,3};
        if isempty(channelColorName)
            noBuild(4) =0;
        end
    end
    
    
    if isequal(noBuild(4),0)
        wrColorText = ['Please make sure that all entries for channel ',...
            'colors have been entered or ''Custom Channel Colors'' has',...
            ' been turned off.'];
        msgbox(wrColorText,chPass)
    end
end



% - check some channel Names


for elecNameCheck = 1:validElec
    elecName = elecTable{elecNameCheck,1};
    elecLastChar = str2double(elecName(end));
    if ~isnan(elecLastChar)
        noBuild(5) =0;
    end
end

if isequal(noBuild(5),0) && isequal(sum(noBuild(1:4)),26)
    qstring = ['I''ve noticed that some of the names you provided',...
        ' for the strips contain numbers.  This can sometimes cause',...
        ' problems, especially if the numbered strip shares a name',...
        ' with another strip.  Consider replacing numbers with letters, ',...
        'e.g., Channel1 could become ChannelA and so on.',...
        '  If you''re confidant that it won''t ',...
        'cause problems press ''Understand'' otherwise press ''No'' or ''Cancel'''];
    button = questdlg(qstring,'Electrode Names?','Understand','No','No');
    
    switch button
        case 'Understand'
            noBuild(5) =13;
        otherwise
            noBuild(5) =0;
            
    end
end







% - check not overwriting if bad warn get answer and no build else
pegasusFname = fName;
cd(configLocation)

if exist(pegasusFname,'file') && isequal(sum(noBuild),56)
   
    qstring = ['Files already exist with this setup.'...
        'Would you like to overwrite them?'];
    button = questdlg(qstring,'Overwrite?');
    
    switch button
        case 'Yes'
            noBuild(6) =17;
        otherwise
            noBuild(6) =0;
            
    end
end




cd(CurrentLocation)


if isequal(sum(noBuild),56)
    handles.Build.Enable = 'on';
else
    handles.Build.Enable = 'off';
end


guidata(hObject, handles);







% --- Executes on button press in Build.
function Build_Callback(hObject, eventdata, handles)
% hObject    handle to Build (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


configLocation = handles.configurationFolder;


CurrentLocation = pwd;



cd(configLocation)

% Setup Atlas Config File
freqSam = get(handles.SamplingRate,'Value');
interLeave = 0;

switch freqSam
    
    case 2
        smplRate = '32000';
         interLeave = 16;
    case 3
        smplRate = '32000';
         interLeave = 8;
    case 4
        smplRate = '32000';
         interLeave = 4;
    case 5
        smplRate = '16000';
    case 6
        smplRate = '32000';
    case 7
        smplRate = '40000';
end

    
replaceLine = 3;
mfT = '%s';
newData = ['%sampleFrequency = ', smplRate];
fileID = fopen('ATLAS.cfg','r+');
for k=1:(replaceLine-1);
    fgetl(fileID);
end
fseek(fileID,0,'cof');
fprintf(fileID, mfT, newData);
fclose(fileID);


% Setup CGS and CSC Config Files


customCSCFileTop = ['######## VARIABLE SUBSTITUTION SETUP\r\n\r\n',...
    '%%subSystemName = AcqSystem1\r\n',...
    '%%acqEntName = CSC1\r\n',...
    '%%timeWindowName = "',handles.ptString.String,' Research 1"\r\n',...
    '%%plotWindowPositionX = 100\r\n',...
    '%%plotWindowPositionY = 100\r\n',...
    '%%plotWindowWidth = 1100\r\n',...
    '%%plotWindowHeight = 700\r\n',...
    '%%plotPositionIncrement = 100\r\n\r\n',...
    '######## CSC ACQUISITION ENTITY CREATION\r\n'];


customCSGFileTopTip =['######## CSG CREATION\r\n\r\n',...
    '         -CreateContinuousSignalGroupAcqEnt',...
    ' "CSG1" AcqSystem1 ',handles.channelBox.String];



customCSGFileTop = ['\r\n\r\n\r\n######## VARIABLE SUBSTITUTION SETUP\r\n\r\n',...
    '    %%timeWindowName = "',handles.ptString.String,' Clinical 1"\r\n',...
    '    %%plotWindowPositionX = 100\r\n',...
    '    %%plotWindowPositionY = 100\r\n',...
    '    %%plotWindowWidth = 1100\r\n',...
    '    %%plotWindowHeight = 700\r\n',...
    '    %%plotPositionIncrement = 100\r\n\r\n\r\n',...
    '######## TIME WINDOW CREATION\r\n\r\n',...
    '-CreatePlotWindow Time %%timeWindowName\r\n',...
    '  -SetPlotWindowPosition %%timeWindowName ',...
    '%%plotWindowPositionX %%plotWindowPositionY ',...
    '%%plotWindowWidth %%plotWindowHeight\r\n\r\n'];

standardInbetweenCSCText = ['-CreateCscAcqEnt %%acqEntName %%subSystemName\r\n',...
    '	-SetChannelNumber 		%%acqEntName 	%%currentADChannel\r\n\r\n'];


standardInbetweenCSCTimeWinText = ['######## TIME WINDOW CREATION\r\n',...
    '-CreatePlotWindow Time %%timeWindowName\r\n',...
    '      -SetPlotWindowPosition %%timeWindowName %%plotWindowPositionX %%plotWindowPositionY %%plotWindowWidth %%plotWindowHeight\r\n'];



runningCSCElecText = '\r\n';
k = 0;
r = 1;
elecTable = handles.uitable1.Data;
numChan = elecTable(:,2);
elecAbrevName = elecTable(:,1);
alphaElec = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
elecNameCheck = 1;
for i = 1:str2double(handles.stripBox.String)
    if strcmp(elecAbrevName{i},'')  && ~(elecNameCheck)
        elecTable{i,1} = [alphaElec(i),alphaElec(i),alphaElec(i)];
        
    elseif (strcmp(elecAbrevName{i},'') || isempty(elecAbrevName{i})) && elecNameCheck
        elecTable{i,1} = [alphaElec(i),alphaElec(i),alphaElec(i)];
        elecNameCheck = 0;
        msgbox(['It looks like one of the electrode strips or grids was not ',...
            'named.  It will be given a three letter default name.  To replace ',...
            'the defualt name add a name for the strip/grid and resave.']);
    end
end
handles.uitable1.Data = elecTable;



backColorPop = get(handles.backColor,'Value');


colorCodes = [255,0,0;...
    0,0,255;...
    255,0,255;...
    0,0,128;...
    192,192,192;...
    128,128,128;...
    128,0,0;...
    128,128,0;...
    0,128,0;...
    128,0,128;...
    0,128,128;...
    255,20,147;...
    240,255,255;...
    255,255,240;...
    188,143,143;...
    230,230,250;...
    255,165,0;...
    255,255,0;...
    0,255,255;...
    0,255,0;...
    0,0,0;...
    255,255,255];


colorNames = {'Red';...
    'Blue';...
    'Magenta';...
    'Navy';...
    'Silver';...
    'Gray';...
    'Maroon';...
    'Olive';...
    'Green';...
    'Purple';...
    'Teal';...
    'Pink';...
    'Azure';...
    'Ivory';...
    'Rosy Brown';...
    'Lavender';...
    'Orange';...
    'Yellow';...
    'Cyan';...
    'Lime';...
    'Black';...
    'White'};


elecColorCell = cell(str2double(handles.channelBox.String),1);

bkTextTop = '\r\n\r\n####### Background Color Setup\r\n';
bkTextLine =['    -SetPlotWindowBackgroundColor "',handles.ptString.String,' '];


bkTextCSC = 'Research ';

bkTextCSG = 'Clinical ';


if isequal(backColorPop,1)
    bkTextRGBCSG = '" 255 255 255\r\n';
    bkTextRGBCSC = '" 192 192 192\r\n';
elseif isequal(backColorPop,2)
    bkTextRGBCSG = '" 0 0 0\r\n';
    bkTextRGBCSC = '" 192 192 192\r\n';
else
    bkTextRGBCSG = '" 255 255 240\r\n';
    bkTextRGBCSC = '" 192 192 192\r\n';
end





% Add color



cscPlotCell = cell(str2double(handles.channelBox.String),1);
csgPlotCell = cell(str2double(handles.channelBox.String),1);
csgPlotNames = cell(str2double(handles.channelBox.String),1);
for i = 1:str2double(handles.stripBox.String)
    if handles.colors
        channelColorName = elecTable{i,3};
        
        chosenElecColor = strfind(colorNames,channelColorName);
        
        for b = 1:length(chosenElecColor)
            if chosenElecColor{b}
                elecDispColor = [num2str(colorCodes(b,1)),' ',num2str(colorCodes(b,2)),' ',num2str(colorCodes(b,3))];
            end
        end
        
        
    end
    
    for j = 1:str2double(numChan{i})
        
        lineOne = ['%%acqEntName = ',elecTable{i,1},num2str(j),'\r\n'];
        cscPlotCell{r} = ['      -AddPlot %%timeWindowName ',elecTable{i,1},num2str(j),'\r\n'];
        if isequal(j,1) && isequal(i,1)
            lineTwo = '%%currentADChannel = 0\r\n';
        else
            lineTwo = '%%currentADChannel += 1\r\n';
        end
        
        if handles.colors
            elecColorCell{r} = elecDispColor;
        end
        csgPlotNames{r} = [elecTable{i,1},num2str(j)];
        csgPlotCell{r}= ['      -AddPlot %%timeWindowName CSG1','@',elecTable{i,1},num2str(j),'\r\n'];
        runningCSCElecText = [runningCSCElecText,lineOne, lineTwo,standardInbetweenCSCText];
        k = k+1;
        r = r+1;
    end
    
end

configType = get(handles.windowNumber,'Value');
allElec = str2double(handles.channelBox.String);
if isequal(configType,1)
    windowMaker = 0;
    
elseif isequal(configType,2)
    windowMaker = 2;
    elecWinBreak = round(allElec/windowMaker);
    winInsert = elecWinBreak+1:elecWinBreak:allElec;
elseif isequal(configType,3)
    windowMaker = 3;
    elecWinBreak = round(allElec/windowMaker);
    winInsert = elecWinBreak+1:elecWinBreak:allElec;
elseif isequal(configType,4)
    windowMaker = 4;
    elecWinBreak = round(allElec/windowMaker);
    winInsert = elecWinBreak+1:elecWinBreak:allElec;
elseif isequal(configType,5)
    windowMaker = 5;
    elecWinBreak = round(allElec/windowMaker);
    winInsert = elecWinBreak+1:elecWinBreak:allElec;
elseif isequal(configType,6)
    windowMaker = 6;
    elecWinBreak = round(allElec/windowMaker);
    winInsert = elecWinBreak+1:elecWinBreak:allElec;
end

if windowMaker>0
    bkTextFullCSC = [bkTextTop,bkTextLine,bkTextCSC,'1',bkTextRGBCSC];
    bkTextFullCSG = [bkTextTop,bkTextLine,bkTextCSG,'1',bkTextRGBCSG];
    
    for i = 2:windowMaker
        bkTextFullCSC = [bkTextFullCSC,bkTextLine,bkTextCSC,num2str(i),bkTextRGBCSC];
        bkTextFullCSG = [bkTextFullCSG,bkTextLine,bkTextCSG,num2str(i),bkTextRGBCSG];
        
    end
else
    bkTextFullCSC = [bkTextTop,bkTextLine,bkTextCSC,'1',bkTextRGBCSC];
    bkTextFullCSG = [bkTextTop,bkTextLine,bkTextCSG,'1',bkTextRGBCSG];
end


winCSCDivideTop = ['\r\n\r\n',...
    '%%plotWindowPositionX += %%plotPositionIncrement\r\n',...
    '%%plotWindowPositionY += %%plotPositionIncrement\r\n\r\n',...
    '%%timeWindowName = "',handles.ptString.String,' Research '];

winCSCDivideBottom = ['-CreatePlotWindow Time %%timeWindowName\r\n',...
    '  -SetPlotWindowPosition %%timeWindowName ',...
    '%%plotWindowPositionX %%plotWindowPositionY ',...
    '%%plotWindowWidth %%plotWindowHeight\r\n\r\n'];


winCSGDivideTop = ['\r\n\r\n',...
    '    %%timeWindowName = "',handles.ptString.String,' Clinical '];


winCSGDivideBottom = ['    %%plotWindowPositionX += %%plotPositionIncrement\r\n',...
    '    %%plotWindowPositionY += %%plotPositionIncrement\r\n\r\n',...
    '-CreatePlotWindow Time %%timeWindowName\r\n',...
	'  -SetPlotWindowPosition %%timeWindowName %%plotWindowPositionX',...
    ' %%plotWindowPositionY %%plotWindowWidth %%plotWindowHeight\r\n'];

if handles.colors
    colorPickerTextCSC = ['######## SET PLOT COLORS\r\n\r\n',...
        ' -SetPlotWaveformColor "',handles.ptString.String,' Research 1" "',...
        csgPlotNames{1},'" ',elecColorCell{1},'\r\n'];
    
    colorPickerTextCSG = ['######## SET PLOT COLORS\r\n\r\n',...
        ' -SetPlotWaveformColor "',handles.ptString.String,' Clinical 1" "CSG1@',...
        csgPlotNames{1},'" ',elecColorCell{1},'\r\n'];
    
    wincolorPickerTextCSC = [' -SetPlotWaveformColor "',handles.ptString.String,' Research '];
    wincolorPickerTextCSG = [' -SetPlotWaveformColor "',handles.ptString.String,' Clinical '];
end



openClause = 0;



cscPlotText = cscPlotCell{1};
csgPlotText = csgPlotCell{1};
clicker = 1;
winNumbersTemp = 2:6;
for i = 2:r-1
    if windowMaker
        if isequal(i,(winInsert(clicker)))
            winNum = num2str(winNumbersTemp(clicker));
            csgPlotText = [csgPlotText,winCSGDivideTop, winNum,'"\r\n',winCSGDivideBottom,...
                csgPlotCell{i}];
            cscPlotText= [cscPlotText,winCSCDivideTop, winNum,'"\r\n\r\n',winCSCDivideBottom,...
                cscPlotCell{i}];
            
            if handles.colors
                colorPickerTextCSC = [colorPickerTextCSC,wincolorPickerTextCSC,winNum,'" "',...
                    csgPlotNames{i},'" ',elecColorCell{i},'\r\n'];
                colorPickerTextCSG = [colorPickerTextCSG,wincolorPickerTextCSG,winNum,'" "CSG1@',...
                    csgPlotNames{i},'" ',elecColorCell{i},'\r\n'];
                
                
            end
            openClause = 1;
            
            
            
            
            
            if ~isequal(windowMaker-1,clicker)
                clicker = clicker +1;
            end
        else
            
            csgPlotText = [csgPlotText,csgPlotCell{i}];
            cscPlotText= [cscPlotText,cscPlotCell{i}];
            if openClause && handles.colors
                colorPickerTextCSC = [colorPickerTextCSC,wincolorPickerTextCSC,winNum,'" "',...
                    csgPlotNames{i},'" ',elecColorCell{i},'\r\n'];
                colorPickerTextCSG = [colorPickerTextCSG,wincolorPickerTextCSG,winNum,'" "CSG1@',...
                    csgPlotNames{i},'" ',elecColorCell{i},'\r\n'];
            elseif handles.colors
                
                colorPickerTextCSC = [colorPickerTextCSC,' -SetPlotWaveformColor "',handles.ptString.String,' Research 1" "',...
                    csgPlotNames{i},'" ',elecColorCell{i},'\r\n'];
                colorPickerTextCSG = [colorPickerTextCSG,' -SetPlotWaveformColor "',handles.ptString.String,' Clinical 1" "CSG1@',...
                    csgPlotNames{i},'" ',elecColorCell{i},'\r\n'];
            end
        end
    else
        
        
        csgPlotText = [csgPlotText,csgPlotCell{i}];
        cscPlotText= [cscPlotText,cscPlotCell{i}];
        if handles.colors
            colorPickerTextCSC = [colorPickerTextCSC,' -SetPlotWaveformColor "',handles.ptString.String,' Research 1" "',...
                csgPlotNames{i},'" ',elecColorCell{i},'\r\n'];
            colorPickerTextCSG = [colorPickerTextCSG,' -SetPlotWaveformColor "',handles.ptString.String,' Clinical 1" "CSG1@',...
                csgPlotNames{i},'" ',elecColorCell{i},'\r\n'];
        end
        
    end
end

for i = 1:(r-1)
    customCSGFileTopTip = [customCSGFileTopTip, ' ', csgPlotNames{i}];
end







if handles.colors
    
    customWholeCSC = [customCSCFileTop,runningCSCElecText,'\r\n\r\n',...
        standardInbetweenCSCTimeWinText,cscPlotText,'\r\n\r\n',colorPickerTextCSC,bkTextFullCSC];
    
    
    if interLeave>=1
        
    interLeaveText =['\r\n\r\n##### Set InterLeave\r\n',...
        '-SetSubSamplingInterleave CSG1 ', num2str(interLeave),'\r\n'];

    customWholeCSG = [customCSGFileTopTip,customCSGFileTop,csgPlotText,...
        '\r\n\r\n',colorPickerTextCSG,bkTextFullCSG,interLeaveText];
    else
        customWholeCSG = [customCSGFileTopTip,customCSGFileTop,csgPlotText,...
        '\r\n\r\n',colorPickerTextCSG,bkTextFullCSG];
    end
    
else
    customWholeCSC = [customCSCFileTop,runningCSCElecText,'\r\n\r\n',...
        standardInbetweenCSCTimeWinText,cscPlotText,bkTextFullCSC];
    if interLeave>=1
        
    interLeaveText =['\r\n\r\n##### Set InterLeave\r\n',...
        '-SetSubSamplingInterleave CSG1 ', num2str(interLeave),'\r\n'];

    customWholeCSG = [customCSGFileTopTip,customCSGFileTop,csgPlotText,...
        bkTextFullCSG,interLeaveText];
    else
        
    customWholeCSG = [customCSGFileTopTip,customCSGFileTop,csgPlotText,bkTextFullCSG];
    end
    
    
end

cscFileName = handles.fName.String;
cscFileName(1:8) = [];
cscFileName(end-3:end) = [];
cscFileName = [cscFileName, '_Research.cfg'];
fileID = fopen(cscFileName,'w');
fprintf(fileID,customWholeCSC);
fclose(fileID);




csgFileName = handles.fName.String;
csgFileName(1:8) = [];
csgFileName(end-3:end) = [];
csgFileName = [csgFileName, '_Clinical.cfg'];

fileID = fopen(csgFileName,'w');
fprintf(fileID,customWholeCSG);
fclose(fileID);



% Setup Pegasus defaults Config File
customPegasusFile = ['######### BASIC SOFTWARE SETUP\r\n\r\n',...
    '-SetDataDirectory "F:\\PegasusData\\',handles.ptString.String,'"\r\n',...
    '\r\n#System Status Dialog Setup\r\n\r\n',...
    '-SetDialogPosition Status 2 572\r\n',...
    '-SetDialogVisible Status True\r\n',...
    '-SetSystemStatusShowDetails True\r\n',...
    '\r\n#Properties Display Setup\r\n\r\n',...
    '-SetDialogPosition Properties 598 387\r\n',...
    '-SetDialogVisible Properties True\r\n',...
    '\r\n\r\n######### ACQUISITION SYSTEM SETUP\r\n',...
    '\r\n# Do the basic setup for your acquisition\r\n\r\n',...
    '-ProcessConfigurationFile ATLAS.cfg\r\n',...
    '\r\n#-ProcessConfigurationFile RawDataFilePlayback.cfg\r\n',...
    '\r\n\r\n######### VIDEO TRACKING\r\n\r\n',...
    '\r\n#-ProcessConfigurationFile VideoTracker.cfg\r\n',...
    '\r\n\r\n######### ELECTRODE CONFIGURATIONS\r\n\r\n',...
    '\r\n### Add your custom setup file here\r\n\r\n',...
    '-ProcessConfigurationFile ',cscFileName];
fileID = fopen(['Pegasus_',handles.ptString.String,'_',handles.channelBox.String,'ch_',handles.date,'.cfg'],'w');
fprintf(fileID,customPegasusFile);
fclose(fileID);







cd(CurrentLocation)


handles.Build.Enable = 'off';





msgbox('Configuration Files Built','Success','help');

guidata(hObject, handles);


function channelBox_Callback(hObject, eventdata, handles)
% hObject    handle to channelBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channelBox as text
%        str2double(get(hObject,'String')) returns contents of channelBox as a double


% --- Executes during object creation, after setting all properties.
function channelBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stripBox_Callback(hObject, eventdata, handles)
% hObject    handle to stripBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stripBox as text
%        str2double(get(hObject,'String')) returns contents of stripBox as a double


% --- Executes during object creation, after setting all properties.
function stripBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stripBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SamplingRate.
function SamplingRate_Callback(hObject, eventdata, handles)
% hObject    handle to SamplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Build.Enable = 'off';
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns SamplingRate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SamplingRate


% --- Executes during object creation, after setting all properties.
function SamplingRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SamplingRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fName_Callback(hObject, eventdata, handles)
% hObject    handle to fName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Build.Enable = 'off';
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of fName as text
%        str2double(get(hObject,'String')) returns contents of fName as a double


% --- Executes during object creation, after setting all properties.
function fName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in windowNumber.
function windowNumber_Callback(hObject, eventdata, handles)
% hObject    handle to windowNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Build.Enable = 'off';
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns windowNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from windowNumber


% --- Executes during object creation, after setting all properties.
function windowNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in colorButton.
function colorButton_Callback(hObject, eventdata, handles)
% hObject    handle to colorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Build.Enable = 'off';
changeColor = handles.colors;
if ~changeColor
    handles.uitable1.ColumnEditable = [true, true, true];
    handles.colors = 1;
else
    handles.uitable1.ColumnEditable = [true, true, false];
    handles.colors = 0;
    tableData = handles.uitable1.Data;
    tableData(:,3) = cell(25,1);
    handles.uitable1.Data = tableData;
end
guidata(hObject, handles);


% --- Executes on selection change in backColor.
function backColor_Callback(hObject, eventdata, handles)
% hObject    handle to backColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Build.Enable = 'off';
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns backColor contents as cell array
%        contents{get(hObject,'Value')} returns selected item from backColor


% --- Executes during object creation, after setting all properties.
function backColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
