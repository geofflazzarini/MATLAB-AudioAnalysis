function [ filename ] = RECORD_FUNC (song_string)
% This function records your microphone for the desired time.

% The function then saves the recording as a .wav file under the date and
% time the recording was made.

% The function is currently set as an auxiliary for the main
% function AUDIOVIS.

    prompt = 'How many seconds would you like to record for? ';     % Input prompt
    TIME = input(prompt);                                           % ...
    prompt = 'Single(1) or Dual(2) Channel Audio? ';                % Input prompt
    Channels = input(prompt);                                       % ...
    Fs = 8000;                                                      % Frequency of sample

if strcmpi(song_string, 'record')               % If song_string = record
       
    MyRec = audiorecorder(Fs,24,Channels);      % Initialise the microphone
    
    disp('Begin Recording...')                  % Display text
    
    recordblocking(MyRec, TIME);                % Record microphone
    
    y = getaudiodata(MyRec);                    % Transfer audio data into array
       
    disp('Finished Recording')      % Display text
           
end                 % End if statement

    filename = datestr(now, 'dd-mmm-yyyy-HH-MM.wav');     % Set filename to current time and date
    audiowrite(filename, y, Fs)                           % Write the recorded audio

end                 % End of function




