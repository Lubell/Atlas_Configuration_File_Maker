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

% change version Number
fileID = fopen('Version_Info_V11.txt','r+');
topLineOfVInfo = fgetl(fileID);

vInfo = topLineOfVInfo(end-7:end);



% Setup Atlas Config File
freqSam = get(handles.SamplingRate,'Value');
interLeave = 0;

switch freqSam
    
    case 2
        smplRate = '16000';
        interLeave = 8;
    case 3
        smplRate = '16000';
        interLeave = 4;
    case 4
        smplRate = '16000';
        interLeave = 2;
    case 5
        smplRate = '16000';
    case 6
        smplRate = '32000';
    case 7
        smplRate = '40000';
end

channelLength = str2double(handles.channelBox.String);
numStrips = str2double(handles.stripBox.String);


elecTable = handles.uitable1.Data;
numChan = elecTable(:,2);
elecAbrevName = elecTable(:,1);
alphaElec = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
elecNameCheck = 1;
for i = 1:numStrips
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
    'Magneta';...
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


% channelDetails has three columns and rows equal to the number of channels
% the first column is the channel name, the second column is the channel's
% color, and the third row is the channel's window number
channelDetails = cell(channelLength,3);

% Add names and colors and window numbers to channelDetails
elecLoop = 0;
configType = get(handles.windowNumber,'Value');
if configType>=2
    windowDiv = ceil(channelLength/configType);
    windowMaker = 0:windowDiv:channelLength;
    windowMaker(1) = [];
    windowMakerText = windowMaker+1;
    
    
    
    if numel(windowMaker)<configType
        windowMaker(end+1) = windowMaker(end)-(channelLength+600);
        windowMakerText(end+1) = windowMakerText(end)+channelLength;
    else
    
    windowMaker(end) = windowMaker(end)-(channelLength+600);
    end
    winGate = 1;
    winGateText = 1;
else
    winGate = 0;
    winGateText = 0;
end

noColorPicker = 1;

for i = 1:numStrips
    for j = 1:str2double(numChan{i})
        elecLoop = elecLoop +1;
        
        
        channelDetails{elecLoop,1} = [elecTable{i,1},num2str(j)];
        
        
        
        
        if winGate>=1
            
            
            channelDetails{elecLoop,3} = num2str(winGate);
            if isequal(windowMaker(winGate),elecLoop)
                winGate = winGate+1;
            end
            
        else
            channelDetails{elecLoop,3} = num2str(configType);
        end
        
        if handles.colors
            channelColorName = elecTable{i,3};
            chosenElecColor = strfind(colorNames,channelColorName);
            for b = 1:length(chosenElecColor)
                if chosenElecColor{b}
                    elecDispColor = [num2str(colorCodes(b,1)),' ',num2str(colorCodes(b,2)),' ',num2str(colorCodes(b,3))];
                end
            end
        else
            
            elecDispColor = [num2str(colorCodes(noColorPicker,1)),' ',num2str(colorCodes(noColorPicker,2)),' ',num2str(colorCodes(noColorPicker,3))];
            noColorPicker = noColorPicker +1;
            if noColorPicker>=22
                noColorPicker = 1;
            end
        end
        
        channelDetails{elecLoop,2} = elecDispColor;
        
        
    end
    
    
end





refgroup = cell(1,5);
refgroup{1} = '32000001';
refgroup{2} = '33000001';
refgroup{3} = '34000001';
refgroup{4} = '35000001';
refgroup{5} = '36000001';



configurationFileHeader = ['#Pegasus system setup file\r\n',...
    '#Generated using Configuration_File_Maker ',vInfo,'\r\n',...
    '#File Generation Date:(dd/mm/yyyy) ',handles.date,'\r\n\r\n'];


