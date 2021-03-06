function [answer_code,rtime,response_code,tasktype]= RunExperiment(w,wRect,tiralnum,frame_duration,maker,...
    NumSplit,MovieCntre,ftvparas,inssetup,pos,keysetup,...
    subID,MovieFrames,a,b,resttrial,experimenttype,image,...
    MovieData,square_width,CoodinateScale)
% practice
%@tiralnum = 24
%@resttrial = 12
%@experimenttype = 1
trialtype = 1;
%@image = inssetup.practiceOver

% formal
%@tiralnum = length(ftvparas.condition)
%@resttrial = 48
%@experimenttype = 2
experimenttype = 2;
%@image = inssetup.over

tasktype = zeros(tiralnum);
for trial = 1:tiralnum
    InitializeMatlabOpenGL;
    
    % fixation300ms
    Screen('FillRect', w, [0,0,0]);
    Screen('DrawText',w, '+',a ,b,[255,0,0]);
    Screen('Flip',w);
    StimulasInterval (w,0.3,frame_duration);
    
    % define the position of the memory display
    position_index = randperm(NumSplit);% Randomized the positions
    position_presentation = zeros(NumSplit,2);% 5*2 zero vector
    for i=1:NumSplit
        position_presentation(i,1) = MovieCntre(position_index(i),1);
        position_presentation(i,2) = MovieCntre(position_index(i),2);
    end
    
    %display the memory array
    InputNameIndex = randperm(9); %random the stimuli
    SetSize = str2num(ftvparas.condition{trial}(3));
    %NumMovie=4;
    actionreapettimes = 3;
    for rp=1:actionreapettimes
        for i=1:MovieFrames
            for MovieIndex=1:SetSize
                for j=1:maker
                    Screen('FillRect', w ,[255 255 255],...
                        [position_presentation(MovieIndex,1)-CoodinateScale*MovieData{InputNameIndex(MovieIndex)}((12*(i-1)+j),2)-square_width...
                        position_presentation(MovieIndex,2)-CoodinateScale*MovieData{InputNameIndex(MovieIndex)}((12*(i-1)+j),3)-square_width...
                        position_presentation(MovieIndex,1)-CoodinateScale*MovieData{InputNameIndex(MovieIndex)}((12*(i-1)+j),2)+square_width...
                        position_presentation(MovieIndex,2)-CoodinateScale*MovieData{InputNameIndex(MovieIndex)}((12*(i-1)+j),3)+square_width]);
                end
            end
            Screen('Flip',w);
            for MovieIndex=1:SetSize  % run the same code twice to make the actions move slower
                for j=1:maker
                    Screen('FillRect', w ,[255 255 255],...
                        [position_presentation(MovieIndex,1)-CoodinateScale*MovieData{InputNameIndex(MovieIndex)}((12*(i-1)+j),2)-square_width...
                        position_presentation(MovieIndex,2)-CoodinateScale*MovieData{InputNameIndex(MovieIndex)}((12*(i-1)+j),3)-square_width...
                        position_presentation(MovieIndex,1)-CoodinateScale*MovieData{InputNameIndex(MovieIndex)}((12*(i-1)+j),2)+square_width...
                        position_presentation(MovieIndex,2)-CoodinateScale*MovieData{InputNameIndex(MovieIndex)}((12*(i-1)+j),3)+square_width]);
                end
            end
            Screen('Flip',w);
        end
    end
    
    StimulasInterval (w,0.3,frame_duration);
    
    clearinputkeyqueue;
    % show the distance judgement part 
    DisplayPLWalker(w,wRect,ftvparas,ftvparas.distanceArray(ftvparas.TrialType(str2num(ftvparas.condition{trial}(1)))), 3000)
    % get the FTV/W judgement
    [answer_codeval] = GetFTVJudgementResponse(w,inssetup,pos,keysetup);
    answer_code(trial) = answer_codeval;
    
    clearinputkeyqueue;
    % show the bm memory test array
    start_time=GetSecs;
        if(     ( experimenttype==trialtype&&(xor(mod(subID,2)==1,trial>=resttrial)) )||...
            ( experimenttype==experimenttype&&(xor(mod(subID,2)==1,(trial>resttrial&&trial<=resttrial*3)  )) ) )
        while GetSecs - start_time < 3
            if str2num(ftvparas.condition{trial}(2))==0     %% bm no change
                [rtimeval,response_codeval,terminateflag] = GetBMtestResponse(w,MovieFrames,a,b,keysetup,SetSize,...
                                                                              square_width,MovieData,CoodinateScale,maker,InputNameIndex);
                rtime(trial) = rtimeval;
                response_code(trial)=response_codeval;
                if terminateflag==1
                    break;
                end
            else                                   %% bm change
                [rtimeval,response_codeval,terminateflag] = GetBMtestResponse(w,MovieFrames,a,b,keysetup,(SetSize+1),...
                                                                              square_width,MovieData,CoodinateScale,maker,InputNameIndex);
                rtime(trial) = rtimeval;
                response_code(trial) = response_codeval;
                if terminateflag==1
                    break;
                end
            end  %end if
        end %end -while
        tasktype(trial) = 1;%记忆任务
        else   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%unload 条件  基线水平
            while GetSecs - start_time < 3
                if str2num(ftvparas.condition{trial}(2))==0     %% bm no change
                    [rtimeval,response_codeval,terminateflag] =  GetBaseResponse(w,trial,ftvparas,MovieFrames,a,b,keysetup,...
                                                                                 square_width,MovieData,CoodinateScale,maker,SetSize,InputNameIndex);
                    rtime(trial) = rtimeval;
                    response_code(trial)=response_codeval;
                    if terminateflag==1
                        break;
                    end
                else                                   %% bm change
                    [rtimeval,response_codeval,terminateflag] =  GetBaseResponse(w,trial,ftvparas,MovieFrames,a,b,keysetup,...
                                                                                 square_width,MovieData,CoodinateScale,maker,(SetSize+1),InputNameIndex);
                    rtime(trial) = rtimeval;
                    response_code(trial)=response_codeval;
                    if terminateflag==1
                        break;
                    end
                end  
            end
        tasktype(trial) = 0;%控制条件
    end
    
    [keyisdown,secs,keycode] = KbCheck;
    if keycode(keysetup.escapekey)
        rtime(trial) = GetSecs - start_time;
        response_code(trial) = 3;
        break
    end
    
    if ~(  (response_code(trial)==str2num(ftvparas.condition{trial}(2))+1)|| (response_code(trial) == 4)  )
        PushImages(w,pos,inssetup.miss);
        WaitSecs(0.2);
    end
    Screen('Flip',w);
    
    clearinputkeyqueue;
    StimulasInterval (w,1,frame_duration)
    
    %rest
    if (mod(trial,resttrial)==0 && trial~=tiralnum)
        PushImages(w,pos,inssetup.rest);
        clearinputkeyqueue;
        KbWait;
        WaitSecs(2);
        Screen('Flip',w);
        
        % begin the instructionimg for the other block
        checkcondition = ( experimenttype==trialtype&&(mod(subID,2)==1) )||...
            ( experimenttype==experimenttype&&(xor(mod(subID,2)==1, trial==144)) ) ;
        ShowInstruction(w,inssetup.basetwo,inssetup.starttwo,pos,checkcondition );
 
    end
end

clearinputkeyqueue;
PushImages(w,pos,image)
KbWait;
Screen('Flip',w);
WaitSecs(2);
end