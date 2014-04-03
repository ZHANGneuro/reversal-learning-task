%Instrumental Learning Task with Multiple Reversals
%3/16/14 - TO wrote the script

function rlt()

Screen('Preference', 'SkipSyncTests', 1);
[wPtr,wRect] = Screen('OpenWindow', 0, [0 0 0]); % define a 'window' for the experiment, [0 0 0] means setting blackground color as 'black' 
w = wRect(RectRight);
h = wRect(RectBottom);
screen_resolution = get(0,'ScreenSize');
font_size = round(sqrt(screen_resolution(3)));  % define font size according to the third element of screen resolution array. 
KbName('UnifyKeyNames');  % for the compatibility of PC and Mac.
HideCursor(0);
quitkey = KbName('escape');
left_key = KbName('Z');
right_key = KbName('M');
GCS_image = imread('./images/GCS.jpg');% GCS & BCS here represents the two fractals, you can replace these two images for your experiment.
BCS_image = imread('./images/BCS.jpg');
textcolor=WhiteIndex(wPtr);   % text color is white as screen background is set to black

%ACQUISITION
selected = 0; %no stimuli selected by participant at start of trial
prare = 0.3; %probability that trial type is rare
trial = 0; %trial type set to zero at start of each trial
% stimtime = 2000; % time allotted to select stimulus
% rewardceiling = 15; %determines the largest taskobject number that can be used for reward values
% rewardfloor = 5;  %determines the smallest taskobject number that can be used for reward values
A_reward = 5;
A_punish = -5;

%make note of whether trial was a win or loss
TrialType = cell(95,1);

%Loss trials are 0 and Win trials are 1.
% if ~isfield(TrialRecord, 'TrialType'),
%     TrialRecord.TrialType=[];
% end

% the key subject pressed for each trial.
key_pressed = cell(95,1);

%make note of how much participant gains or loses during each trial
RewardValue = cell(95,1);

% if ~isfield(TrialRecord, 'RewardValue'),
%     TrialRecord.RewardValue=[];
% end

%Taskobjects are defined in the conditions (.txt) file.
%Each participant will be assigned to condition 1 or 2 and will only view trials from the designated condition.
%Taskobjects 1 and 3 are identical, but appear on different sides of the screen.
%Taskobjects 2 and 4 are identical, but appear on different sides of the screen.

%determine which taskobject will be ?Good CS?
% GCS = 1; %Taskobject 1 is the GCS
% img1 = GCS_image;
% if rand(1) < 0.5
%     GCS = 3; %The GCS will change spatial positioning on 50% of trials
%     img2 = GCS_image;
% end
%
% %Bad CS gets other number
% BCS = 2; %BCS defaults to taskobject 2
% img2 = BCS_image;
% if GCS == 3
%     BCS = 4; %if the GCS is on the right, BCS must switch to the left position
%     img1 = BCS_image;
% end



