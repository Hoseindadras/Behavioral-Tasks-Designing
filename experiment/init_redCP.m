function [cp_L,cp_R]= init_redCP(wpt,w,h,num_subs)
%%

pst_cp_L = linspace(-0.34*w, -0.16*w, num_subs-1); 
pst_cp_R = linspace(0.16*w, 0.34*w, num_subs-1); 

cp_L = cell(length(pst_cp_L),1);
cp_R = cell(length(pst_cp_R),1);

for i = 1:length(pst_cp_L)
    cp_L{i} = DrawCircle('init', wpt, [pst_cp_L(i),0.25*h], h/20, [255,0,0], 100, []);
    cp_R{i} = DrawCircle('init', wpt, [pst_cp_R(i),0.25*h], h/20, [255,0,0], 100, []);
end

end