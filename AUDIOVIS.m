function [  ] = AUDIOVIS (song_string)
% This function processes audio performing analysis functions then
% provides the user with an animated 3D Spectrogram of the audio, a simple
% yet interesting way to visualise audio data. The function includes a
% small feature to dynamically determine the input command.

% All output files are saved as either .wav or .avi format.

% Input either an audio file of any type from the same folder or simply
% type 'record' to be given the option of analysing data from a live
% microphone feed.


if strcmpi(song_string, 'record')           % If 'record' run recording function
    
    [filename] = RECORD_FUNC(song_string);  % Run the microphone recording function
        
    AUDIOVIS(filename)                      % Perform analysis on the output recording
    
else                                        % Else, just perform orignal analysis

[y, Fs] = audioread(song_string);           % Read the sound file
[a, b] = size(y);                           % Set a to y(:, 1) and b to y(:, 2)
yL = length(y);                             % Set length of y
t = 0:1/Fs:(length(y)-1)/Fs;                % Time length

frameRate = 30;                 % Frame rate of track bar
frameT = 1/frameRate;           % Track bar step size

mag = max(y(:,1))+0.1;          % Set length of the red track bar

playHeadLoc = 0;                % Track bar initialisation

song = y(1 : yL/2);             % Set audio range for spectrogram

hFig = figure('units','normalized','outerposition',[0 0 1 1]);      % Prepare a full screen figure

if b == 2               % Determine if dual or single channel audio
    
    mag1 = max(y(:,1))+0.1;        % Set length of the red track bar (dual audio)
    mag2 = max(y(:,2))+0.1;        % Set length of the red track bar (dual audio)
         
    subplot(2,2,1), plot(t, y(:,1), 'b');       % Plot left channel audio
    ylim([min(y(:,1))-0.1 max(y(:,1))+0.1])     % y-axis limits
    xlim([0 yL/Fs])                             % x-axis limits
    title(['Left Channel Audio    ',...         % Subplot title    
        num2str(song_string)])                  % ...
    xlabel('Time (secs)')                       % x-axis label
    ylabel('Amplitude')                         % y-axis label
    hold on;                                    % Hold figure for further plotting
    ax = plot([playHeadLoc playHeadLoc],...       % Line header tracker
        [-mag1 mag1], 'r', 'LineWidth', 2);       % ...
   
    subplot(2,2,2), plot(t, y(:,2), 'g');       % Plot right channel audio
    ylim([min(y(:,2))-0.1 max(y(:,2))+0.1])     % y-axis limits
    xlim([0 yL/Fs])                             % x-axis limits
    title(['Right Channel Audio    ',...        % Subplot title
        num2str(song_string)])                  % ...
    xlabel('Time (secs)')                       % x-axis label
    ylabel('Amplitude')                         % y-axis label
    hold on;                                    % Hold figure for further plotting
    ax1 = plot([playHeadLoc playHeadLoc],...      % Line header tracker
        [-mag2 mag2], 'r', 'LineWidth', 2);       % ...
    
    subplot(2,2,[3,4]),...
        spectrogram(song, 256, [], [], Fs/2, 'yaxis'),    % Plot spectrogram
    
    player = audioplayer(y, Fs);             % Send audio to player
    
    myStruct.frameT = frameT;                % Set frame rate
    
    myStruct.playHeadLoc = playHeadLoc;      % Track bar location
    myStruct.ax = ax;                        % ...
    myStruct.ax1 = ax1;                      % ...
    
    set(player, 'UserData', myStruct);          % Calls function for structured array 
    set(player, 'TimerFcn', @TRACKING_FUNC);    % Calls function for timing
    set(player, 'TimerPeriod', frameT);         % Calls function for frame rate of track bar
    
    
else                            % Else plot single channel audio
    
    subplot(2,1,1), plot(t, y)                  % Plot single channel audio
    ylim([min(y(:,1))-0.1 max(y(:,1))+0.1])     % y-axis limits
    xlim([0 yL/Fs])                             % x-axis limits
    title(['Single Channel Audio    ',...       % Subplot title
        num2str(song_string)])                  % ...
    xlabel('Time (secs)')                       % x-axis label
    ylabel('Amplitude')                         % y-axis label
    hold on;                                    % Hold figure for further plotting
    ax = plot([playHeadLoc playHeadLoc],...       % Line header tracker
        [-mag mag], 'r', 'LineWidth', 2);         % ...
    
    subplot(2,2,[3,4]),...
        spectrogram(song, 256, [], [], Fs/2, 'yaxis');    % Plot spectrogram
    
    player = audioplayer(y, Fs);            % Send audio to player
    
    myStruct.frameT = frameT;               % Set frame rate
    
    myStruct.playHeadLoc = playHeadLoc;     % Track bar location
    myStruct.ax = ax;                       % ...
    
    set(player, 'UserData', myStruct);          % Calls function for structured array 
    set(player, 'TimerFcn', @TRACKING_FUNC_s);  % Calls function for timing
    set(player, 'TimerPeriod', frameT);         %
        
