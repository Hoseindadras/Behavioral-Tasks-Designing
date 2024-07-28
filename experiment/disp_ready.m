function disp_ready(wpt, w, h)
%%

ready = DispString('init', wpt, 'READY', [0,0], floor(h/10), [255, 255, 255], []);
DispString('draw', wpt, ready);

Screen(wpt,'Flip');
FlushEvents
while 1
    if isequal(GetChar,'5')
        break;
    end
end

DispString('clear', ready);
end