%This program will allow you to scroll through each channel of each subject
%to determine bad channels

rmpath C:\Users\callahac\Documents\eeglab12_0_2_5b\eeglab12_0_2_5b\functions\octavefunc\signal
addpath CatFeatExpDATA
chans = [1:29];
sublist = [2 3 4 5 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
%On a Mac or PC, choose the right data directory
if IsOSX
    separator='/';
else
    separator='\\';
end
addpath 'data'
Expname = 'imageEEG';
numsubs = 0;
histgraph = figure;
linegraph = figure;
for(sub = sublist)
    numsubs = numsubs + 1;
    sprintf( 'loading data for subject #%d',sub)
    filename = sprintf('%ssub%d_250.set',Expname,sub);
    EEG = pop_loadset( 'filename', filename); %use EEGlab to load a file
    for (chan = chans)
        figure(histgraph)
        title(sprintf('line plot of chan %d of sub %d',chan,sub))
        plot(EEG.data(chan,:))
        figure(linegraph)
        hist(EEG.data(chan,:),1000);
        title(sprintf('histogram of chan %d of sub %d',chan,sub))
        enter = input('any key to continue')
    end
end
close(linegraph)
close(histograph)
    
        