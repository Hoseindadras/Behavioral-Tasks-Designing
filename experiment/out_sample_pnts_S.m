function sample_pnts = out_sample_pnts_S
%%
close all;

sample_pnts = [];

% Basic grid points
set_prob = [0.3];
for i = -4:4
    set_mag = 10 ./ set_prob + i*4;
    sample_pnts = [sample_pnts; [set_prob',set_mag']];
end

set_prob = [0.4];
for i = -3:5
    set_mag = 10 ./ set_prob + i*4.25;
    sample_pnts = [sample_pnts; [set_prob',set_mag']];
end

set_prob = [0.5];
for i = -2:5
    set_mag = 10 ./ set_prob + i*4;
    sample_pnts = [sample_pnts; [set_prob',set_mag']];
end

sample_pnts = [sample_pnts; [1,30]];
sample_pnts = [sample_pnts; [1,20]];
sample_pnts

% Add noise%
% sample_pnts(:,2) = round(sample_pnts(:,2) + rand(size(sample_pnts,1),1) * 3 - 1.5);

% Randomize the order
rnd_idx = randperm(size(sample_pnts,1));
tmp_prob = sample_pnts(:,1);
tmp_mag = sample_pnts(:,2);
sample_pnts(:,1) = tmp_prob(rnd_idx);
sample_pnts(:,2) = tmp_mag(rnd_idx);

% Disp statistics
val = sample_pnts(:,1) .* sample_pnts(:,2);
risk = sample_pnts(:,2).^2 .* sample_pnts(:,1) .* (1 - sample_pnts(:,1));
p = sample_pnts(:,1);
r = sample_pnts(:,2);
v = (r - r .* p).^2 .* p + (0 - r .* p).^2 .* (1 - p);
s = (r - r .* p).^3 .* p + (0 - r .* p).^3 .* (1 - p) ./ v .^ (3/2);
s(isnan(s)) = 0;
[risk,v,s];

%corr([v,sqrt(s),sample_pnts(:,1),sample_pnts(:,2)])


disp(['corr. between return and risk: ',num2str(corr(val,sqrt(risk)))])
disp(['corr. between VAR and SD: ',num2str(corr(risk,sqrt(risk)))])
disp(['# sample points: ', num2str(size(sample_pnts,1))])

%%%%%%%%%%%% For check %%%%%%%%%%%%
disp(['# sample points: ', num2str(size(sample_pnts,1))])

figure(1)
hold on

x = [0:0.01:1]; y = 10 ./ x;
plot(x,y,'k-','LineWidth',1)

for i = 1:size(sample_pnts,1)
    %clr = [1,1,1] * i / size(sample_pnts,1);
    clr = [1,0.5,0];
    plot(sample_pnts(i,1),sample_pnts(i,2),'o','MarkerFaceColor',clr,'MarkerEdgeColor',clr,'MarkerSize',20,'LineWidth',1)
end

hold off
xlim([0,1])
ylim([0,60])
grid on

%{
%figure(2)
%scatter(val,sqrt(risk))
%}

end