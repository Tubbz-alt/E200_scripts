%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to quantify how well the current SYAG spectrum
% matches a reference function
% M.Litos - Apr.20, 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ syag_match_goodness ] = syag_spectral_match( ref_syag_pmon )

% set default ROI
if nargin<2
    roi = [100 1000 300 400]; % x1 x2 y1 y2
end

%% get reference SYAG image
ref_syag_img = ref_syag_pmon.img;
% apply ROI to reference SYAG image
ref_syag_img = ref_syag_img(roi(3):roi(4),roi(1):roi(2));
% get projeciton of reference SYAG image
ref_proj = sum(ref_syag_img);

% get calibrated x-axis in mm
x_axis = (1e-3)*ref_syag_pmon.RESOLUTION*...
    ((ref_syag_pmon.ROI_X - ref_syag_pmon.X_RTCL_CTR + 1):...
    (ref_syag_pmon.ROI_X - ref_syag_pmon.X_RTCL_CTR + ref_syag_pmon.ROI_XNP));

% get calibrated energy axis in '%'
Ecal = 1; % temporary!
E_axis = x_axis*Ecal;

%% display results
fig_syag_diff = figure(666);
clf(666);
set(fig_syag_diff, 'position', [1, 910, 584, 930]);
set(fig_syag_diff, 'color', 'w');

%% continuous run (cancel w/ ctl-c)
counter=0;
while 1
    tic;
    
    %% get current SYAG image
    cur_syag_pmon = getProfMon('SYAG:NAME:HERE');
    cur_syag_img  = cur_syag_pmon.img;
    % apply ROI to current SYAG image
    cur_syag_img = cur_syag_img(roi(3):roi(4),roi(1):roi(2));
    % get projection of current SYAG image
    cur_proj = sum(cur_syag_img);
    
    
    %% get difference between projections
    diff = cur_proj-ref_proj;
    diff2 = sum(diff.^2);
    
    % weight by log of amplitude
    wgt = log(ref_proj)/log(max(ref_proj));
    
    % calculate goodness of matching
    syag_match_goodness = wgt.*sqrt(diff2)/length(diff2);
    
    % print result to EPICS variable
    lcaPutSmart('SIOC:SYS1:ML01:AOXXX', syag_match_goodness);
    
    %% plot difference
    if counter==0 % create plot on first shot
        
        plot_diff = plot(x_axis,diff,'erasemode');
        ax1 = gca;
        set(ax1,'Box','on','LineWidth',2.0,...
            'FontName','Helvetica',...
            'FontUnits','points','FontSize',18,'FontWeight','bold');
        set(ax1,'TickLength',[0.015,0.015]);
        set(ax1,'XLim',[x_axis(1), x_axis(end)]);
        set(ax1,'XTick',[-5:0.5:5],'XMinorTick','on');
        set(ax1,'YLim',[-max(abs(diff)), +max(abs(diff))]);
        set(ax1,'YTick',[-5000:100:+5000],'YMinorTick','on');
        xlabel('x (mm)');
        ylabel('Difference from Reference Spectrum (counts)');
        title('SYAG Spectrum Difference');
        
    else % update figure on subsequent shots
        
        set(plot_diff,'YData',diff);
        
    end
    
    % increment counter
    counter=counter+1;
    toc;
    pause(0.1);
    
end%while

end