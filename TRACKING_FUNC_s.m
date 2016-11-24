function src = TRACKING_FUNC_s(src, eventdata)
% This function... single audio


    myStruct = get(src, 'UserData');            % Open data

       newPlayHeadLoc = ...
        myStruct.playHeadLoc + ...
        myStruct.frameT;
        set...
            (myStruct.ax, 'Xdata', [newPlayHeadLoc newPlayHeadLoc])       
        myStruct.playHeadLoc = newPlayHeadLoc;
    
    set(src, 'UserData', myStruct);             % Close data
    
end