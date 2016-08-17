%this is to make things easier
%behavioral data analysis:
%ENTER SUBJECTS YOU WANT TO LOOK AT
allsubs = [2 3 4 5 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
% allsubs = [2]; %top 50
%Enter the electrode pair you want to look at:
%1 = O1O2, 2 = P3P4, 3 = P7P8, 4 = CP3CP4, 5 = TP7TP8, 6 = C3C4, 7 = T7T8, 8 = FC3FC4, 9 = FT7FT8, 10 = F3F4, 11 = F7F8, 12 = FP1FP2
pair = 2;
condition = 1;
%Set this 1 to filter for accuracy, 0 to include all trials
FilteredForAccuracy = 1;
%Organize EEG data. Set run_batcherp to 1 to run batcherp (takes awhile), 0
%if already ran.
run_batcherp = 1;
% if run_batcherp
%     for FilteredForAccuracy = 0:1
%         for true_target = 0:1
%             if FilteredForAccuracy
%                 if true_target
%                     nfilename = 'alldataFilteredTargets';
%                 else
%                     nfilename = 'alldataFilteredFalseTargets';
%                 end
%             else
%                 if true_target
%                     nfilename = 'alldataUnfilteredTargets';
%                 else
%                     nfilename = 'alldataUnfilteredFalseTargets';
%                 end
%             end
%             batcherp_2(1,allsubs,FilteredForAccuracy,true_target,nfilename)
%         end
%     end
% end
%This loads in the data that has been all nicely organized by batcherp. It
%comes either filtered for accuracy or not depending on whether
%load_unfiltered is set to 0 or 1.
load_unfiltered = 1;

subpos=1:length(allsubs);
load alldataFilteredTargets
[tn tc ti] = plotmasterdata(masterdata,pair,condition,subpos);
load alldataFilteredFalseTargets
[ftn ftc fti] = plotmasterdata(masterdata,pair,condition,subpos);

figure
plot(tn-5)
hold on
plot(ti,'r')
plot(tc,'c')
title 'Filtered Targets'
figure
plot(ftn-5)
hold on
plot(fti,'r')
plot(ftc,'c')
title 'Filtered False Targets'

if load_unfiltered
load alldataUnfilteredTargets
[utn utc uti] = plotmasterdata(masterdata,pair,condition,subpos);
load alldataUnfilteredFalseTargets
[uftn uftc ufti] = plotmasterdata(masterdata,pair,condition,subpos);
figure
plot(utn-5)
hold on
plot(uti,'r')
plot(utc,'c')
title 'Unfiltered Targets'
figure
plot(uftn-5)
hold on
plot(ufti,'r')
plot(uftc,'c')
title 'Unfiltered False Targets'
end
