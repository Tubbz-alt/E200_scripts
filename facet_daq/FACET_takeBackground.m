function [background, param] = FACET_takeBackground(param)

cams  = param.cams;
names = param.names;

set_2_9(1);
pause(3);

data       = profmon_grab(cams);

for i=1:numel(data)
	background.(names{i}).img        = data(i).img;
	background.(names{i}).ROI_X      = data(i).roiX;
	background.(names{i}).ROI_Y      = data(i).roiY;
	background.(names{i}).ROI_XNP    = data(i).roiXN;
	background.(names{i}).ROI_YNP    = data(i).roiYN;
	background.(names{i}).RESOLUTION = data(i).res;
	background.(names{i}).X_ORIENT   = data(i).orientX;
	background.(names{i}).Y_ORIENT   = data(i).orientY;
end

set_2_9(0);
    
end
