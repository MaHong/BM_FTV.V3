function [rtimevalue,response_codevalue,flag] = GetBMtestResponse(w,MovieFrames,a,b,...
    keysetup,testid,square_width,MovieData,CoodinateScale,maker,InputNameIndex)
% get the keyresponse of BM test array
% for nochange
% @testid = 1

% for change
% @testid = SetSize+1
% index start from NumMovie+1 is unused in the previous action playing.

flag = 0;
start_time = GetSecs;
actionsreaptimes = 3;
for np=1:actionsreaptimes
    if flag==1;
        break;
    end
    for i=1:MovieFrames
        if flag==1;
            break;
        end
        MovieIndex= InputNameIndex(testid);
        %Screen('DrawTexture',w,act{InputNameIndex(testid)}{i},[],[a-110 b-90 a+110 b+90]);
        for j=1:maker
            Screen('FillRect', w ,[255,0,0], ...
                [a-CoodinateScale*MovieData{MovieIndex}((12*(i-1)+j),2)-square_width ...
                b-CoodinateScale*MovieData{MovieIndex}((12*(i-1)+j),3)-square_width...
                a-CoodinateScale*MovieData{MovieIndex}((12*(i-1)+j),2)+square_width ...
                b-CoodinateScale*MovieData{MovieIndex}((12*(i-1)+j),3)+square_width] );
        end %end-maker
        Screen('Flip',w);
        for j=1:maker   % repeat the same codes to slow the actions
            Screen('FillRect', w ,[255,0,0], ...
                [a-CoodinateScale*MovieData{MovieIndex}((12*(i-1)+j),2)-square_width ...
                b-CoodinateScale*MovieData{MovieIndex}((12*(i-1)+j),3)-square_width...
                a-CoodinateScale*MovieData{MovieIndex}((12*(i-1)+j),2)+square_width ...
                b-CoodinateScale*MovieData{MovieIndex}((12*(i-1)+j),3)+square_width] );
        end %end-maker
        Screen('Flip',w);
        
        
        [keyisdown,secs,keycode] = KbCheck;
        WaitSecs(0.001); % delay to prevent CPU hogging
        
        if keycode(keysetup.escapekey)
            flag=1;
            rtimevalue = GetSecs - start_time;
            response_codevalue = 3;%被试按键退出
            %'print escape'
            break
        end
        if keycode(keysetup.F)
            flag=1;
            rtimevalue = GetSecs - start_time;
            response_codevalue = 2;
            %'print F'
            break
        end
        if keycode(keysetup.J)
            flag=1;
            rtimevalue = GetSecs - start_time;
            response_codevalue = 1;
            %'print J'
            break
        end
        rtimevalue = GetSecs - start_time;
        response_codevalue = 5;%被试没有按键
        
    end
    
end
flag = 1;
end