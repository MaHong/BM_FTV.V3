function BmFTV
% Test whether the memory load will influence FTA/FA judgement
try
    % get basic subinfo
    [subID, name, sex, age] = tinputdialog;
            
    %Screen setup %
    clear InputName MovieData
    AssertOpenGL;
    InitializeMatlabOpenGL;
    PsychImaging('PrepareConfiguration');
    Screen('Preference', 'SkipSyncTests', 1);
    screenNumber=max(Screen('Screens'));
    [w, wRect] = PsychImaging('OpenWindow', screenNumber, 0);
    frame_duration = Screen('GetFlipInterval',w);
    Screen(w,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    MovieFrames = 30;
    maker = 12 ;
    square_width = 1;
    [a,b]=WindowCenter(w);
    
    %3D set up
    threedparametersetupfun(w,wRect);
        
    % Screen priority
    priorityLevel=MaxPriority(w);
    Priority(priorityLevel);
    
    % coordinates
    cm2pixel = 30; %convert centimeter to pixel
    CoodinateScale = 0.35; 
    spaceofstimulus = 7;
    Rcircle=spaceofstimulus * cm2pixel;
    % positions
    n=1;
    NumSplit=6;
    PerDegree= (360/NumSplit)/180 * pi;%Convert to Pi
    for i=1:NumSplit
        MovieCntre(n,:) = [a+Rcircle*cos(i*PerDegree)   b+Rcircle*sin(i*PerDegree)];
        n=n+1;
    end
    keysetup = tkeyboardsetup;
    inssetup = tinstructionsetup(w);
    
    %input file==================================    
    % for point-light Rectangle
    rectanglepath = 'rec-xls\';
    imgformatsuffix = '.xls';
    filelist = {'bothopen','leftrotate','rightopen','upopen','uprightopen',...
                'urotatebopen','lrotateruopen','reverseopen','rrotate'};
    inputfilepath = strcat( rectanglepath, filelist,imgformatsuffix );
    InputName = inputfilepath;
    for i=1:length(InputName)
        MovieData{i} = xlsread(InputName{i});
    end
    
    % FOR FTV生物运动数据
    ftvparas = tinputparameterfun('walking.txt');
    %End input file================================== 
    
    % Run experiment================================== 
     HideCursor;
     pos = [(a-inssetup.startRect(3)/2) b-inssetup.startRect(4)/2 a+inssetup.startRect(3)/2 b+inssetup.startRect(4)/2];
    
    %练习阶段指导语
    ShowInstruction(w,inssetup.start,inssetup.base,pos, mod(subID,2)==1);
    
    %学习FTV/FA
    DisplayPLWalker(w,wRect,ftvparas,1,3000);
    PushImages(w,pos,inssetup.FW);
    ResponseforPLJudgment(keysetup.back);
    DisplayPLWalker(w,wRect,ftvparas,20,4000);
    PushImages(w,pos,inssetup.FTV);
    ResponseforPLJudgment(keysetup.forward);
    
    %练习阶段
    PushImages(w,pos,inssetup.practiceStart);
    WaitSecs(1.5);
    StimulasInterval (w,1,frame_duration);
    RunExperiment(w,wRect,24,frame_duration,maker,...
    NumSplit,MovieCntre,ftvparas,inssetup,pos,keysetup,...
    subID,MovieFrames,a,b,12,1,inssetup.practiceOver,...
    MovieData,square_width,CoodinateScale);

    %正式实验
    ShowInstruction(w,inssetup.start,inssetup.base,pos, mod(subID,2)==1);
    [answer_code,rtime,response_code,tasktype] = RunExperiment(w,wRect,length(ftvparas.condition),frame_duration,maker,...
    NumSplit,MovieCntre,ftvparas,inssetup,pos,keysetup,...
    subID,MovieFrames,a,b,48,2,inssetup.over,...
    MovieData,square_width,CoodinateScale);

    %结束实验
    Screen('Flip',w);
    WaitSecs(1.5);
    Priority(0);
    Screen('Close',w);
    ShowCursor;
    
    %输出结果
    fid = fopen(['results/' name '_BM_FTV_formal.txt'],'w');
    fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
        'Name','subID','Sex','Age','Trial','Change','Acc',...
        'RT','distance','FTV','Tasktype');
    for j = 1:length(response_code)
        fprintf(fid,'%s\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%3.0f\t%4.4f\t%3.0f\t%3.0f\t%3.0f\n',...
        name,subID,sex,age,j,str2num(ftvparas.condition{j}(2)),response_code(j)==str2num(ftvparas.condition{j}(2))+1,...
        rtime(j),ftvparas.TrialType(str2num(ftvparas.condition{j}(1))),answer_code(j),tasktype(j));
    end
    fclose(fid);
    clear all
catch
    
    Screen('Closeall')
    rethrow(lasterror)
    clear all
end