% w = []; %may be unnecessary to define matrix
for p = 1:20 %20 trials within acquisition session
    
    fifty_prob = rand(1);
    if fifty_prob >= 0.5
        GCS = 'on left'; %Taskobject 1 is the GCS
        img1 = GCS_image;
        img2 = BCS_image;
    end
    if fifty_prob < 0.5
        GCS = 'on right'; %The GCS will change spatial positioning on 50% of trials
        img2 = GCS_image;
        img1 = BCS_image;
    end
    %determine trial type
    if rand(1) < prare
        trial = 1; %trial type set to rare
    end
    %if trial type not set to rare, it defaults to normal (means trial = 0)
    
    %places fixation dot, stimuli, and choice instructions on screen
    
    [y, x, depth] = size(GCS_image);
    x = w/7;
    y= 600*x/561;  %  the image demension is 561 * 600.
    
    t1 = Screen('MakeTexture', wPtr, img1);
    t2 = Screen('MakeTexture', wPtr, img2);
    
    Screen('DrawTexture', wPtr, t1, [], [w/2-300*w/1000, h/2-h/25-y/2, w/2-300*w/1000+x, h/2-h/25+y/2]);
    Screen('DrawTexture', wPtr, t2, [], [w/2+300*w/1000-x, h/2-h/25-y/2, w/2+300*w/1000, h/2-h/25+y/2]);
    Screen('TextSize',wPtr, font_size);
    Screen('TextStyle',wPtr, 1);
    [nx, ny, bbox] = DrawFormattedText(wPtr, '+',  w/2, h/2-h/15, textcolor);
    Screen('TextSize',wPtr, font_size);
    [nx, ny, bbox] = DrawFormattedText(wPtr, 'Please make a choice', 'center', 85*h/100, textcolor);
    Screen('Flip',wPtr);
    % toggleobject(fix);
    % toggleobject(GCS);
    % toggleobject (BCS);
    % toggleobject (choiceinstructions);
    % idle(2000); %instructions on screen for 2 seconds
    % toggleobject(fix); %fixation dot leaves screen
    % toggleobject (choiceinstructions); %instructions leave screen
    % hotkey(z, selected == left) && hotkey(m, selected == right); %defines possible keyboard strokes
    % idle(stimtime); %wait for participant?s choice
    % clear hotkey %participant cannot choose after stimtime IMPORTANT NOTE: if participant selects button immediately, it still takes "stimtime" for outcome to appear
    %
    %check for errors
    %     if selected == 0
    %         then %WHAT HAPPENS DURING TRIAL ERROR?
    %     end
    %SHOULD AN ERROR OCCUR IF BOTH KEYS ARE PRESSED OR DEFAULT TO LAST SELECTED
    %KEY?
    
    %check which key participant selected and position of stimuli to determine
    %if good or bad stimulus was selected
    
    while 1
        [secs, keyCode, deltaSecs] = KbWait;
        if keyCode(quitkey)
            Screen(wPtr,'Close');
            close all
            return;
        end
        if keyCode(left_key)
            selected = 1;
            Screen('DrawTexture', wPtr, t1, [], [w/2-300*w/1000, h/2-h/25-y/2, w/2-300*w/1000+x, h/2-h/25+y/2]);
            Screen('DrawTexture', wPtr, t2, [], [w/2+300*w/1000-x, h/2-h/25-y/2, w/2+300*w/1000, h/2-h/25+y/2]);
            Screen('TextSize',wPtr, font_size);
            Screen('TextStyle',wPtr, 1);
            [nx, ny, bbox] = DrawFormattedText(wPtr, '+',  w/2, h/2-h/15, textcolor);
            Screen('TextSize',wPtr, font_size);
            [nx, ny, bbox] = DrawFormattedText(wPtr, 'Please make a choice', 'center', 85*h/100, textcolor);
            Screen('FrameRect', wPtr, textcolor,[w/2-300*w/1000, h/2-100*w/1000, w/2-300*w/1000+x, h/2-100*w/1000+y], 10)
            Screen('Flip',wPtr);
            break;
        end
        if keyCode(right_key)
            selected = 2;
            Screen('DrawTexture', wPtr, t1, [], [w/2-300*w/1000, h/2-h/25-y/2, w/2-300*w/1000+x, h/2-h/25+y/2]);
            Screen('DrawTexture', wPtr, t2, [], [w/2+300*w/1000-x, h/2-h/25-y/2, w/2+300*w/1000, h/2-h/25+y/2]);
            Screen('TextSize',wPtr, font_size);
            Screen('TextStyle',wPtr, 1);
            [nx, ny, bbox] = DrawFormattedText(wPtr, '+',  w/2, h/2-h/15, textcolor);
            Screen('TextSize',wPtr, font_size);
            [nx, ny, bbox] = DrawFormattedText(wPtr, 'Please make a choice', 'center', 85*h/100, textcolor);
            Screen('FrameRect', wPtr, textcolor,[w/2+300*w/1000-x, h/2-100*w/1000, w/2+300*w/1000, h/2-100*w/1000+y], 10)
            Screen('Flip',wPtr);
            break;
        end
    end
    
    if selected == 1 && strcmp(GCS,'on left')
        CS = 'good';
        key_pressed{p,1} = 'leftselected';
        %         toggleobject(leftselected); %box appears around selected stimulus
    elseif selected == 1 && strcmp(GCS,'on right')
        CS = 'bad';
        key_pressed{p,1} = 'leftselected';
        %         toggleobject(leftselected);
    elseif selected == 2 && strcmp(GCS,'on left')
        CS = 'bad';
        key_pressed{p,1} = 'rightselected';
        %         toggleobject(rightselected);
    elseif selected == 2 && strcmp(GCS,'on right')
        CS = 'good';
        key_pressed{p,1} = 'rightselected';
        %         toggleobject(rightselected);
    end
    
    WaitSecs(2); %after 2 seconds, all stimuli leave screen
    %     toggleobject([GCS BCS leftselected rightselected], 'off')
    
    %check which stimulus is selected and the trial type (normal or rare) to
    %determine if the trial will result in a win or loss
    if strcmp(CS, 'good') && trial == 0
        run = 'win';
        TrialType{p,1} = 'normal';
        %         TrialRecord.TrialType(end+1)=1; %makes a note of whether trial is a win or loss
    elseif strcmp(CS, 'good') && trial == 1
        run = 'loss';
        TrialType{p,1} = 'rare';
        %         TrialRecord.TrialType(end+1)=0;
    elseif strcmp(CS, 'bad') && trial == 0
        run = 'loss';
        TrialType{p,1} = 'normal';
        %         TrialRecord.TrialType(end+1)=0;
    elseif strcmp(CS, 'bad') && trial == 1
        run = 'win';
        TrialType{p,1} = 'rare';
        %         TrialRecord.TrialType(end+1)=1;
    end
    
    %tells the participant that they won or lost money
    if strcmp(run,'win')
        Screen('TextSize',wPtr, font_size);
        [nx, ny, bbox] = DrawFormattedText(wPtr, 'WON $5', 'center', h/2-h/15, textcolor);
        RewardValue{p,1} = '5';
        Screen('Flip',wPtr);
        %         toggleobject(reportwin);
    elseif strcmp(run,'loss')
        Screen('TextSize',wPtr, font_size);
        [nx, ny, bbox] = DrawFormattedText(wPtr, 'LOST $5', 'center', h/2-h/15, textcolor);
        RewardValue{p,1} = '-5';
        Screen('Flip',wPtr);
        %         toggleobject(reportloss);
    end
    
    %     rewardval=randi([rewardfloor,rewardceiling]); %The value of the reward (or loss) is set to any number between "rewardfloor" and "rewardceiling"
    %     toggleobject(rewardval); %presents the reward value (or loss value) to the participant
    %     TrialRecord.RewardValue(end+1)=rewardval; %makes a note of the reward value for the experimenter
    
    WaitSecs(2); %everything leaves screen after 2 seconds
    %     toggleobject(rewardvalue);
    %     toggleobject([reportwin reportloss], 'off')
    
    Screen('TextSize',wPtr, font_size);
    Screen('TextStyle',wPtr, 1);
    [nx, ny, bbox] = DrawFormattedText(wPtr, '+',  w/2, h/2-h/15, textcolor);
    Screen('Flip',wPtr);
    
    %ITI
    ITI = randi([8,12]);
    WaitSecs(ITI);
    %     toggleobject(fix);
    %     idle(randi([8,12])*1000);
    %     toggleobject(fix);