end         % End if statement
    
    
    playblocking(player);       % Play the audio track
    close(hFig)                 % Close the figure
     
    
%% Animated spectrogram


% Initialisation

duration = a / Fs;              % Length of song in seconds

filename_string = char('3D Spectrogram %s.avi');    % Set the filename
name = song_string;                                 % Assign audio name
string_name = sprintf(filename_string, name);       % Set filename to an input

myVideo = vision.VideoFileWriter...           % Write video with audio
    (string_name,'AudioInputPort', true,...   % ...
    'VideoCompressor', 'MJPEG Compressor');   % ...

frameRate = 30;

Total_Frames = duration * frameRate;

Round_Elements = ceil(a / Total_Frames);

figure
h = figure('visible','off','position',[100,100,800,400]);
grid on

i = 1;          % Initialise i

k = (i + (Round_Elements) * 50)...              % Initialise k
    * (i + (Round_Elements) * 50 < a) + a...    % ...
    * (i + (Round_Elements) * 50 >= a);         % ...

if b == 2           % If dual channel audio
    
    [~,F,T,P] = spectrogram(y(i:k,1),200,80,200,10);   % Plot positive (+x) range spectrogram 
    
    surf(T,F(1:40,1),10*log10(P(1:40,:)),...            % Convert spectrogram to a 3D image
        'edgecolor','none'); axis tight;                % ...
    
    [S,F,T,P] = spectrogram(y(i:k,2),200,80,200,10);   % Plot negative (-x) range spectrogram 
    
    surf(T,F(1:40,1),10*log10(P(1:40,:)),...            % Convert spectrogram to a 3D image
        'edgecolor','none'); axis tight;                % ...
    
else                % Else single channel audio
    
    [~,F,T,P] = spectrogram(y(i:k,1),200,80,200,10);   % Plot spectrogram
    
    surf(T,F(1:40,1),10*log10(P(1:40,:)),...            % Convert spectrogram to a 3D image
        'edgecolor','none'); axis tight;                % ...
    
end

view(145,65)
axis auto
colormap hot

print('-dtiff','-r90','temp')       % High resolution image (.tif)
[X,map] = imread('temp.tif');       % Read the image (.tif)

F = im2frame(X,map);                % Write the initial image

for ik = 1:Total_Frames             % For 1 to Total_Frames
    
    if b == 2               % Dual channel audio
        
        [~,F,T,P] = spectrogram(y(i:k,1),200,80,200,10);    % Plot spectrogram
        
        surf(T,F(1:40,1),10*log10(P(1:40,:)),...     % Convert spectrogram to a 3D image
            'edgecolor','none'); axis tight;         % ...
        
        hold on
                
        [S,F,T,P] = spectrogram(y(i:k,2),200,80,200,10);    % Plot spectrogram
        
        surf(T,-F(1:40,1),10*log10(P(1:40,:)),...    % Convert spectrogram to a 3D image
            'edgecolor','none'); axis tight;         % ...
        
        set(gca,'xticklabel',[])
        zlim([-100, 0])
        
    else                    % Single channel audio
        
        [~,F,T,P] = spectrogram(y(i:k,1),200,80,200,10);    % Plot spectrogram
        
        surf(T,F(1:40,1),10*log10(P(1:40,:)),...     % Convert spectrogram to a 3D image
            'edgecolor','none'); axis tight;         % ...
        
        set(gca,'xticklabel',[])
        
    end 
    
    hold off
    title(['3D Spectrogram of ', num2str(song_string)])
    xlabel('Time --->')
    ylabel('Amplitude');
    zlabel('Power (dB) / Frequency (Hz)')
    zlim([-100, 0])
    view(125,55)
    
    print('-dtiff','-r90','temp')       % Export image file (.tif)
    frame = imread('temp.tif');       % Read the image file
    
    step(myVideo,frame,y(i:Round_Elements*ik));
   
    i = (i + Round_Elements) *...                   % Update i
        (i + (Round_Elements) < a ) +...            % ...
        a * (i + (Round_Elements) >= a);            % ...
    
    k = (i + ceil(a/Total_Frames) * 30) *...        % Update k
        (i + ceil(a/Total_Frames) * 30 <a ) +...    % ...
        a * (i + ceil(a/Total_Frames) * 30 >= a);   % ...
    
end

set(gcf,'visible','on');                % 
close (gcf)                             % Close the figure from further editing
release(myVideo)
end         % End if statement
end         % End of function