configurationFileSysOptSetup = ['#System Options Setup\r\n',...
    '-SetSystemIdentifier "OUS_ATLAS1"\r\n\r\n',...
    '#Acquisition Control Setup\r\n',...
    '-SetDataDirectory "F:\\PegasusData\\',handles.ptString.String,'\\"\r\n',...
    '-SetCreateNewFilesPerRecording False\r\n',...
    '-SetMaxFileLength 4\r\n\r\n',...
    '#Hardware Subsystem Creation and Setup for:  AcqSystem1\r\n',...
    '-CreateHardwareSubSystem "AcqSystem1" ATLAS "',smplRate,'" "192.168.3.10" "26011" "192.168.3.100" "26090"\r\n',...
    '-SetDialogPosition "Hardware" 0 42\r\n',...
    '-SetDialogVisible "Hardware" False\r\n\r\n',...
    '#Reference Manager Setup\r\n\r\n',...
    '#Video Capture Setup\r\n\r\n',...
    '#Acquisition Entity creation and setup for: Events\r\n',...
    '-SetNetComDataBufferingEnabled Events False\r\n',...
    '-SetNetComDataBufferSize Events 3000\r\n\r\n'];


acquisitionEntCreateAndSetupCSC = ['#Acquisition Entity creation and setup for: "',...
    channelDetails{1,1},'"\r\n',...
    '-CreateCscAcqEnt "',channelDetails{1,1},'" "AcqSystem1"\r\n',...
    '-SetAcqEntProcessingEnabled "',channelDetails{1,1},'" False\r\n',...
    '-SetChannelNumber "',channelDetails{1,1},'" 0',...
    '\r\n-SetAcqEntReference "',channelDetails{1,1},'" ', refgroup{1}, '\r\n',...
    '-SetInputRange "',channelDetails{1,1},'" 1000\r\n',...
    '-SetSubSamplingInterleave "',channelDetails{1,1},'" 1\r\n',...
    '-SetDspLowCutFilterEnabled "',channelDetails{1,1},'" True\r\n',...
    '-SetDspLowCutFrequency "',channelDetails{1,1},'" 0.1\r\n',...
    '-SetDspLowCutNumberTaps "',channelDetails{1,1},'" 0\r\n',...
    '-SetDspHighCutFilterEnabled "',channelDetails{1,1},'" True\r\n',...
    '-SetDspHighCutFrequency "',channelDetails{1,1},'" 9000\r\n',...
    '-SetDspHighCutNumberTaps "',channelDetails{1,1},'" 256\r\n',...
    '-SetInputInverted "',channelDetails{1,1},'" True\r\n',...
    '-SetNetComDataBufferingEnabled "',channelDetails{1,1},'" False\r\n',...
    '-SetNetComDataBufferSize "',channelDetails{1,1},'" 3000\r\n\r\n'];




csgAllNames = [' "',channelDetails{1,1},'"'];

channGroup = 1;
refBatch = 33;
for i = 2:channelLength
    % Test Ref
    if isequal(i,refBatch)
    refBatch = refBatch*2;
    channGroup = channGroup +1;
    end
    acquisitionEntCreateAndSetupCSC = [acquisitionEntCreateAndSetupCSC,...
        '#Acquisition Entity creation and setup for: "',channelDetails{i,1},'"\r\n',...
        '-CreateCscAcqEnt "',channelDetails{i,1},'" "AcqSystem1"\r\n',...
        '-SetAcqEntProcessingEnabled "',channelDetails{i,1},'" False\r\n',...
        '-SetChannelNumber "',channelDetails{i,1},'" ',num2str(i-1),'\r\n',...
        '-SetAcqEntReference "',channelDetails{i,1},'" ', refgroup{channGroup}, '\r\n',...
        '-SetInputRange "',channelDetails{i,1},'" 1000\r\n',...
        '-SetSubSamplingInterleave "',channelDetails{i,1},'" 1\r\n',...
        '-SetDspLowCutFilterEnabled "',channelDetails{i,1},'" True\r\n',...
        '-SetDspLowCutFrequency "',channelDetails{i,1},'" 0.1\r\n',...
        '-SetDspLowCutNumberTaps "',channelDetails{i,1},'" 0\r\n',...
        '-SetDspHighCutFilterEnabled "',channelDetails{i,1},'" True\r\n',...
        '-SetDspHighCutFrequency "',channelDetails{i,1},'" 9000\r\n',...
        '-SetDspHighCutNumberTaps "',channelDetails{i,1},'" 256\r\n',...
        '-SetInputInverted "',channelDetails{i,1},'" True\r\n',...
        '-SetNetComDataBufferingEnabled "',channelDetails{i,1},'" False\r\n',...
        '-SetNetComDataBufferSize "',channelDetails{i,1},'" 3000\r\n\r\n'];
    
    
    
    csgAllNames = [csgAllNames, ' "',channelDetails{i,1},'"'];
    
