function [o_choice, o_rt] = make_O_choices(prob_risk,mag_risk,riskPREF)
%%

% Choices
if isequal(riskPREF,'A')
    alpha = -0.013;
elseif isequal(riskPREF,'S')
    alpha = 0.03;
elseif isequal(riskPREF,'N')
    alpha = 0;
end
beta = 5;

ev = prob_risk * mag_risk;
var = mag_risk^2 * prob_risk * (1 - prob_risk);
val = ev + alpha * var - 10;
c_prob = 1 ./ (1 + exp(-beta * val));

if rand() < c_prob, o_choice = 1;
else o_choice = 2;
end

% RT
o_rt = rand() + 3;

%disp([o_choice, o_rt])
end