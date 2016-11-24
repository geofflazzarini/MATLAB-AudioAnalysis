function src = TRACKING_FUNC(src, eventdata)
% This function... dual(stereo) audio


    myStruct = get(src, 'UserData');            % Open data into a structured array

       newPlayHeadLoc = ...
        myStruct.playHeadLoc + ...
        myStruct.frameT;
        set...
            (myStruct.ax, 'Xdata', [newPlayHeadLoc newPlayHeadLoc])       
        myStruct.playHeadLoc = newPlayHeadLoc;
    
    set(src, 'UserData', myStruct);             % Close data into a structured array
    
    
    myStruct = get(src, 'UserData');            % Open data into a structured array

       newPlayHeadLoc1 = ...
        myStruct.playHeadLoc + ...
        myStruct.frameT;
        set...
            (myStruct.ax1, 'Xdata', [newPlayHeadLoc1 newPlayHeadLoc1])        
        myStruct.playHeadLoc1 = newPlayHeadLoc1;
    
    set(src, 'UserData', myStruct);             % Close data into a structured array
    
end