end

csgAllNames= [csgAllNames, '\r\n'];


acquisitionEntCreateAndSetupCSG = ['#Acquisition Entity creation and setup for: "CSG1"\r\n',...
    '-CreateContinuousSignalGroupAcqEnt "CSG1" "AcqSystem1" ', handles.channelBox.String,...
    csgAllNames, '-SetAcqEntProcessingEnabled "CSG1" true\r\n',...
    '-SetChannelNumber "CSG1" ',num2str(0:(channelLength-1)),'\r\n',...
    '-SetAcqEntReference "CSG1" ', refgroup{1}, '\r\n',...
    '-SetInputRange "CSG1" 1000\r\n'];

if interLeave>=1
    acquisitionEntCreateAndSetupCSG = [acquisitionEntCreateAndSetupCSG,...
        '-SetSubSamplingInterleave "CSG1" ', num2str(interLeave),'\r\n'];
else
    acquisitionEntCreateAndSetupCSG = [acquisitionEntCreateAndSetupCSG,...
        '-SetSubSamplingInterleave "CSG1" 1\r\n'];
end

acquisitionEntCreateAndSetupCSG = [acquisitionEntCreateAndSetupCSG,...
    '-SetDspLowCutFilterEnabled "CSG1" true\r\n',...
    '-SetDspLowCutFrequency "CSG1" 0.1\r\n',...
    '-SetDspLowCutNumberTaps "CSG1" 0\r\n',...
    '-SetDspHighCutFilterEnabled "CSG1" true\r\n',...
    '-SetDspHighCutFrequency "CSG1" 9000\r\n',...
    '-SetDspHighCutNumberTaps "CSG1" 256\r\n',...
    '-SetInputInverted "CSG1" true\r\n\r\n'];


configurationFileMainWinSetup = ['#Main Window Setup\r\n',...
    '-SetDialogPosition Main -8 -8\r\n',...
    '-SetDialogVisible Main True\r\n\r\n',...
    '#System Status Dialog Setup\r\n',...
    '-SetSystemStatusShowDetails True\r\n',...
    '-SetDialogPosition Status 2 572\r\n',...
    '-SetSystemStatusMessageFilter Fatal on\r\n',...
    '-SetSystemStatusMessageFilter Error on\r\n',...
    '-SetSystemStatusMessageFilter Warning on\r\n',...
    '-SetSystemStatusMessageFilter Notice off\r\n',...
    '-SetSystemStatusMessageFilter Data off\r\n',...
    '-SetDialogVisible Status True\r\n\r\n',...
    '#Properties Display Setup\r\n',...
    '-SetDialogPosition Properties 734 453\r\n',...
    '-SetDialogVisible Properties True\r\n\r\n',...
    '#Event Dialog Setup\r\n',...
    '-SetDialogPosition Events 0 42\r\n',...
    '-SetDialogVisible Events False\r\n',...
    '-SetEventStringImmediateMode Off\r\n',...
    '-SetEventStringSingleKeyMode Off\r\n',...
    '-SetEventDisplayTTLValueFormat Binary\r\n\r\n'];


backColorPop = get(handles.backColor,'Value');

if isequal(backColorPop,1)
    bkTextRGBCSG = '255 255 255\r\n';
elseif isequal(backColorPop,2)
    bkTextRGBCSG = '0 0 0\r\n';
else
    bkTextRGBCSG = '255 255 240\r\n';
end



