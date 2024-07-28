function run_SOP1(subID,otherID,riskPREF)
%% Self/Observe/Predict condition
% run_SOP('140510a',1,'J','A')
% subID: subject's ID, YYMMDD
% numEXP: X-th experiment for the subject, X = 1,2,... 
% otherID: K or L
% riskPREF: risk-averse (A), -seeking (S) or -neutral (N)

%try
    
    numEXP = 1;
    rand('state', sum(100*clock));
    
    % Get sample-points and trial-types    
    type_SOP_names = {'SELF','OTHER','PREDICT'};
    type_SOP = [];
    smpl_pnts = [];
    smpl_pnts_P_1st = out_sample_pnts_P;
    smpl_pnts = [smpl_pnts; smpl_pnts_P_1st];
    type_P_1st = 3 * ones(size(smpl_pnts_P_1st,1),1); 
    type_SOP = [type_SOP; type_P_1st];
    for i = 1:2 % 2 meta-Blocks
        
        smpl_pnts_O = out_sample_pnts_O;
        smpl_pnts_S = out_sample_pnts_S;
        
        smpl_pnts_O_1st = smpl_pnts_O((1:size(smpl_pnts_O,1)/2),:);
        smpl_pnts_S_1st = smpl_pnts_S((1:size(smpl_pnts_S,1)/2),:);
        smpl_pnts = [smpl_pnts; smpl_pnts_O_1st; smpl_pnts_S_1st];
        type_O_1st = 2 * ones(size(smpl_pnts_O_1st,1),1); 
        type_S_1st = 1 * ones(size(smpl_pnts_S_1st,1),1);
        type_SOP = [type_SOP; type_O_1st; type_S_1st];

        smpl_pnts_O_2nd = smpl_pnts_O((size(smpl_pnts_O,1)/2+1:end),:);
        smpl_pnts_S_2nd = smpl_pnts_S((size(smpl_pnts_S,1)/2+1:end),:);
        smpl_pnts = [smpl_pnts; smpl_pnts_O_2nd; smpl_pnts_S_2nd];
        type_O_2nd = 2 * ones(size(smpl_pnts_O_2nd,1),1); 
        type_S_2nd = 1 * ones(size(smpl_pnts_S_2nd,1),1);
        type_SOP = [type_SOP; type_O_2nd; type_S_2nd];
        
        smpl_pnts_P_last = out_sample_pnts_P;
        smpl_pnts = [smpl_pnts; smpl_pnts_P_last];
        type_P_last = 3 * ones(size(smpl_pnts_P_last,1),1); 
        type_SOP = [type_SOP; type_P_last];
    
    end
    disp([type_SOP,smpl_pnts])
    disp([length(type_SOP),length(smpl_pnts)])
    
    % Set window pointer and random seed
    %w_size = [0 0 4 3] * 250;
    %[wpt, rect] = Screen('OpenWindow', 0, [0, 0, 0], w_size);
    [wpt, rect] = Screen('OpenWindow', 1, [0, 0, 0]); 
    w = rect(3); h = rect(4);
    Screen('BlendFunction', wpt, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Specify # trials
    num_trials = length(type_SOP);
    
    % Set the timing of the movie start
    mv_timing = [5,10,15,20,25,30,35,40,45,50,55,60]+rand;
    mv_timing = mv_timing(randperm(length(mv_timing)));
    cnt_mov = 1;
    
    % Set durations
    durITI = linspace(2,6,num_trials); durITI = durITI(randperm(num_trials));
    durINS = 4;
    durDEC = linspace(4,4,num_trials); durDEC = durDEC(randperm(num_trials));
    durCON = 1.5;
    
    %%%%%%%%%% Set stimuli %%%%%%%%%%
    % position of the stimuli
    pst_stim = [-w/7.5,w/7.5];
    % Reward Magnitude
    radius_mag = w / 11.5;
    w_dev_mag = w/22; h_dev_mag = h/25;
    % Indication of the chosen option
    cntrRect = [w/2 - w/7.5, h/2+h/5+h/12; w/2 + w/7.5, h/2+h/5+h/12];
    w_devY = w/8.5; h_devY = h/15;
    w_devK = w_devY * 0.9; h_devK = h_devY * 0.8;
    % Instruction shown at the time of decision
    inst_msg_DM = {DispString('init', wpt, 'Make Your Choice', [0,- h/5 - h/12], floor(h/15), [255, 255, 0], []);
        DispString('init', wpt, 'Observe His Choice', [0,- h/5 - h/12], floor(h/15), [255, 255, 0], []);
        DispString('init', wpt, 'Predict His Choice', [0,- h/5 - h/12], floor(h/15), [255, 255, 0], [])};
    
    % Store log data
    data_pst = [];
    data_act = [];
    data_rt = [];
    data_rt2 = [];
    data_choice = [];
    data_choice_O = [];
    time_ITI = []; 
    time_INS = []; 
    time_DEC = []; 
    time_CON = [];
    data_prob = [];
    data_mag = [];
    data_type = [];
    
    % Ready
    disp_ready(wpt, w, h);
    time_zero = GetSecs;
    type_SOP_pre = 0;
    
    % Start the experiment
    for t = 1:num_trials
        disp([t,type_SOP(t)])
        
        % ITI
        time_ITI_strt = GetSecs - time_zero;
        disp_fix(wpt, w, h, durITI(t))
        time_ITI_end = GetSecs - time_zero;
        time_ITI = [time_ITI; [time_ITI_strt time_ITI_end]]; 
        
        % INSTRUCTION
        if type_SOP(t) ~= type_SOP_pre
            time_INS_strt = GetSecs - time_zero;
            disp_inst(wpt, w, h, type_SOP_names{type_SOP(t)}, durINS, mv_timing(cnt_mov), otherID)
            time_INS_end = GetSecs - time_zero;
            time_INS = [time_INS; [time_INS_strt time_INS_end]];  
            cnt_mov = cnt_mov + 1;
        end
        type_SOP_pre = type_SOP(t); 
        
        % DECISION & RESPONSE
        prob_risk = smpl_pnts(t,1);
        mag_risk = smpl_pnts(t,2);
        pstLR = [1,2]; if rand < 0.5, pstLR = 3 - pstLR; end;
        % Instruction
        DispString('draw', wpt, inst_msg_DM{type_SOP(t)});
        % Reward Prob.
        % Risk
        pi_file_R = ['stimuli/pi0',num2str(prob_risk * 100),'.png'];
        pi_img_R = DispImage('init', wpt, pi_file_R, [0,0], w/35, [100,100]);
        DispImage('draw', wpt, pi_img_R);
        % Reward Mag.
        % Risk
        angle_mag_R = prob_risk * 2 * pi / 2 - pi / 2;
        cntr_mag_R = [cos(angle_mag_R),sin(angle_mag_R)] * radius_mag;
        num_mag_R = DispString('init', wpt, ['$',num2str(mag_risk)], cntr_mag_R, floor(h/16), [255, 255, 255], []);
        pstRect_mag_R = [cntr_mag_R(1) - w_dev_mag + w/2, cntr_mag_R(2) - h_dev_mag + h/2, cntr_mag_R(1) + w_dev_mag + w/2, cntr_mag_R(2) + h_dev_mag + h/2];
        Screen('FillRect',wpt,[0,0,0],pstRect_mag_R);
        DispString('draw', wpt, num_mag_R);
        % Choice options
        accept_str = DispString('init', wpt, ['ACCEPT'], [pst_stim(pstLR(1)),h/5+h/12], floor(h/16), [255, 255, 255], []);
        reject_str = DispString('init', wpt, ['REJECT'], [pst_stim(pstLR(2)),h/5+h/12], floor(h/16), [255, 255, 255], []);
        DispString('draw', wpt, accept_str);
        DispString('draw', wpt, reject_str);
        % Screen
        Screen(wpt,'Flip');
        time_DEC_strt = GetSecs - time_zero;
        if type_SOP(t) == 1 || type_SOP(t) == 3 % SELF or PREDICT condition
            if type_SOP(t) == 3,
                [choice_O, rt_O] = make_O_choices(prob_risk,mag_risk,riskPREF);
                data_choice_O = [data_choice_O; choice_O];
            end
            FlushEvents;
            act = floor(rand() * 2) + 1;
            rt = 100;
            t_strt = GetSecs;
            while GetSecs < t_strt + durDEC(t)
                if CharAvail == 1
                    keyRes = GetChar;
                    if isequal(keyRes,'1'), act = 1; rt = GetSecs - t_strt; break;
                    elseif isequal(keyRes,'2'), act = 2; rt = GetSecs - t_strt; break;
                    end
                end
            end
            choice = act2choice(act,pstLR);
        elseif type_SOP(t) == 2 % OBSERVE condition
            [choice, rt] = make_O_choices(prob_risk,mag_risk,riskPREF);
            act = choice2act(choice,pstLR);
            t_strt = GetSecs;
            while GetSecs < t_strt + rt 
            end
        end
        time_DEC_end = GetSecs - time_zero;
        time_DEC = [time_DEC; [time_DEC_strt time_DEC_end]];  
        
        % Store Behavioral Data
        data_pst = [data_pst; pstLR];
        data_act = [data_act; act];
        data_rt = [data_rt; rt];
        data_choice = [data_choice; choice];
        data_prob = [data_prob; prob_risk];
        data_mag = [data_mag; mag_risk];
        data_type = [data_type; type_SOP(t)];
        
        % CONFIRM
        % Instruction
        DispString('draw', wpt, inst_msg_DM{type_SOP(t)});
        % "Risk or Sure" and the chosen option 
        pstRectY = [cntrRect(act,1) - w_devY, cntrRect(act,2) - h_devY, cntrRect(act,1) + w_devY, cntrRect(act,2) + h_devY];
        pstRectK = [cntrRect(act,1) - w_devK, cntrRect(act,2) - h_devK, cntrRect(act,1) + w_devK, cntrRect(act,2) + h_devK];
        Screen('FillRect',wpt,[255,255,0],pstRectY);
        Screen('FillRect',wpt,[0,0,0],pstRectK);
        % Reward Prob.
        % Risk
        DispImage('draw', wpt, pi_img_R);
        % Reward Mag.
        % Risk
        Screen('FillRect',wpt,[0,0,0],pstRect_mag_R);
        DispString('draw', wpt, num_mag_R);  
        DispString('draw', wpt, accept_str);
        DispString('draw', wpt, reject_str);
        % Screen
        Screen(wpt,'Flip');
        time_CON_strt = GetSecs - time_zero;
        t_strt = GetSecs;
        FlushEvents;
        rt2 = 100;
        while GetSecs < t_strt + durCON
            if CharAvail == 1
                keyRes = GetChar;
                if isequal(keyRes,'3'), rt2 = GetSecs - t_strt; end
            end
        end
        time_CON_end = GetSecs - time_zero;
        time_CON = [time_CON; [time_CON_strt time_CON_end]]; 
        data_rt2 = [data_rt2; rt2];

        % Clear textures
        DispImage('clear', pi_img_R);
        DispString('clear', num_mag_R);
        DispString('clear', accept_str);
        DispString('clear', reject_str);
        
        % Save logs
        fname_log = ['logs/sub',subID,'_','SOP',num2str(numEXP)];
        save(fname_log, 'data_type', 'data_prob', 'data_mag', 'data_pst', 'data_act', 'data_rt', 'data_rt2', 'data_choice','data_choice_O');
        fname_log_time = ['logs/sub',subID,'_','SOP',num2str(numEXP),'_time'];
        save(fname_log_time, 'time_ITI', 'time_INS', 'time_DEC', 'time_CON');
        
    end
    
    % Shutdown
    time_ITI_strt = GetSecs - time_zero;
    disp_fix(wpt, w, h, 12)
    time_ITI_end = GetSecs - time_zero;
    time_ITI = [time_ITI; [time_ITI_strt time_ITI_end]]; 
    Screen('CloseAll');
    
    % Save logs
    fname_log = ['logs/sub',subID,'_','SOP',num2str(numEXP)];
    save(fname_log, 'data_type', 'data_prob', 'data_mag', 'data_pst', 'data_act', 'data_rt', 'data_rt2', 'data_choice','data_choice_O');
    fname_log_time = ['logs/sub',subID,'_','SOP',num2str(numEXP),'_time'];
    save(fname_log_time, 'time_ITI', 'time_INS', 'time_DEC', 'time_CON');
    
%catch
%    Screen('CloseAll');
%    %rethrow(exception);
%    psychrethrow(psychlasterror);     
%end

end








