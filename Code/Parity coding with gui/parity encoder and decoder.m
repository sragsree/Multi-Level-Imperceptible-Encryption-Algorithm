function varargout = parity(varargin)

clc;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @parity_OpeningFcn, ...
                   'gui_OutputFcn',  @parity_OutputFcn, ...
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


% --- Executes just before parity is made visible.
function parity_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to parity (see VARARGIN)

handles.output = hObject;
set(handles.enpush,'enable','off');
set(handles.depush,'enable','off');
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = parity_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selectwav.
function selectwav_Callback(hObject, eventdata, handles)
% hObject    handle to selectwav (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value1=get(handles.encode,'value');
value2=get(handles.decode,'value');
if value1==1
    
    [handles.fname, handles.pname] = uigetfile('*.wav','Select a file');        
    set(handles.enpush,'enable','on'); 
    guidata(hObject, handles);
end
if value2==1
set(handles.selectwav,'enable','off');
set(handles.depush,'enable','on'); 
    guidata(hObject, handles);
end

   
    
    



% --- Executes on button press in encode.
function encode_Callback(hObject, eventdata, handles)
% hObject    handle to encode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'value',1);


% --- Executes on button press in decode.
function decode_Callback(hObject, eventdata, handles)
% hObject    handle to decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox.
function listbox_Callback(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on selectwav and none of its controls.
function selectwav_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to selectwav (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on encode and none of its controls.
function encode_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to encode (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'value',1);


% --- Executes on button press in decode.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to decode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of decode


% --- Executes on button press in enpush.
function enpush_Callback(hObject, eventdata, handles)
% hObject    handle to enpush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [x,fs,nbits]=wavread('button-2.wav');
 disp(fs)


%sound(x,fs)
%hold on

y=((2^(nbits-1)*x(:,1)));
for i=1:length(y)
if y(i)<0
    z(i)=1;
else
    z(i)=0;
end
if y(i)<0
        y(i)=-1*y(i);
end
end
y=dec2bin(y);
z=dec2bin(z);
temp_message=dec2bin(double('NSS College'),8);
message=[];
for v=1:size(temp_message,1)
    message=[message temp_message(v,:)];
end
str = dec2bin(length(message),16);
if length(message)<length(y)
for a=1:length(str)
    y(a,nbits-1)=str(a);
end
 b=1;
 
for j=17:length(message)+16
 if b<length(message)+1 
    y(j,nbits-1)=message(b);
    b=b+1;
 end
end
b=bin2dec(y);
for i=1:length(y)
    if z(i)=='1'
        b(i)=-1*b(i);
    end
end
a=b/(2^(nbits-1));
set(handles.listbox1,'string','Data Embedding Completed');
wavwrite(a,fs,nbits,'stego_message.wav');

mmfileinfo('stego_message.wav')

subplot(1,2,1),plot(x(:,1));
title('Before Steganography');
xlabel('Sample Number');
ylabel('Amplitude');
subplot(1,2,2),plot(a);
title('After Steganography');
xlabel('Sample Number');
ylabel('Amplitude');
else
disp('error')
end



% --- Executes on key press with focus on enpush and none of its controls.
function enpush_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to enpush (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in depush.
function depush_Callback(hObject, eventdata, handles)
% hObject    handle to depush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[m,fs,nbits]=wavread('stego_message.wav');
wavplay(m,fs);
y=((2^(nbits-1)*m(:,1)));
for i=1:length(y)
if y(i)<0
    z(i)=1;
else
    z(i)=0;
end
if y(i)<0
        y(i)=-1*y(i);
end
end
y=dec2bin(y);
z=dec2bin(z);
  for h=1:16
      k(h)=y(h,nbits-1);
  end
  
  b=bin2dec(k);
 for j=17:b+16
  msg(j)=y(j,nbits-1);
 end
  smsg=[];
  o=8;
 for q=1:8:length(msg)
     smsg=[smsg; msg(1,q:o)];
     o=o+8;
 end

  g=bin2dec(smsg);
   mesg=char (g');
   clc;
  disp('DECODED OUTPUT=');
disp(mesg);
   
  