configurationFileSysExtrasSetup = [
    '#Audio Output Dialog Setup\r\n',...
    '-SetDialogPosition Audio 0 42\r\n',...
    '-SetDialogVisible Audio False\r\n\r\n',...
    '#TTL Response Dialog Setup\r\n',...
    '-SetDialogPosition TTLResponse 0 42\r\n',...
    '-SetDialogVisible TTLResponse False\r\n\r\n',...
    '#Audio Device Setup for Primary Sound Driver\r\n',...
    '-SetAudioSource "Primary Sound Driver" Left None\r\n',...
    '-SetAudioVolume "Primary Sound Driver" Left 100\r\n',...
    '-SetAudioMute "Primary Sound Driver" Left Off\r\n',...
    '-SetAudioSource "Primary Sound Driver" Right None\r\n',...
    '-SetAudioVolume "Primary Sound Driver" Right 100\r\n',...
    '-SetAudioMute "Primary Sound Driver" Right Off\r\n\r\n',...
    '#Audio Device Setup for AcqSystem1_Audio0\r\n',...
    '-SetAudioSource "AcqSystem1_Audio0" Left None\r\n',...
    '-SetAudioVolume "AcqSystem1_Audio0" Left 100\r\n',...
    '-SetAudioMute "AcqSystem1_Audio0" Left Off\r\n',...
    '-SetAudioSource "AcqSystem1_Audio0" Right None\r\n',...
    '-SetAudioVolume "AcqSystem1_Audio0" Right 100\r\n',...
    '-SetAudioMute "AcqSystem1_Audio0" Right Off\r\n\r\n',...
    '#Audio Device Setup for AcqSystem1_Audio1\r\n',...
    '-SetAudioSource "AcqSystem1_Audio1" Left None\r\n',...
    '-SetAudioVolume "AcqSystem1_Audio1" Left 100\r\n',...
    '-SetAudioMute "AcqSystem1_Audio1" Left Off\r\n',...
    '-SetAudioSource "AcqSystem1_Audio1" Right None\r\n',...
    '-SetAudioVolume "AcqSystem1_Audio1" Right 100\r\n',...
    '-SetAudioMute "AcqSystem1_Audio1" Right Off\r\n\r\n',...
    '#Digital IO Device Creation and Setup for: AcqSystem1_0\r\n',...
    '-SetDigitalIOPortDirection "AcqSystem1_0" 0 Input\r\n',...
    '-SetDigitalIOUseStrobeBit "AcqSystem1_0" 0 False\r\n',...
    '-SetDigitalIOEventsEnabled "AcqSystem1_0" 0 True\r\n',...
    '-SetDigitalIOPulseDuration "AcqSystem1_0" 0 15\r\n',...
    '-SetDigitalIOPortDirection "AcqSystem1_0" 1 Input\r\n',...
    '-SetDigitalIOUseStrobeBit "AcqSystem1_0" 1 False\r\n',...
    '-SetDigitalIOEventsEnabled "AcqSystem1_0" 1 True\r\n',...
    '-SetDigitalIOPulseDuration "AcqSystem1_0" 1 15\r\n',...
    '-SetDigitalIOPortDirection "AcqSystem1_0" 2 Input\r\n',...
    '-SetDigitalIOUseStrobeBit "AcqSystem1_0" 2 False\r\n',...
    '-SetDigitalIOEventsEnabled "AcqSystem1_0" 2 True\r\n',...
    '-SetDigitalIOPulseDuration "AcqSystem1_0" 2 15\r\n',...
    '-SetDigitalIOPortDirection "AcqSystem1_0" 3 Input\r\n',...
    '-SetDigitalIOUseStrobeBit "AcqSystem1_0" 3 False\r\n',...
    '-SetDigitalIOEventsEnabled "AcqSystem1_0" 3 True\r\n',...
    '-SetDigitalIOPulseDuration "AcqSystem1_0" 3 15\r\n',...
    '-SetDigitalIOInputScanDelay "AcqSystem1_0" 1\r\n\r\n',...
    '#Subject Dialog Setup\r\n',...
    '-SetDialogPosition Subject 383 425\r\n',...
    '-SetDialogVisible Subject False'];




configurationFilePlotWinCSC = [
    '# Plot Window Setup for "',handles.ptString.String,' Research ',channelDetails{1,3},'"\r\n',...
    '-CreatePlotWindow Time "',handles.ptString.String,' Research ',channelDetails{1,3},'"\r\n',...
    '-SetPlotWindowSpreadType "',handles.ptString.String,' Research ',channelDetails{1,3},'" Spread\r\n',...
    '-SetPlotWindowPlotType "',handles.ptString.String,' Research ',channelDetails{1,3},'" Sweep\r\n',...
    '-SetPlotWindowTimeframe "',handles.ptString.String,' Research ',channelDetails{1,3},'" 5000\r\n',...
    '-SetPlotWindowHistoryTimeframe "',handles.ptString.String,' Research ',channelDetails{1,3},'" 30\r\n',...
    '-SetPlotWindowShowGridLines "',handles.ptString.String,' Research ',channelDetails{1,3},'" True\r\n',...
    '-SetPlotWindowBackgroundColor "',handles.ptString.String,' Research ',channelDetails{1,3},'" 192 192 192\r\n',...
    '-SetPlotWindowPosition "',handles.ptString.String,' Research ',channelDetails{1,3},'" 100 100 1100 700\r\n',...    
    '-SetPlotWindowOverlay "',handles.ptString.String,' Research ',channelDetails{1,3},'" False\r\n',...
    '-SetPlotWindowShowTitleBar "',handles.ptString.String,' Research ',channelDetails{1,3},'" True\r\n\r\n'];



