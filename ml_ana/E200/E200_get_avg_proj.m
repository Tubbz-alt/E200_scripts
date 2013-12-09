%% E200_get_avg_proj
%  Function to get average profiles in x & y from a dataset
%  for a given scan step number, if given
%
%  M.Litos Dec.8,2013
function [data, avg_proj_x, avg_proj_y ] = E200_get_avg_proj( data, cam_name, scan_step )

% make plots?
plots_on = false;

% scan step given?
if nargin<3
    scan_step = -1;
end

% get preprocessed data struct
preproc = data.processed.vectors.(cam_name).preproc;

% get UIDs <-- necessary?
uid = data.raw.images.(cam_name).UID;

% get scan step numbers
if isfield(data.raw.scalars,'step_num')
    step_num = data.raw.scalars.step_num.dat;
end

% get initial sizes
proj_x1 = cell2mat(preproc.x_proj_cnts_px.dat(1)); % x-projection
proj_y1 = cell2mat(preproc.y_proj_cnts_px.dat(1)); % y-projection
init_size_x = length(proj_x1);
init_size_y = length(proj_y1);

% set full sizes
full_size_x = 2*init_size_x;
full_size_y = 2*init_size_y;

%% loop over shots
nshot = length(uid);
avg_proj_x = zeros(1,full_size_x);
avg_proj_y = zeros(1,full_size_y);
avg_pk_ind_x = 0;
avg_pk_ind_y = 0;
nshot_used = 0;
for ishot=1:nshot

    % only do one scan step, if given
    if (scan_step>0 && step_num(ishot)~=scan_step)
        continue;
    else
        nshot_used=nshot_used+1;
    end
    
    % make projections
    proj_x = cell2mat(preproc.x_proj_cnts_px.dat(ishot)); % x-projection
    proj_y = cell2mat(preproc.y_proj_cnts_px.dat(ishot)); % y-projection
    
    % smooth projections
    smproj_x = mlsmooth(proj_x);
    smproj_y = mlsmooth(proj_y);
    
    % find peak location
    [x_pk_val, x_pk_ind] = max(smproj_x);
    [y_pk_val, y_pk_ind] = max(smproj_y);
    
    
    avg_pk_ind_x = avg_pk_ind_x + x_pk_ind;
    avg_pk_ind_y = avg_pk_ind_y + y_pk_ind;
    

    % find center locations
    x_cent = round(length(proj_x)/2);
    y_cent = round(length(proj_y)/2);
    
    % center peak using buffers
    if x_pk_ind>length(proj_x)/2
%         proj_x = mlpadarray(proj_x,[0 round(2*abs(x_pk_ind-x_cent))],0,'post');
        pad = zeros(1,round(2*abs(x_pk_ind-x_cent)));
        proj_x = [proj_x pad];
    else
%         proj_x = mlpadarray(proj_x,[0 round(2*abs(x_pk_ind-x_cent))],0,'pre');
        pad = zeros(1,round(2*abs(x_pk_ind-x_cent)));
        proj_x = [pad proj_x];
    end        
    if y_pk_ind>length(proj_y)/2
%         proj_y = mlpadarray(proj_y,[0 round(2*abs(y_pk_ind-y_cent))],0,'post');
        pad = zeros(1,round(2*abs(y_pk_ind-y_cent)));
        proj_y = [pad proj_y];
    else
%         proj_y = mlpadarray(proj_y,[0 round(2*abs(y_pk_ind-y_cent))],0,'pre');
        pad = zeros(1,round(2*abs(y_pk_ind-y_cent)));
        proj_y = [proj_y pad];
    end        
    
    % buffer more so that all images reach same uniform size
%     proj_x = mlpadarray(proj_x,[0 round((full_size_x-length(proj_x))/2)]);
    pad = zeros(1,round((full_size_x-length(proj_x))/2));
    proj_x = [pad proj_x pad];
%     proj_y = mlpadarray(proj_y,[0 round((full_size_y-length(proj_y))/2)]);
    pad = zeros(1,round((full_size_y-length(proj_y))/2));
    proj_y = [pad proj_y pad];
    
    % fine adjust length if off by one or two bins
    while length(proj_x)<full_size_x
        proj_x(end+1) = 0;
    end
    while length(proj_x)>full_size_x
        proj_x = proj_x(1:end-1);
    end
    while length(proj_y)<full_size_y
        proj_y(end+1) = 0;
    end
    while length(proj_y)>full_size_y
        proj_y = proj_y(1:end-1);
    end
    
    avg_proj_x = avg_proj_x + proj_x;
    avg_proj_y = avg_proj_y + proj_y;    

%     figure(1);
%     plot(proj_x);
%     
%     figure(2);
%     plot(proj_y);
    
end

avg_proj_x = avg_proj_x/nshot_used;
avg_proj_y = avg_proj_y/nshot_used;


avg_pk_ind_x = avg_pk_ind_x/nshot_used;
avg_pk_ind_y = avg_pk_ind_y/nshot_used;

offset_x = round(full_size_x/2-avg_pk_ind_x);
avg_proj_x = avg_proj_x(offset_x:offset_x+init_size_x);

offset_y = round(full_size_y/2-avg_pk_ind_y);
avg_proj_y = avg_proj_y(offset_y:offset_y+init_size_y);

% make plots
if (plots_on)

    figure(3);
    plot(avg_proj_x);

    figure(4);
    plot(avg_proj_y);

end
    
% create data.processed.vectors.cam_name.tomo.avg_proj_x.[UID, dat, units,description]
data = E200_add_proc_vector(data,cam_name,'tomo',1,1, ...
            avg_proj_x,'avg_proj_x','counts', ...
            'Average projection in x in counts.',scan_step);
% create data.processed.vectors.cam_name.tomo.avg_proj_y.[UID, dat, units,description]
data = E200_add_proc_vector(data,cam_name,'tomo',1,1, ...
            avg_proj_y,'avg_proj_y','counts', ...
            'Average projection in y in counts.',scan_step);

end
