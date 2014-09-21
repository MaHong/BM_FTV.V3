function [rtimevalue,response_codevalue,flag] =  GetBaseResponse(w,trial,ftvparas,MovieFrames,a,b,keysetup,...
                                                                 square_width,MovieData,CoodinateScale,maker,testid,InputNameIndex)

flag = 0;
start_time = GetSecs;
actionsreaptimes = 3;

if str2num(ftvparas.condition{trial}(2))==0 || str2num(ftvparas.condition{trial}(2))==1 %无论记忆项是否变化
    for np=1:actionsreaptimes
        if flag==1;
            break;
        end
        for i=1:MovieFrames
            if flag==1;
                break;
            end
            MovieIndex= InputNameIndex(testid); 
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
            WaitSecs(0.001);
            if keycode(keysetup.confirm)
                flag=1;
                rtimevalue = GetSecs - start_time;
                response_codevalue = 4;
                break
            end
            if keycode(keysetup.escapekey)
                flag=1;
                rtimevalue = GetSecs - start_time;
                response_codevalue = 3;%被试按键退出
                break
            end
            rtimevalue = GetSecs - start_time;
            response_codevalue = 5;%被试没有按键
        end
        
    end
    flag = 1;
end 
end