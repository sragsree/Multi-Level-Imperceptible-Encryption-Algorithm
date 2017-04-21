function varargout = audiostegano(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @audiostegano_OpeningFcn, ...
                   'gui_OutputFcn',  @audiostegano_OutputFcn, ...
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


% --- Executes just before audiostegano is made visible.
function audiostegano_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to audiostegano (see VARARGIN)

handles.output = hObject;
handles.fname='';
handles.pname='';
set(handles.pushbutton2,'enable','off');
%set(handles.text2,'string','Select a wav file in which you want to hide text');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes audiostegano wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = audiostegano_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value1=get(handles.radiobutton1,'value');
value2=get(handles.radiobutton2,'value');
if value1==1
    
    [handles.fname, handles.pname] = uigetfile('*.wav','Select a file');        
    set(handles.pushbutton2,'enable','on'); 
    guidata(hObject, handles);

end
if value2==1
     set(handles.pushbutton2,'enable','off'); 
     [filename, pathname] = uigetfile('*.wav','Select a file');        
     [y,fs,nbits,opts]=wavread([pathname filename],[1 2]);
    
     fid1=fopen([pathname filename],'r'); 
     header=fread(fid1,40,'uint8=>char');
     data_size=fread(fid1,1,'uint32');
    
     [dta,count]=fread(fid1,inf,'uint16');
     fclose(fid1);
     
     lsb=1;

     identity=bitget(dta(1:8),lsb)';
     if identity==[1 0 1 0 1 0 1 0] 
       len_bin=zeros(20,1);
       m_bin=zeros(10,1);
       n_bin=zeros(10,1);

       m_bin(1:10)=bitget(dta(9:18),lsb);
       n_bin(1:10)=bitget(dta(19:28),lsb);
       %convert the length to decimal
       %len=bi2de((len_bin)');
       m=bi2de(m_bin');
       n=bi2de(n_bin');
       len=m*n*8;
       
       secmsg_bin=zeros(len,1);
      
       secmsg_bin(1:len)=bitget(dta(29:28+len),lsb);
       secmsg_bin_re=reshape(secmsg_bin,len/8,8);

       secmsg_double=bi2de(secmsg_bin_re);

       secmsg=char(reshape(secmsg_double,m,n));
       %size(secmsg)
       %secmsg=reshape(secmsg,m,n/8);
       set(handles.edit1,'string',secmsg);
       
     else
     msgbox('File has no hidden text','Empty!!!','warn');
     end
end
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msg=get(handles.edit1,'string');


if length(msg)==0
     msgbox('Please type some text','Empty!!!','warn');
else
    [y,fs,nbits,opts]=wavread([handles.pname handles.fname],[1 2]);
 
    fid1=fopen([handles.pname handles.fname],'r');
    
    
    header=fread(fid1,40,'uint8=>char'); 
    
   
    data_size=fread(fid1,1,'uint32');
    
    
    [dta,count]=fread(fid1,inf,'uint16');   
    
    
    fclose(fid1);
    
    lsb=1;

    
    msg=get(handles.edit1,'string');   
    [ro,co]=size(msg);
    if ( (ro*co*8+28) > count )
      msgbox('Message too big, select small message','Empty!!!','error');
    else
        [m_msg,n_msg]=size(msg);
        msg_double=double(msg);            
        
        msg_bin=de2bi(msg_double,8);      
        [m,n]=size(msg_bin);                
        msg_bin_re=reshape(msg_bin,m*n,1);     
        m_bin=de2bi(m_msg,10)';          
        n_bin=de2bi(n_msg,10)';          
        len=length(msg_bin_re);      


        len_bin=de2bi(len,20)';     

        
        identity=[1 0 1 0 1 0 1 0]';
        dta(1:8)=bitset(dta(1:8),lsb,identity(1:8));

        
        dta(9:18)=bitset(dta(9:18),lsb,m_bin(1:10));
        dta(19:28)=bitset(dta(19:28),lsb,n_bin(1:10));                              
       
        dta(29:28+len)=bitset(dta(29:28+len),lsb,msg_bin(1:len)');


        randname=num2str(randint(1,1,[1 2000]));

    
        fid2=fopen(['new' randname '.wav'],'w');

   
        fwrite(fid2,header,'uint8');
        fwrite(fid2,data_size,'uint32');

      
        fwrite(fid2,dta,'uint16');
        fclose(fid2);

        msgbox(['YOUR TEXT IS HIDDEN IN  new' randname '.wav FILE'],'');
        set(hObject,'enable','off');
    end
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of radiobutton2
set(hObject,'value',1);
msgbox('SELECT A WAV FILE IN WHICH TEXT IS ALREADY HIDDEN','INSTRUCTIONS','HELP');
%set(handles.text2,'string','Select a wav file in which text is already hidden');
set(handles.pushbutton2,'enable','off'); 


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
set(hObject,'value',1);
msgbox('SELECT A WAV FILE IN WHICH YOU WANT TO HIDE TEXT','INSTRUCTIONS','HELP');
%set(handles.text2,'string','Select a wav file in which you want to hide text');

