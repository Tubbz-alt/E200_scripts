%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FACET DAQ for 2014                                                      %
%                                                                         %
%                                                                         %
% S. Corde, S. Gessner, J. Frederico, Z. Oven                             %
% 3/13/14                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data = FACET_DAQ_2014(arg_param)
	% =========================================
	% Test that we are on the right machine
	% =========================================
	[id,hostname] = system('hostname');
	if ~strncmp(char(hostname),'facet-srv20', 11)
	    error('FACET DAQ must be run from facet-srv20. You are on %s', hostname);
	end

	% =========================================
	% Load DAQ parameters
	% =========================================
	if nargin>0; param = arg_param; else param = FACET_Param(); end;

	% =========================================
	% Test for scan
	% =========================================
	if isfield(param,'fcnHandle')
		disp('Running Scan');
		scanbool = true;
        
		% Convert variables to make things easier
		PV_start=param.Control_PV_start;
		PV_end=param.Control_PV_end;
		n_step = param.n_step;

		% Create list of values for function
		param.PV_scan_list = linspace(PV_start,PV_end,n_step);
        
        % The following setup is for 2D scan function
        if isfield(param,'fcnHandle2')
            scan2D_bool = true;
            
            PV_start1=param.Control_PV_start;
            PV_end1=param.Control_PV_end;
            n_step1 = param.n_step;
            
            PV_start2=param.Control_PV_start2;
            PV_end2=param.Control_PV_end2;
            n_step2 = param.n_step2;
            
            n_step = n_step1*n_step2;
            param.n_step = n_step;
            param.PV_scan_list = 1:n_step;
            
            param.PV_scan_list1 = linspace(PV_start1,PV_end1,n_step1);
            param.PV_scan_list2 = linspace(PV_start2,PV_end2,n_step2);
            
            
            [ind1,ind2] = ind2sub([n_step1 n_step2], 1:n_step);
            param.PV_scan_ind1  = ind1;
            param.PV_scan_ind2  = ind2;
            
            disp(['Scan values for ' char(param.fcnHandle) ' are:']);
            disp(param.PV_scan_list1);
            
            disp(['Scan values for ' char(param.fcnHandle2) ' are:']);
            disp(param.PV_scan_list2);
            
        else
            scan2D_bool = false;
            disp('Scan values are:');
            disp(param.PV_scan_list);
            
        end
        
	else
		disp('Running Single Step');
		n_step=1;
		param.n_step=1;
		scanbool = false;
        scan2D_bool = false;
    end
	
    % =========================================
    % Check camera status
    % =========================================
    disp(['Checking camera status ' datestr(clock,'HH:MM:SS')]);
    param = FACET_cameras(param);
    param = Check_Cam_Status(param);
    
	% =========================================
    % Start Acquiring data 
	% =========================================
	disp(['Creating directory structure ' datestr(clock,'HH:MM:SS')]);
	param = FACET_save_path(param);

    disp(['Getting non-BSA data ' datestr(clock,'HH:MM:SS')]);
    if(param.save_E200);
        try
            E200_state = E200_getMachine();
        catch
            disp('Failed to get non BSA EPICS PVs. Check list for bad PVs.');
            E200_state = 0;
        end

    else
        E200_state = 0;
    end
    
    disp(['Getting camera backgrounds ' datestr(clock,'HH:MM:SS')]);
	if(param.save_back); [cam_back, param] = FACET_takeBackground(param); else cam_back = 0; end;

    % =========================================
    % Start DAQ Loop 
	% =========================================
    
	% Initialize arry for steps
	epics_data=cell(1,n_step);
    for i=1:n_step
        
        if scanbool
            % 2D scan code
            if scan2D_bool
                disp(['Changing scan function ' char(param.fcnHandle) 'to: ' num2str(param.PV_scan_list1(ind1(i))) ]);
                param.fcnHandle(param.PV_scan_list1(ind1(i)));
                disp(['Finished changing scan function ' char(param.fcnHandle)]);
                
                disp(['Changing scan function ' char(param.fcnHandle2) 'to: ' num2str(param.PV_scan_list2(ind2(i))) ]);
                param.fcnHandle2(param.PV_scan_list2(ind2(i)));
                disp(['Finished changing scan function ' char(param.fcnHandle2)]);
                
            % 1D scan code    
            else
                disp(['Changing scan function to: ' num2str(param.PV_scan_list(i)) ]);
                param.fcnHandle(param.PV_scan_list(i));
                disp('Finished changing scan function.');
            end
        end

        disp(['Starting EPICS acquistion ' datestr(clock,'HH:MM:SS')]);
        myeDefNumber = E200_startEPICS(param);

        disp(['Starting Image acquistion ' datestr(clock,'HH:MM:SS')]);
        param = AD_startImage(param,i);

        disp(['Finished Image acquistion ' datestr(clock,'HH:MM:SS')]);
        epics_data{i} = E200_getEPICS(myeDefNumber);
        
        if isfield(param,'fail')
            warning(['DAQ failed during image acquisition on step ' num2str(i) '. Saving data before quitting.']);
	    param.n_step = i;
            break;
        end
    end
	
    % =========================================
    % Quality! 
	% =========================================
	disp(['Performing data quality check ' datestr(clock,'HH:MM:SS')]);
	QC_INFO = FACET_DAQ_QC(param,epics_data);
    
    % =========================================
    % Save 
	% =========================================
    disp(['Saving data ' datestr(clock,'HH:MM:SS')]);
	data=E200_gather_data(param,QC_INFO,epics_data,scanbool,E200_state,cam_back);
	slashloc=regexp(param.save_path,'/');
	savepath=fullfile(param.save_path(1:slashloc(end-2)),[param.experiment '_' num2str(param.n_saves) '.mat' ]);
    save(savepath,'data');
    
    % =========================================
    % Comment 
	% =========================================
    comt_str= sprintf([param.comt_str '\n']);
    DAQ_str = sprintf(['FACET DAQ ' num2str(param.n_saves) ' for ' param.experiment '.\n']);
    Data_str= sprintf([num2str(param.n_shot) ' shots per step and ' num2str(param.n_step) ' steps.\n']);
    if isfield(param,'fcnHandle')
        Func_str = sprintf(['Scan of ' char(param.fcnHandle) ' from ' num2str(param.Control_PV_start)...
            ' to ' num2str(param.Control_PV_end) '\n']);
    else
        Func_str = sprintf(['Simple DAQ' '\n']);
    end
    Path_str= sprintf(['Path: ' savepath '\n']);
    Comment = [comt_str DAQ_str Data_str Func_str Path_str];
    fprintf(Comment);
    if param.set_print2elog; FACET_DAQ2LOG(Comment,param); end;

end
