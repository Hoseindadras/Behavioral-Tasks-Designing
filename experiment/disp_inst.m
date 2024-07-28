function disp_inst(wpt, w, h, flag, dur, mv_strt, otherID)
%%

mv_path = ['movie',otherID,'.MOV'];
mv_strt = mv_strt * 1000;
mv_pst = [0, -h/15];
mv_scl = 100 * w/4000;

if isequal(flag,'SELF')
    inst_msg = DispString('init', wpt, 'Make Your Choice', [0,h/5], floor(h/15), [255, 255, 255], []);
    DispString('draw', wpt, inst_msg);
    rect_pst = [w/2 - (1920 * mv_scl/100)/2, h/2 - (1080 * mv_scl/100)/2 - h/15, w/2 + (1920 * mv_scl/100)/2, h/2 + (1080 * mv_scl/100)/2 - h/15];
    Screen('FillRect',wpt,[255/2, 255/2, 255/2], rect_pst);
    Screen(wpt,'Flip');
    t_strt = GetSecs;
    while GetSecs < t_strt + dur
    end
    DispString('clear', inst_msg);

elseif isequal(flag,'OTHER')
    inst_msg = DispString('init', wpt, 'Observe His Choice', [0,h/5], floor(h/15), [255, 255, 255], []);
    movp = PlayMovie('init', wpt, mv_path, mv_pst, mv_scl, mv_strt, []);
    PlayMovie('start', wpt, movp);
    t_strt = GetSecs;
    while GetSecs < t_strt + dur
        DispString('draw', wpt, inst_msg);
        PlayMovie('draw', wpt, movp);
        Screen('Flip', wpt);
    end
    DispString('clear', inst_msg);
    PlayMovie('finish', movp);    
    PlayMovie('clear', movp);
    
elseif isequal(flag,'PREDICT')
    inst_msg = DispString('init', wpt, 'Predict His Choice', [0,h/5], floor(h/15), [255, 255, 255], []);
    movp = PlayMovie('init', wpt, mv_path, mv_pst, mv_scl, mv_strt, []);
    PlayMovie('start', wpt, movp);
    t_strt = GetSecs;
    while GetSecs < t_strt + dur
        DispString('draw', wpt, inst_msg);
        PlayMovie('draw', wpt, movp);
        Screen('Flip', wpt);
    end
    DispString('clear', inst_msg);
    PlayMovie('finish', movp);    
    PlayMovie('clear', movp);
    
end

end