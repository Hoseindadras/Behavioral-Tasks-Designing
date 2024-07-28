function disp_fix(wpt, w, h, dur)
%%

fix = DispString('init', wpt, '+', [0, 0], floor(h/11), [255, 255, 255], []);
DispString('draw', wpt, fix);

Screen(wpt,'Flip');
t_strt = GetSecs;
while GetSecs < t_strt + dur
end

DispString('clear', fix);

end