function [f,spect]=dataspect(y,fs)
% DATASPECT  real data spectrum demo.  Use the graphic interface
% to load a data file.
% DATASPECT(Y,FS) displays your data (array Y at sampling
% frequency FS) and its spectrum.  Push the Return button to return
% arrays of frequency axis and spectrum to the root workspace.

if  (nargin==1 && ischar(y))	% callbacks
    action=y;
    d=get(gcbf,'UserData');
    switch (action)
        case 'SND'
            [fname,pname]=uigetfile('*','Select Sound File');
            if (fname)
                %		   if isunix cd('/'), end
                cd(pname)
                eval('[y,d.fs]=readsnd(fname);')
                eval('d.y=y(:)'';')
                d.title=['Data from file ',fname];
                d=drawspect(d);
            end
        case 'AU'
            [fname,pname]=uigetfile('*','Select AU Sound File');
            if (fname)
                cd('/')
                cd(pname)
                eval('[y,d.fs]=auread(fname);')
                eval('d.y=y(:)'';')
                d.title=['Data from file ',fname];
                d=drawspect(d);
            end
        case 'WAV'
            [fname,pname]=uigetfile('*.wav','Select WAV File');
            if (fname)
                if isunix
                    cd('/');
                end
                cd(pname)
                [y,d.fs]=audioread(fname);
                d.y=y(:)';
                d.title=['Data from file ',fname];
                d=drawspect(d);
            end
        case 'TXT'
            [fnamext,pname]=uigetfile('*.txt','Select TXT File');
            if (fnamext)
                fname=strtok(fnamext,'.');
                
                if ~isletter(fname(1))
                    fname=['X',fname];
                end
                
                if isunix
                    cd('/');
                end
                
                cd(pname)
                load(fnamext,'-ASCII')
                eval(['ydatBR549=',fname,'(:)'';'])
                clear(fname)				% just in case the file name
                d=get(gcbf,'UserData');		% was "d.txt"  !
                d.y=ydatBR549;
                fs=inputdlg('Enter Sampling Frequency','fs',1,{num2str(d.fs)});
                if isempty(fs)	
                    d.fs=str2num(fs{1});
                end
                d.title=['Data from file ',fnamext];
                set(d.fstxt,'String',['fs = ',num2str(d.fs)])
                d=drawspect(d);
            end
        case 'var'	% load main workspace variable
            whostr=evalin('base','who');
            idx=listdlg('ListString',whostr,'SelectionMode','single', ...
                'ListSize',[300 160],'Name','Select Variable',...
                'PromptString','Main Workspace Variables');
            if (idx)
                data=evalin('base',whostr{idx});
                d.y=data(:)';
                fsd=inputdlg('Enter Sampling Frequency','fs',1);
                fs=str2num(fsd{:});
                if isempty(fs)	
                    d.fs=str2num(fs{1});	
                end
                d.title=['Data from variable ',whostr{idx}];
                d.fs=fs;
                d=drawspect(d);
            end
        case 'play'
            sound(d.y,d.fs)
        case 'zoom'
            if (get(gcbo,'Value'))
                axes(d.datax),		zoom on
                axes(d.spectax),	zoom on
            else
                axes(d.datax),		zoom out,	zoom off
                axes(d.spectax),	zoom out,	zoom off
            end
        case 'popwin'
            d.winnum=get(gcbo,'Value');
            d=drawspect(d);
        case 'popspect'
            d.spectmode=get(gcbo,'Value');
            d=drawspect(d);
        case 'rbutton'
            assignin('base','freq',d.freq)
            N=length(d.y);
            switch d.spectmode
                case 1
                    assignin('base','AY',2*abs(d.Y)/N)
                    disp('Returned Amplitude spectrum to [freq,AY]')
                case 2
                    assignin('base','PY',2*d.Y.*conj(d.Y)/N^2)
                    disp('Returned Power spectrum to [freq,PY]')
                case 3
                    assignin('base','CY',2*d.Y/N)
                    disp('Returned Complex spectrum to [freq,CY]')
                case 4
                    power=2*d.Y.*conj(d.Y)/N^2;
                    assignin('base','dB',10*log10(power))
                    disp('Returned Decibel spectrum to [freq,dB]')
            end
        case 'd'
            f=d;
        case 'help'
            helpwin('aboutdataspect')
        otherwise
            disp(['callback ',action,' unknown'])
    end
    set(gcbf,'UserData',d)
    
