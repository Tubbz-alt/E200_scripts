% Usage :
%     function E200_gen_scan(fcnHandle, Control_PV_start, Control_PV_end, n_step, cam_config, n_shot)

% Changelog :
% E. Adli, Apr 8, 2013
%   First version!

%
% Sets fcnHandle2 at fixed value, and records PV name and value in "scan_info"
% 
% Example call: E200_gen_scan_15D(@set_XCOR_LI20_3086_BDES, -0.3724, +0.3724, 7, @set_QS1_BDES, 209.11, 7, 10);
function E200_gen_scan_15D(fcnHandle, Control_PV_start, Control_PV_end, n_step, fcnHandle2, Control_PV_2, cam_config, n_shot)

par = E200_Param(); % Load default parameters
if( nargin < 8);
    par.n_shot = 20;
else
    par.n_shot = n_shot;
end% if
par.camera_config = cam_config;
% first step: save everything
par.save_facet = 0; % ***TEMP
par.save_E200 = 0; % ***TEMP
par.aida_daq = 0;
par.save_back = 0;
% par.event_code = 53;
par.set_print2elog = 1; 
Control_PV_name = char(fcnHandle);
Control_PV_name_2 = char(fcnHandle2);
par.comt_str = ['E200 scan, using function "' Control_PV_name '",\nfrom ' num2str(Control_PV_start) ' to ' num2str(Control_PV_end) ',\nwith 2nd function "' Control_PV_name_2 '" kept at ' num2str(Control_PV_2) '.\n' num2str(n_step) ' steps.']; 

fcnHandle2(Control_PV_2);
 
for i=1:n_step
    if i>1; par.set_print2elog=0; par.increment_save_num=0; par.save_facet=0; par.save_E200=0; par.save_back = 0; end;
    Control_PV = Control_PV_start + (i-1) * (Control_PV_end-Control_PV_start) / (n_step-1);
    fcnHandle(Control_PV);
    
    fprintf('\nStep # %d\n\n', i);
    fprintf('Scan setting is %.2f\n\n', Control_PV);
%par_out.save_path = '.';
%par_out.save_name = 'temptemptemptemp.txt';
    [a, b, c, d, filenames, par_out] = E200_DAQ_2013(par);
    filenames.Control_PV_name = {Control_PV_name, Control_PV_name_2};
    filenames.Control_PV = [Control_PV Control_PV_2];
    [filenames.save_path] = deal(par_out.save_path);
    if i==1; 
       scan_info = filenames; 
    else 
      scan_info = [scan_info, filenames]; 
    end;
    % save scan info per step, in case execution breaks
    save([par_out.save_path '/' par_out.save_name(1:11) 'scan_info'], 'scan_info');
end