end

% ALL REVERSAL #1 2, and 3 in one loop

%In reversal 1, GCS must be taskobject 2 or 4
% if GCS == 1;
%     GCS = 2;
% end
%
% if rand(1) < 0.5
%     GCS = 4; %The GCS will change spatial positioning on 50% of trials
% end
%
% %Bad CS gets other number
% BCS = 1; %BCS defaults to taskobject 1
% if GCS == 4
%     BCS = 3; %if the GCS is on the left, BCS must switch to the right position
% end

for q = 21:95
    trial = 0;
    fifty_prob = rand(1);
    
    if fifty_prob >= 0.5
        GCS = 'on right'; %Taskobject 1 is the GCS
        img1 = BCS_image;
        img2 = GCS_image;
    end
    if fifty_prob < 0.5
        GCS = 'on left'; %The GCS will change spatial positioning on 50% of trials
        img1 = GCS_image;
        img2 = BCS_image;
    end
    
    
    %determine trial type
    if rand(1) < prare
        trial = 1; %trial type set to rare
    end
    %if trial type not set to rare, it defaults to normal
    
    %places fixation dot, stimuli, and choice instructions on screen
    
    t1 = Screen('MakeTexture', wPtr, img1);
    t2 = Screen('MakeTexture', wPtr, img2);
    
    Screen('DrawTexture', wPtr, t1, [], [w/2-300*w/1000, h/2-h/25-y/2, w/2-300*w/1000+x, h/2-h/25+y/2]);
    Screen('DrawTexture', wPtr, t2, [], [w/2+300*w/1000-x, h/2-h/25-y/2, w/2+300*w/1000, h/2-h/25+y/2]);
    Screen('TextSize',wPtr, font_size);
    Screen('TextStyle',wPtr, 1);
    [nx, ny, bbox] = DrawFormattedText(wPtr, '+',  w/2, h/2-h/15, textcolor);
    Screen('TextSize',wPtr, font_size);
    [nx, ny, bbox] = DrawFormattedText(wPtr, 'Please make a choice', 'center', 85*h/100, textcolor);
    Screen('Flip',wPtr);
    
    
    %     toggleobject(fix);
    %     toggleobject(GCS);
    %     toggleobject (BCS);
    %     toggleobject (choiceinstructions);
    %     idle(2000); %instructions on screen for 2 seconds
    %     toggleobject(fix); %fixation dot leaves screen
    %     toggleobject (choiceinstructions); %instructions leave screen
    %     hotkey(z, selected == left) && hotkey(m, selected == right); %defines possible keyboard strokes
    %     idle(stimtime); %wait for participant?s choice
    %     clear hotkey %participant cannot choose after stimtime IMPORTANT NOTE: if participant selects button immediately, it still takes "stimtime" for outcome to appear
    %
    %     %check for errors
    %     if selected == 0
    %         then %WHAT HAPPENS DURING TRIAL ERROR?
    %     end
    %     %SHOULD AN ERROR OCCUR IF BOTH KEYS ARE PRESSED OR DEFAULT TO LAST SELECTED
    %     %KEY?
    
    
    while 1
        [secs, keyCode, deltaSecs] = KbWait;
        if keyCode(quitkey)
            Screen(wPtr,'Close');
            close all
            return;
        end
        if keyCode(left_key)
            selected = 1;
            Screen('DrawTexture', wPtr, t1, [], [w/2-300*w/1000, h/2-h/25-y/2, w/2-300*w/1000+x, h/2-h/25+y/2]);
            Screen('DrawTexture', wPtr, t2, [], [w/2+300*w/1000-x, h/2-h/25-y/2, w/2+300*w/1000, h/2-h/25+y/2]);
            Screen('TextSize',wPtr, font_size);
            Screen('TextStyle',wPtr, 1);
            [nx, ny, bbox] = DrawFormattedText(wPtr, '+',  w/2, h/2-h/15, textcolor);
            Screen('TextSize',wPtr, font_size);
            [nx, ny, bbox] = DrawFormattedText(wPtr, 'Please make a choice', 'center', 85*h/100, textcolor);
            Screen('FrameRect', wPtr, textcolor,[w/2-300*w/1000, h/2-100*w/1000, w/2-300*w/1000+x, h/2-100*w/1000+y], 10)
            Screen('Flip',wPtr);
            break;
        end
        if keyCode(right_key)
            selected = 2;
            Screen('DrawTexture', wPtr, t1, [], [w/2-300*w/1000, h/2-h/25-y/2, w/2-300*w/1000+x, h/2-h/25+y/2]);
            Screen('DrawTexture', wPtr, t2, [], [w/2+300*w/1000-x, h/2-h/25-y/2, w/2+300*w/1000, h/2-h/25+y/2]);
            Screen('TextSize',wPtr, font_size);
            Screen('TextStyle',wPtr, 1);
            [nx, ny, bbox] = DrawFormattedText(wPtr, '+',  w/2, h/2-h/15, textcolor);
            Screen('TextSize',wPtr, font_size);
            [nx, ny, bbox] = DrawFormattedText(wPtr, 'Please make a choice', 'center', 85*h/100, textcolor);
            Screen('FrameRect', wPtr, textcolor,[w/2+300*w/1000-x, h/2-100*w/1000, w/2+300*w/1000, h/2-100*w/1000+y], 10)
            Screen('Flip',wPtr);
            break;
        end
    end
    
    WaitSecs(2); %after 2 seconds, all stimuli leave screen
    %check which key participant selected and position of stimuli to determine
    %if good or bad stimulus was selected
    %     if selected == left && GCS == 2
    %         CS = bad;
    %         toggleobject(leftselected); %box appears around selected stimulus
    %     elseif selected == left && GCS == 4
    %         CS = good;
    %         toggleobject(leftselected);
    %     elseif selected == right && GCS == 2
    %         CS = good;
    %         toggleobject(rightselected);
    %     elseif selected == right && GCS == 4
    %         CS = bad;
    %         toggleobject(rightselected);
    %     end
    
    
    if (q >=21 && q <= 45) || (q >= 71 && q <= 95)  % for reversal 1 and 3
        if selected == 1 && strcmp(GCS,'on left')
            CS = 'bad';
            key_pressed{q,1} = 'leftselected';
            %         toggleobject(leftselected); %box appears around selected stimulus
        elseif selected == 1 && strcmp(GCS,'on right')
            CS = 'good';
            key_pressed{q,1} = 'leftselected';
            %         toggleobject(leftselected);
        elseif selected == 2 && strcmp(GCS,'on left')
            CS = 'good';
            key_pressed{q,1} = 'rightselected';
            %         toggleobject(rightselected);
        elseif selected == 2 && strcmp(GCS,'on right')
            CS = 'bad';
            key_pressed{q,1} = 'rightselected';
            %         toggleobject(rightselected);
        end
    end
    
    if q >=46 && q <= 70  % for reversal 2
        if selected == 1 && strcmp(GCS,'on left')
            CS = 'good';
            key_pressed{q,1} = 'leftselected';
            %         toggleobject(leftselected); %box appears around selected stimulus
        elseif selected == 1 && strcmp(GCS,'on right')
            CS = 'bad';
            key_pressed{q,1} = 'leftselected';
            %         toggleobject(leftselected);
        elseif selected == 2 && strcmp(GCS,'on left')
            CS = 'bad';
            key_pressed{q,1} = 'rightselected';
            %         toggleobject(rightselected);
        elseif selected == 2 && strcmp(GCS,'on right')
            CS = 'good';
            key_pressed{q,1} = 'rightselected';
            %         toggleobject(rightselected);
        end
    end
    
    %check which stimulus is selected and the trial type (normal or rare) to
    %determine if the trial will result in a win or loss
    if strcmp(CS, 'good') && trial == 0
        run = 'win';
        TrialType{q,1} = 'normal';
        %         TrialRecord.TrialType(end+1)=1; %makes a note of whether trial is a win or loss
    elseif strcmp(CS, 'good') && trial == 1
        run = 'loss';
        TrialType{q,1} = 'rare';
        %         TrialRecord.TrialType(end+1)=0;
    elseif strcmp(CS, 'bad') && trial == 0
        run = 'loss';
        TrialType{q,1} = 'normal';
        %         TrialRecord.TrialType(end+1)=0;
    elseif strcmp(CS, 'bad') && trial == 1
        run = 'win';
        TrialType{q,1} = 'rare';
        %         TrialRecord.TrialType(end+1)=1;
    end
    
    %tells the participant that they won or lost money
    if strcmp(run,'win')
        Screen('TextSize',wPtr, font_size);
        [nx, ny, bbox] = DrawFormattedText(wPtr, 'WON $5', 'center', h/2-h/15, textcolor);
        RewardValue{q,1} = '5';
        Screen('Flip',wPtr);
    elseif strcmp(run,'loss')
        Screen('TextSize',wPtr, font_size);
        [nx, ny, bbox] = DrawFormattedText(wPtr, 'LOST $5', 'center', h/2-h/15, textcolor);
        RewardValue{q,1} = '-5';
        Screen('Flip',wPtr);
    end
    
    %     if CS == good && trial == normal
    %         run = win;
    %         TrialRecord.TrialType(end+1)=1; %makes a note of whether trial is a win or loss
    %     elseif CS == good && trial == rare
    %         run = loss;
    %         TrialRecord.TrialType(end+1)=0;
    %     elseif CS == bad && trial == normal
    %         run = loss;
    %         TrialRecord.TrialType(end+1)=0;
    %     elseif CS == bad && trial == rare
    %         run = win;
    %         TrialRecord.TrialType(end+1)=1;
    %     end
    %
    %     if run == win
    %         toggleobject(reportwin);
    %     elseif run == loss
    %         toggleobject(reportloss);
    %     end
    
    %     rewardval=randi([rewardfloor,rewardceiling]); %The value of the reward (or loss) is set to any number between "rewardfloor" and "rewardceiling"
    %     toggleobject(rewardval); %presents the reward value (or loss value) to the participant
    %     TrialRecord.RewardValue(end+1)=rewardval; %makes a note of the reward value for the experimenter
    
    WaitSecs(2); %everything leaves screen after 2 seconds
    Screen('TextSize',wPtr, font_size);
    Screen('TextStyle',wPtr, 1);
    [nx, ny, bbox] = DrawFormattedText(wPtr, '+',  w/2, h/2-h/15, textcolor);
    Screen('Flip',wPtr);
    %ITI
    ITI = randi([8,12]);
    WaitSecs(ITI);
    %     toggleobject(fix);
    %     idle(randi([8,12])*1000);
    %     toggleobject(fix);
end

%
Screen('TextSize',wPtr, font_size);
[nx, ny, bbox] = DrawFormattedText(wPtr, 'You have completed the experiment, Thank you for participanting', 'center', h/2-h/15, textcolor);
Screen('Flip',wPtr);


header = {'KEY_PRESSED', 'TRIAL_TYPE', 'REWARD_VALUE'};
combined_table = horzcat(key_pressed, TrialType, RewardValue);
TrialRecord = [header; combined_table];
folder = './result';
save([folder '/result.mat'], 'TrialRecord');

while 1
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    if keyCode(quitkey)
        Screen(wPtr,'Close');
        close all
        return;
    end
end


end