elseif (nargin==0 || (nargin==2 && isnumeric(y)))	% start-up
    if (nargin==0)
        y=[0 1];
        fs=1;
        datatitle='no data';
    else
        y=y(:)';
        datatitle='Your Data';
    end
    d=struct('y',y, ...
        'fs',fs, ...
        'winnum',1, ...
        'title',datatitle, ...
        'spectmode',1, ...
        'freq',zeros(10,1), ...
        'Y',zeros(10,1), ...
        'datax',0,'spectax',0,'fstxt',0);
    a=figure('Units','normalized','Position',[0.2 0.1 0.75 0.8], ...
        'Numbertitle','off','Name','DataSpect','Tag','DataSpectBR549');
    set(0,'ShowHiddenHandles','on')
    wh=findobj('Tag','DataSpectBR549');
    s=length(wh);
    if (s>1)
        set(a,'Name',['DataSpect #',num2str(s)]);
    end
    set(0,'ShowHiddenHandles','off')
    currdir=pwd;
    tmpdir = which('mainswitch.m');
    [pathstr,~,~]=fileparts(tmpdir);
    homedir=pathstr;
    if isunix 
        cd('/');
    end
    cd(homedir)
    dm=dir('fontpref.mat');
    if (~isempty(dm))
        load fontpref
        set(a,'DefaultAxesFontName',axfont.FontName, ...
            'DefaultAxesFontUnits',axfont.FontUnits, ...
            'DefaultAxesFontSize',axfont.FontSize, ...
            'DefaultAxesFontWeight',axfont.FontWeight, ...
            'DefaultAxesFontAngle',axfont.FontAngle, ...
            'DefaultUicontrolFontName',uifont.FontName, ...
            'DefaultUicontrolFontUnits',uifont.FontUnits, ...
            'DefaultUicontrolFontSize',uifont.FontSize, ...
            'DefaultUicontrolFontWeight',uifont.FontWeight, ...
            'DefaultUicontrolFontAngle',uifont.FontAngle)
    end
    if isunix
        cd('/');
    end
    cd(currdir)
    color=get(a,'Color');
    d.datax=axes('Parent',a,'Units','normalized','XGrid','on', ...
        'YGrid','on','Position',[0.33 0.56 0.6 0.39]);
    d.spectax=axes('Parent',a,'Units','normalized','XGrid','on', ...
        'YGrid','on','Position',[0.33 0.07 0.6 0.39]);
    if strcmp(computer,'MAC2')
        c=uicontrol('Parent',a,'Style','pushbutton','Units','normalized', ...
            'Position',[0.015 0.902 0.15 0.048],'String','load Sound', ...
            'callback','dataspect SND');
    end
    if isunix
        uicontrol('Parent',a,'Style','pushbutton','Units','normalized', ...
            'Position',[0.015 0.902 0.15 0.048],'String','load AU', ...
            'callback','dataspect AU');
    end
    uicontrol('Parent',a,'Style','pushbutton','Units','normalized', ...
        'Position',[0.015 0.854 0.15 0.048],'String','load WAV', ...
        'callback','dataspect WAV');
    uicontrol('Parent',a,'Style','pushbutton','Units','normalized', ...
        'Position',[0.015 0.806 0.15 0.048],'String','load TXT', ...
        'callback','dataspect TXT');
    uicontrol('Parent',a,'Style','pushbutton','Units','normalized', ...
        'Position',[0.015 0.758 0.15 0.048],'String','load variable', ...
        'callback','dataspect var');
   uicontrol('Parent',a,'Style','pushbutton','Units','normalized', ...
        'Position',[0.015 0.678 0.15 0.048],'String','play sound', ...
        'callback','dataspect play');
    d.fstxt=uicontrol('Parent',a,'Style','text','Units','normalized', ...
        'Position',[0.015 0.630 0.15 0.048],'BackgroundColor',color, ...
        'String',['fs = ',num2str(d.fs)]);
    uicontrol('Parent',a,'Style','text','Units','normalized', ...
        'Position',[0.015 0.548 0.195 0.048],'BackgroundColor',color, ...
        'String','Apply Window');
    uicontrol('Parent',a,'Style','popupmenu','Units','normalized', ...
        'Position',[0.015 0.5 0.195 0.048], ...
        'String','None|Bartlett|Hanning|Hamming|Kaiser 2.5', ...
        'Callback','dataspect popwin','Value',d.winnum);
    uicontrol('Parent',a,'Style','checkbox','Units','normalized', ...
        'Position',[0.015 0.402 0.195 0.048],'String','Zoom Control', ...
        'callback','dataspect zoom');
    uicontrol('Parent',a,'Style','text','Units','normalized', ...
        'Position',[0.015 0.188 0.195 0.048],'BackgroundColor',color, ...
        'String','Spectrum');
    uicontrol('Parent',a,'Style','popupmenu','Units','normalized', ...
        'Position',[0.015 0.14 0.195 0.048], ...
        'String','Amplitude|Power|Complex|Decibel', ...
        'Callback','dataspect popspect','Value',d.spectmode);
    uicontrol('Parent',a,'Style','pushbutton','Units','normalized', ...
        'Position',[0.015 0.015 0.15 0.05], ...
        'String','Return','Callback','dataspect rbutton');
    b = uimenu('Parent',a,'Label','DataSpect');
    uimenu('Parent',b,'Label','Help','Enable','on','Tag','helpmenu', ...
        'Callback','dataspect help');
    c2 = uimenu('Parent',b,'Label','Visible','Enable','on','Tag','onmenu', ...
        'Callback',['set(gcf,''Handlevisibility'',''on'');', ...
        'set(get(gcbo,''UserData''),''Enable'',''on'');', ...
        'set(gcbo,''Enable'',''off'')']);
    c3 = uimenu('Parent',b,'Label','Callback','Enable','off', ...
        'Callback',['set(gcf,''Handlevisibility'',''callback'');', ...
        'set(get(gcbo,''UserData''),''Enable'',''on'');', ...
        'set(gcbo,''Enable'',''off'')'],'UserData',c2);
    set(c2,'UserData',c3)
    % 	c=uicontrol('Parent',a,'Style','pushbutton','Units','normalized', ...
    % 	   'Position',[0.18 0.07 0.05 0.06],'String','d', ...
    % 	   'Callback','d=dataspect(''d'')');
    d=drawspect(d);
    set(a,'HandleVisibility','callback')
    set(a,'UserData',d)
    homedir=pathto('dataspect.m');
    p=path;
    if ~size(strfind(p,homedir))
        path(path,homedir)
        disp([homedir,'  added to search path'])
    end
