function plot_smplpnts
%%
clear all;

data_S = out_sample_pnts_S;
close all;

% Choices
alpha_data = [-0.013 0.03];
beta = 5;

for a = 1:length(alpha_data)
    
    alpha = alpha_data(a);
    
    figure(a)
    hold on
    x = [0:0.01:1]; y = 10 ./ x;
    plot(x,y,'k-','LineWidth',1)
    
    for i = 1:size(data_S,1)
        
        prob_risk = data_S(i,1);
        mag_risk = data_S(i,2);
        ev = prob_risk * mag_risk;
        var = mag_risk^2 * prob_risk * (1 - prob_risk);
        val = ev + alpha * var - 10;
        c_prob = 1 ./ (1 + exp(-beta * val));
        
        clr = [1 1 0] * (1 - c_prob) + [0 0 1];
        clr_edge = [0 0 1];
        plot(data_S(i,1),data_S(i,2),'o','MarkerEdgeColor',clr_edge,'MarkerFaceColor',clr,'MarkerSize',20,'LineWidth',1)
        
    end
    
    hold off
    xlim([0,1])
    ylim([0,60])
    grid on
    
end

end