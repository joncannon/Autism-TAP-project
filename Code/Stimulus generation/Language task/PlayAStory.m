function PlayAStory


% Standard coding practice, use try/catch to allow cleanup on error.
try
    clc;
    
    
    % Say hello in command window
    fprintf('\nPlayingAStory\n');
    
    % Get the list of screens and choose the one with the highest screen number.
    % Screen 0 is, by definition, the display with the menu bar. Often when
    % two monitors are connected the one without the menu bar is used as
    % the stimulus display.  Chosing the display with the highest dislay number is
    % a best guess about where you want the stimulus displayed.
    screenNumber=max(Screen('Screens'))

  

    % Find the color values which correspond to white and black.
    gray=GrayIndex(screenNumber)-0.5; 
    
      % Open a double buffered fullscreen window and draw a gray background
    % and front and back buffers.
    [w, wRect]=Screen('OpenWindow',screenNumber, gray);

   
    % Blank sceen
    Screen('FillRect',w, uint8(gray));
    Screen('Flip', w);

    % Bump priority for speed        
	priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
    % Load images you will use (labeled 'SlideX')
    for i=1:9
        
    myimgfile = ['Slide' num2str(i) '.JPG'];
    fprintf('Using image ''%s''\n', myimgfile);
    imdata=imread(myimgfile);
    
    
    images{i} = imdata;
    end
    
    
    
    %Open parallel port
    
    ioObject = io64;
    LPT1address = hex2dec('D010'); %standard location of LPT1 port
    status = io64(ioObject);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Load codes
    Codes = readmatrix('CodeInfo.csv');
    [t,c] = size(Codes);

    % Load story file
    [y, fs] = audioread('Story_audio1n.wav');
    FirstHalf = audioplayer(y, fs);
    
    %Load codes
    Codes2 = readmatrix('CodeInfo2.csv');
    [t2,c2] = size(Codes2);

    % Load story file
    [y2, fs2] = audioread('Story_audio2n.wav');
    SecondHalf = audioplayer(y2, fs2);
    
    fprintf('\nPress anything to start\n');
    
    titleImage = ['Slide0.JPG'];
    titleImage = imread(titleImage);
    Screen('PutImage', w, titleImage); % put image on screen
    Screen('Flip',w);

    
    GetClicks(w);
    
    %Start story
    play(FirstHalf);
    io64(ioObject,LPT1address,'14');

for i = 1:t
    pause(Codes(i,1));
    io64(ioObject,LPT1address,Codes(i,2));
    if i == 125
        pause(0.8);
        tic;
        Screen('PutImage', w, images{1}); % put image on screen
        Screen('Flip',w);
        Codes(i+1,1)=Codes(i+1,1)-toc-0.8
    elseif i == 346
        pause(0.8);
        tic;
        Screen('PutImage', w, images{2}); % put image on screen
        Screen('Flip',w);
        Codes(i+1,1)=Codes(i+1,1)-toc-0.8
    elseif i == 862
        pause(0.8);
        tic;
        Screen('PutImage', w, images{3}); % put image on screen
        Screen('Flip',w);
        Codes(i+1,1)=Codes(i+1,1)-toc-0.8;
    elseif i == 1875
        pause(0.8);
        tic;
        Screen('PutImage', w, images{4}); % put image on screen
        Screen('Flip',w);
        Codes(i+1,1)=Codes(i+1,1)-toc-0.8;
    end 
end

stop(FirstHalf);

%%%%%%%%%%%%%%%%%%%%%


    
    fprintf('\nPress anything to start second half\n');
    
    GetClicks(w);
    
    %Start story
    play(SecondHalf);
    io64(ioObject,LPT1address,'15');
    

for i = 1:t2
    pause(Codes2(i,1));
    io64(ioObject,LPT1address,Codes2(i,2));
    if i == 489
        pause(0.8);
        tic;
        Screen('PutImage', w, images{5}); % put image on screen
        Screen('Flip',w);
        Codes2(i+1,1)=Codes2(i+1,1)-toc-0.8;
    elseif i == 703
        pause(0.8);
        tic;
        Screen('PutImage', w, images{6}); % put image on screen
        Screen('Flip',w);
        Codes2(i+1,1)=Codes2(i+1,1)-toc-0.8;
    elseif i == 1323
        pause(0.8);
        tic;
        Screen('PutImage', w, images{7}); % put image on screen
        Screen('Flip',w);
        Codes2(i+1,1)=Codes2(i+1,1)-toc-0.8;
    elseif i == 1713
        pause(0.8);
        tic;
        Screen('PutImage', w, images{8}); % put image on screen
        Screen('Flip',w);
        Codes2(i+1,1)=Codes2(i+1,1)-toc;
    end
end

stop(SecondHalf);

Screen('PutImage', w, images{9}); % put image on screen
Screen('Flip',w)
        
fprintf('\nPress anything to end\n');


GetClicks(w);   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear io64;
Priority(0); 
Screen('CloseAll'); % close screen

    % The same command which closes onscreen and offscreen windows also
    % closes textures.

    

% This "catch" section executes in case of an error in the "try" section
% above.  Importantly, it closes the onscreen window if it's open.
catch

    sca;
    ShowCursor;
    Priority(0);
    
    psychrethrow(psychlasterror);
end