configurationFilePlotWinCSCAdditions = [
    '# Plot addition and setup for "',handles.ptString.String,' Research ',channelDetails{1,3},'"\r\n',...
    '-AddPlot "',handles.ptString.String,' Research ',channelDetails{1,3},'" "',channelDetails{1,1},'"\r\n',...
    '-SetPlotEnabled "',handles.ptString.String,' Research ',channelDetails{1,3},'" "',channelDetails{1,1},'" True\r\n',...
    '-SetTimePlotZoomFactor "',handles.ptString.String,' Research ',channelDetails{1,3},'" "',channelDetails{1,1},'" 32\r\n',...
    '-SetPlotWaveformColor "',handles.ptString.String,' Research ',channelDetails{1,3},'" "',channelDetails{1,1},'" ',...
    channelDetails{1,2},' \r\n'];



configurationFilePlotWinCSG = [
    '# Plot Window Setup for "',handles.ptString.String,' Clinical ',channelDetails{1,3},'"\r\n',...
    '-CreatePlotWindow Time "',handles.ptString.String,' Clinical ',channelDetails{1,3},'"\r\n',...
    '-SetPlotWindowSpreadType "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" Spread\r\n',...
    '-SetPlotWindowPlotType "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" Sweep\r\n',...
    '-SetPlotWindowTimeframe "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" 5000\r\n',...
    '-SetPlotWindowHistoryTimeframe "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" 30\r\n',...
    '-SetPlotWindowShowGridLines "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" True\r\n',...
    '-SetPlotWindowBackgroundColor "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" ',bkTextRGBCSG,...
    '-SetPlotWindowPosition "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" 300 100 1100 700\r\n',...
    '-SetPlotWindowOverlay "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" False\r\n',...
    '-SetPlotWindowShowTitleBar "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" True\r\n\r\n'];




configurationFilePlotWinCSGAdditions = [
    '# Plot addition and setup for "',handles.ptString.String,' Clinical ',channelDetails{1,3},'"\r\n',...
    '-AddPlot "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" "CSG1@',...
    channelDetails{1,1},'"\r\n',...
    '-SetPlotEnabled "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" "CSG1@',...
    channelDetails{1,1},'" True\r\n',...
    '-SetTimePlotZoomFactor "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" "CSG1@',...
    channelDetails{1,1},'" 16\r\n',...
    '-SetPlotWaveformColor "',handles.ptString.String,' Clinical ',channelDetails{1,3},'" "CSG1@',...
    channelDetails{1,1},'" ',channelDetails{1,2},'\r\n'];



configurationFileWindowAndPlotsCSC = [configurationFilePlotWinCSC,...
    configurationFilePlotWinCSCAdditions];

configurationFileWindowAndPlotsCSG = [configurationFilePlotWinCSG,...
    configurationFilePlotWinCSGAdditions];



plotIncrease = 100;



