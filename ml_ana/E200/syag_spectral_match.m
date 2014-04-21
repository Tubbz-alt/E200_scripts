function [ match_goodness ] = syag_spectral_match( ref_syag_img, roi )
% Function to quantify how well the current SYAG spectrum
% matches a reference function

if nargin<2
    roi = [100 1000 300 400]; % x1 x2 y1 y2
end

% apply ROI to reference SYAG image
ref_syag_img = ref_syag_img(roi(3):roi(4),roi(1):roi(2));
% get projeciton of reference SYAG image
ref_proj = sum(ref_syag_img);

% get current SYAG image
% cur_syag_img = ????
% apply ROI to current SYAG image
cur_syag_img = cur_syag_img(roi(3):roi(4),roi(1):roi(2));
% get projection of current SYAG image
cur_proj = sum(cur_syag_img);

% get difference between projections
diff = cur_proj-ref_proj;
diff2 = sum(diff.^2);

% weight by log of amplitude
wgt = log(ref_proj)/log(max(ref_proj));

% calculate goodness of matching
match_goodness = wgt.*sqrt(diff2)/length(diff2);

end