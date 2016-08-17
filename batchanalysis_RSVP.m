function batchresults = batchanalysis_blank()

%Image EEG RSVP batchanalysis script written by Michael Hess, May '16

%This code compensates for your operation systems preferences when accessing data files.
if IsOSX    %On a Mac or PC, choose the right data directory
    datadir='data/';
else
    datadir='data\';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Define data to be analyzed

% %Add in the subject numbers of the data files that you wish to analyze:
subnumlist = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];  %list here the subject numbers that you wish to use
%
% %Define numsubs as the length of subs in order to avoid hard-coding
% numsubs = length(subnum_list);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Begin Analysis

load('sub')

%Subject count, used because every subject number may not be used
count = 0;

%Rater number
rater = 1;

try
    clear correct
catch
    correct = 0;
end
% t = 0;
i = 1;
t=1;
u = 0;
%Loops through all of the subjects' data files
    for sub_length = 1:length(subnumlist)
        sub = subnumlist(i);
        i = i + 1;
        subject = sub %outputs subject number
        
%         t = 0;
        
        datafilename = sprintf('%sExpSub_compact_%d_judged%d.mat',datadir,sub,rater);
        
        correct_trials = 0; %reset correct trial count for each subject
        
        Userdata = load(datafilename);
        Userdata = Userdata.Userdata;
        
        %     count = count + 1;  %number of subjects so far
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Block #1 Analysis
        
        %Analysis of block #1  (there is only one block in this data file
        block = 1;
        
        numtrials = length(Userdata.Blocks(block).Trials)-3;
        
        %Loop through all of the trials in this block
        for trial = 4:numtrials
            
            %Importing rater responses
            user_review_item = Userdata.Blocks.Trials(trial).Trial_Export.review_item;
            
            %Importing which target category
            target_category = Userdata.Blocks.Trials(trial).Trial_Export.which_target_category;
                        
            %Importing which target
            target = Userdata.Blocks.Trials(trial).Trial_Export.which_target;
            
            
            u = u + 1;
            
            category_count(u) = target_category;
            
            if strcmp(user_review_item,'y')
                correct_trials = correct_trials + 1;
%                 correct(t) = 1;
                                
                category_array(t) = target_category;
                            t = t + 1;

%                 
%                 Expname = 'imageEEG';
%                 numsubs = 0;
%                 histgraph = figure;
%                 linegraph = figure;
%                 for(sub = sublist)
%                     numsubs = numsubs + 1;
%                     sprintf( 'loading data for subject #%d',sub)
%                     filename = sprintf('%ssub%d_250.set',Expname,sub);
%                     EEG = pop_loadset( 'filename', filename); %use EEGlab to load a file
%                     for chan = chans
%                         figure(histgraph)
%                         title(sprintf('line plot of chan %d of sub %d',chan,sub))
%                         plot(EEG.data(chan,:))
%                         figure(linegraph)
%                         hist(EEG.data(chan,:),1000);
%                         title(sprintf('histogram of chan %d of sub %d',chan,sub))
% %                         enter = input('any key to continue')
%                     end
%                 end

            else
%                 correct(t) = 0;
%                 t = t + 1;
            end
            
            if trial == numtrials
                correct_trials %outputs number of correct trials
            end
            
        end
                count = count + 1;
        %Number of responses marked correct by both raters divided by number of items (output)
        subject_accuracy = (correct_trials/(numtrials))*100
        
            total_accuracy(count) = subject_accuracy;
        
        %     if subject == numsubs
        if trial == numtrials
            sprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
            %             average_accuracy = sum(total_accuracy)/numsubs %outputs average accuracy of all subs
            %             min_accuracy = min(total_accuracy) %outputs min accuracy
            %             max_accuracy = max(total_accuracy) %outputs max accuracy
            %             x = size(correct) %check size of correct trial output
            %             csvwrite('sub_correct_trials',correct)
%             save('correct_trials','correct');
        end
    end
%     sca
%     keyboard
        for i = 1:27
            accurate(i) = sum(category_array(:)==i);
            total(i) = sum(category_count(:)==i);
        end
%         sca
%         keyboard
%         h = histogram(category_array)
%         i = histogram(category_count)
%         j = category_array./category_count
%         k = histogram(j)
category_accuracy = accurate./total
c = 0;
for i = 1:27
    median_cat_accuracy = median(category_accuracy);
    if category_accuracy(i) >= median_cat_accuracy
        c = c + 1;
        top_50_cats(c) = i;
    end
end
top_50_cats
save top_50_cats
median_sub_accuracy = median(total_accuracy)
% p = 0;
% for a = 1:length(subnumlist)
%     if total_accuracy(a) >= median_accuracy
%         p=p+1;
%         top_50_subs(p) = subnumlist(a);
%     end
% end
% top_50_subs
category_accuracy_graph = bar(category_accuracy)

%     if sub == 1
%         sca
%         keyboard
%     end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% end
%What values do you want the analysis file to return upon running the script?
% batchresults.subnum_list = subnum_list;