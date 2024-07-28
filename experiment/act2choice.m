function choice = act2choice(act,pstAB)
%%

if act == 0, choice = 0;
else
    choice = pstAB(act);
end

end