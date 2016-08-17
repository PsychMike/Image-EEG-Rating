function batcherp_2(numCons,sublist,FilteredForAccuracy,true_target,nfilename)

%all of the channels you would like to consider.
chans = [1:31];
samrate=500; %sampling rate
addpath 'data'

%the start of the ERP that is of interest, in the unit of seconds
timestart = -1;
%The end of the ERP that is of interst,in the unit of seconds
timestop = 2;
%number of time points that are included in the specified time window
erppoints = (timestop-timestart) * samrate;

%enter the prefix of your EEG files after they have been reformatted by
%EEGLab
% Expname = ExpName;
%here enter noisy channels that you would like removed, and their data
%interpolated from neighboring channels
badchans = {[20],[20],[20],[20,28],[20],[20],[20],[20],[20],[20],[20],[20],[20],[20],[20],[20],[20],[20]};
numsubs = 0;
subs_that_broke_it=[];

targEvents = [980:989;990:999];
for(sub = sublist)
    %     try
    numsubs = numsubs + 1;
    sprintf( 'Attempting epoch for subject #%d',sub)
    filename = sprintf('imageEEGsub%d_250.set',sub);
    EEG = pop_loadset( 'filename', filename); %use EEGlab to load a file
    
    filename2 = sprintf('ExpSub_compact_%d_judged1',sub);%loads in behavioral data (not compact version)
    load(filename2);
    
    %resamples EEG for smaller data file
%     EEG = pop_resample(EEG,250);
    
    Heyechan = 30; % HEO
    Veyechan = 31; %VEO
    Hthresh = 20; %horizontal threshold
    Vthresh = 100; %vertical threshold
    
    %set events cycles through every trial and using behavioral
    %data will rename the triggers depending on whether they were
    %reported accurately
    
    EEG =  setevents(EEG,Userdata,FilteredForAccuracy,true_target);
  
    %%%%%%%%%%%%%%
    %eliminate bad channels
%     
%     load chanlocs %sets the locations of the channels
%     EEG.chanlocs = EEGchanlocs;
%     %this interpolates the bad channels
%     try
%     if isempty(badchans{sub}) == 0
%         EEG = pop_interp(EEG,badchans{sub},'spherical');
%     end
%     catch
%     end
    
    for condition = 1:numCons
        for leftright = 1:2;
            if leftright == 1
                targevent = 980;
            else
                targevent = 990;
            end
            
            %next we create time windows around our new triggers, dependent
            %on parameters we set above
            try
                EEG_1con1side= pop_epoch( EEG, {targevent}, [-1  2], 'newname', 'tempname', 'epochinfo', 'yes');
            catch
                keyboard
            end
            
            %this removes the baseline by making the average voltage
            %between -200ms and 0ms equal to zero
            EEG_1con1side = pop_rmbase(EEG_1con1side,[-200 0]);   
            thisEEG = EEG_1con1side;
            
            if(isstruct(thisEEG) ~= 1)
                masterdata{numsubs,condition,chan,leftright} = 0;
            else
                %eliminate eye movement trials
                thisEEG=EyeAR(thisEEG,Heyechan,Hthresh);
                thisEEG=blinkAR(thisEEG,Veyechan,Vthresh,sub,0);
                for chan = chans
                    eegdata = squeeze(thisEEG.data(chan,:,:));
                    
                    masterdata{numsubs,condition,chan,leftright} = eegdata;
                end
            end
            
        end
    end
    %     catch
    %         subs_that_broke_it = [subs_that_broke_it, sub];
    %         sprintf('SUB #%d BROKE IT',sub)
    %     end
end


%this saves all the data into a matlab file
% if FilteredForAccuracy == 1
%     fname = 'alldataUnfilteredFalseTargets';
% else
%     fname = 'alldatamultiNOFILTER';
% end

save(nfilename,'masterdata','sublist');

%for (sub = sublist)
%filename = sprintf('%s_sub%d.set',fname,sub);
%specificdata = masterdata(sub,:,:,:);
%save(filename,'specificdata');
%end



