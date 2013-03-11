function wbar = guiStartWaitBar(value, text)
% wbar = guiStartWaitBar(value, text)
% Shows progress bar. 

%wbar = 0;
wbar = waitbar(value, text);