else
    error('Argument Error!')
end

function d=drawspect(d)	% update displays
axes(d.datax),	cla
N=length(d.y);
t=(0:N-1)/d.fs;
switch (d.winnum)
    case 1	% no window
        w=ones(1,N);
    case 2	% Bartlett window
        w=2*(0:N/2)/N;
        if rem(N,2)	% odd length
            w=[w w((N+1)/2:-1:2)];
        else		% even length
            w=[w w(N/2:-1:2)];
        end
    case 3	% Hanning window
        w=0.5*(1-cos(2*pi*(0:N-1)/N));
    case 4	% Hamming window
        w=0.54-0.46*cos(2*pi*(0:N-1)/N);
    case 5	% Kaiser window using alpha=2.5
        m=N/2;	t=(0:N-1);
        w=besseli(0,2.5*pi*sqrt(1-((t-m)/m).^2))/besseli(0,2.5*pi);
end
y=w.*d.y;		% apply window
plot(t,y), grid on
xlabel('Time'),ylabel('data y(t)'),title(d.title)
half=floor(N/2);
d.freq=[0:half]/N*d.fs;
Y=fft(y);
d.Y=Y(1:half+1);
axes(d.spectax);	
legend off;
cla;

switch (d.spectmode)
    case 1
        plot(d.freq,2*abs(d.Y)/N);
        xlabel('Frequency'),ylabel('A')
        title('Amplitude Spectrum')
    case 2
        plot(d.freq,2*d.Y.*conj(d.Y)/N^2)
        xlabel('Frequency'),ylabel('P')
        title('Power Spectrum')
    case 3
        plot(d.freq,2*real(d.Y)/N,'r'), hold on
        plot(d.freq,2*imag(d.Y)/N,'b')
        legend('real','imag')
        xlabel('Frequency'),ylabel('Y')
        title('Complex Spectrum')
    case 4
        power=2*d.Y.*conj(d.Y)/N^2;
        plot(d.freq,10*log10(power));
        xlabel('Frequency'),ylabel('dB')
        title('Decibel Spectrum')
end
grid on

function dest=pathto(fname)
r=which(fname);
[tok1,r]=strtok(r,filesep);
dest=tok1;
[tok2,r]=strtok(r,filesep);
while ~isempty(r)
    tok1=tok2;
    dest=[dest,filesep,tok1];
    [tok2,r]=strtok(r,filesep);
end

% by Tim Conover Copyright 2000