for i = 2:channelLength
    
    
    
    if winGateText>=1
        
        if isequal(windowMakerText(winGateText),i)
            configurationFileWindowAndPlotsCSC = [configurationFileWindowAndPlotsCSC,...
                '-SetPlotWindowCurrentPlot "',handles.ptString.String,' Research ',channelDetails{i-1,3},'" "',...
                channelDetails{i-1,1},'"\r\n',...
                '-SetPlotWindowMaximizeView "',handles.ptString.String,' Research ',channelDetails{i-1,3},'" False\r\n\r\n'];
            
            
            configurationFileWindowAndPlotsCSG = [configurationFileWindowAndPlotsCSG,...
                '-SetPlotWindowCurrentPlot "',handles.ptString.String,' Clinical ',channelDetails{i-1,3},'" "CSG1@',...
                channelDetails{i-1,1},'"\r\n',...
                '-SetPlotWindowMaximizeView "',handles.ptString.String,' Clinical ',channelDetails{i-1,3},'" False\r\n\r\n'];
            
            
            plotIncrease = plotIncrease + 100;
                        
            
            
            configurationFileWindowAndPlotsCSC = [configurationFileWindowAndPlotsCSC,...
                '\r\n# Plot Window Setup for "',handles.ptString.String,' Research ',channelDetails{i,3},'"\r\n',...
                '-CreatePlotWindow Time "',handles.ptString.String,' Research ',channelDetails{i,3},'"\r\n',...
                '-SetPlotWindowSpreadType "',handles.ptString.String,' Research ',channelDetails{i,3},'" Spread\r\n',...
                '-SetPlotWindowPlotType "',handles.ptString.String,' Research ',channelDetails{i,3},'" Sweep\r\n',...
                '-SetPlotWindowTimeframe "',handles.ptString.String,' Research ',channelDetails{i,3},'" 5000\r\n',...
                '-SetPlotWindowHistoryTimeframe "',handles.ptString.String,' Research ',channelDetails{i,3},'" 30\r\n',...
                '-SetPlotWindowShowGridLines "',handles.ptString.String,' Research ',channelDetails{i,3},'" True\r\n',...
                '-SetPlotWindowBackgroundColor "',handles.ptString.String,' Research ',channelDetails{i,3},'" 192 192 192\r\n',...
                '-SetPlotWindowPosition "',handles.ptString.String,' Research ',channelDetails{i,3},'" 100 ',...
                num2str(plotIncrease),' 1100 700\r\n',...
                '-SetPlotWindowOverlay "',handles.ptString.String,' Research ',channelDetails{i,3},'" False\r\n',...
                '-SetPlotWindowShowTitleBar "',handles.ptString.String,' Research ',channelDetails{i,3},'" True\r\n\r\n',...
                '# Plot addition and setup for "',handles.ptString.String,' Research ',channelDetails{i,3},'"\r\n'];
            
            configurationFileWindowAndPlotsCSG = [configurationFileWindowAndPlotsCSG,...
                '\r\n# Plot Window Setup for "',handles.ptString.String,' Clinical ',channelDetails{i,3},'"\r\n',...
                '-CreatePlotWindow Time "',handles.ptString.String,' Clinical ',channelDetails{i,3},'"\r\n',...
                '-SetPlotWindowSpreadType "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" Spread\r\n',...
                '-SetPlotWindowPlotType "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" Sweep\r\n',...
                '-SetPlotWindowTimeframe "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" 5000\r\n',...
                '-SetPlotWindowHistoryTimeframe "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" 30\r\n',...
                '-SetPlotWindowShowGridLines "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" True\r\n',...
                '-SetPlotWindowBackgroundColor "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" ',bkTextRGBCSG,...
                '-SetPlotWindowPosition "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" 300 ',...
                num2str(plotIncrease) ,' 1100 700\r\n',...
                '-SetPlotWindowOverlay "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" False\r\n',...
                '-SetPlotWindowShowTitleBar "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" True\r\n\r\n',...
                '# Plot addition and setup for "',handles.ptString.String,' Clinical ',channelDetails{i,3},'"\r\n'];
            
            
            winGateText = winGateText+1;
        end
        
        
        
        
        configurationFileWindowAndPlotsCSC = [configurationFileWindowAndPlotsCSC,...
            '-AddPlot "',handles.ptString.String,' Research ',channelDetails{i,3},'" "',channelDetails{i,1},'"\r\n',...
            '-SetPlotEnabled "',handles.ptString.String,' Research ',channelDetails{i,3},'" "',channelDetails{i,1},'" True\r\n',...
            '-SetTimePlotZoomFactor "',handles.ptString.String,' Research ',channelDetails{i,3},'" "',channelDetails{i,1},'" 32\r\n',...
            '-SetPlotWaveformColor "',handles.ptString.String,' Research ',channelDetails{i,3},'" "',channelDetails{i,1},'" ',...
            channelDetails{i,2},' \r\n'];
        
        
        
        
        configurationFileWindowAndPlotsCSG = [configurationFileWindowAndPlotsCSG,...
            '-AddPlot "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
            channelDetails{i,1},'"\r\n',...
            '-SetPlotEnabled "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
            channelDetails{i,1},'" True\r\n',...
            '-SetTimePlotZoomFactor "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
            channelDetails{i,1},'" 16\r\n',...
            '-SetPlotWaveformColor "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
            channelDetails{i,1},'" ',channelDetails{i,2},'\r\n'];
        
        if isequal(i,channelLength)
            
            
            configurationFileWindowAndPlotsCSC = [configurationFileWindowAndPlotsCSC,...
                '-AddPlot "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events"\r\n',...
                '-SetPlotEnabled "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events" True\r\n',...
                '-SetTimePlotZoomFactor "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events" 32\r\n',...
                '-SetPlotWaveformColor "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events" 154 153 255\r\n',...
                '-SetPlotWindowCurrentPlot "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events"\r\n',...
                '-SetPlotWindowMaximizeView "',handles.ptString.String,' Research ',channelDetails{i,3},'" False\r\n\r\n'];
            
            
            configurationFileWindowAndPlotsCSG = [configurationFileWindowAndPlotsCSG,...
                '-SetPlotWindowCurrentPlot "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
                channelDetails{end,1},'"\r\n',...
                '-SetPlotWindowMaximizeView "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" False\r\n\r\n'];
            
        end
        
        
        
    else
        
        configurationFileWindowAndPlotsCSC = [configurationFileWindowAndPlotsCSC,...
            '-AddPlot "',handles.ptString.String,' Research ',channelDetails{i,3},'" "',channelDetails{i,1},'"\r\n',...
            '-SetPlotEnabled "',handles.ptString.String,' Research ',channelDetails{i,3},'" "',channelDetails{i,1},'" True\r\n',...
            '-SetTimePlotZoomFactor "',handles.ptString.String,' Research ',channelDetails{i,3},'" "',channelDetails{i,1},'" 32\r\n',...
            '-SetPlotWaveformColor "',handles.ptString.String,' Research ',channelDetails{i,3},'" "',channelDetails{i,1},'" ',...
            channelDetails{i,2},' \r\n'];
        
        
        
        configurationFileWindowAndPlotsCSG = [configurationFileWindowAndPlotsCSG,...
            '-AddPlot "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
            channelDetails{i,1},'"\r\n',...
            '-SetPlotEnabled "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
            channelDetails{i,1},'" True\r\n',...
            '-SetTimePlotZoomFactor "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
            channelDetails{i,1},'" 16\r\n',...
            '-SetPlotWaveformColor "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
            channelDetails{i,1},'" ',channelDetails{i,2},'\r\n'];
        
        
        if isequal(i,channelLength)
            
            
            configurationFileWindowAndPlotsCSC = [configurationFileWindowAndPlotsCSC,...
                '-AddPlot "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events"\r\n',...
                '-SetPlotEnabled "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events" True\r\n',...
                '-SetTimePlotZoomFactor "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events" 32\r\n',...
                '-SetPlotWaveformColor "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events" 154 153 255\r\n',...
                '-SetPlotWindowCurrentPlot "',handles.ptString.String,' Research ',channelDetails{i,3},'" "Events"\r\n',...
                '-SetPlotWindowMaximizeView "',handles.ptString.String,' Research ',channelDetails{i,3},'" False\r\n\r\n'];
            
            
            configurationFileWindowAndPlotsCSG = [configurationFileWindowAndPlotsCSG,...
                '-SetPlotWindowCurrentPlot "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" "CSG1@',...
                channelDetails{end,1},'"\r\n',...
                '-SetPlotWindowMaximizeView "',handles.ptString.String,' Clinical ',channelDetails{i,3},'" False\r\n\r\n'];
            
        end
    end
    
    
    
end



configurationFileFinished = [configurationFileHeader,...
    configurationFileSysOptSetup,...
    acquisitionEntCreateAndSetupCSC,...
    acquisitionEntCreateAndSetupCSG,...
    configurationFileMainWinSetup,...
    configurationFileWindowAndPlotsCSC,...
    configurationFileWindowAndPlotsCSG,...
    configurationFileSysExtrasSetup];



fileID = fopen([configLocation,filesep,'Pegasus_',handles.ptString.String,'_',handles.channelBox.String,'ch_',handles.date,'.cfg'],'w');
fprintf(fileID,configurationFileFinished);
fclose(fileID);


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
