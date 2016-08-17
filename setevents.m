function EEG = setevents(EEG,Userdata,FilteredForAccuracy,true_target)



Responseflag = 1;  %if 1, use behav data, if 2, use triggers

these_events = EEG.event;

load('top_50_cats.mat');

top_50_cats = top_50_cats + 66;

numevents = 0;


for(i = 1: length(these_events))
    
    if(ischar( these_events(i).type))
        
        if (these_events(i).type > 47 && these_events(i).type < 58)
            
            numevents = numevents + 1;
            types(numevents) = eval(these_events(i).type);
            latency(numevents) = these_events(i).latency;
            urevent(numevents) = these_events(i).urevent;
            
        else  %when we get those boundary events
            numevents = numevents + 1;
            types(numevents) = 0;
            latency(numevents) = 0;
            urevent(numevents) = 0;
        end
    else
        numevents = numevents + 1;
        types(numevents) = these_events(i).type;
        latency(numevents) = these_events(i).latency;
        urevent(numevents) = these_events(i).urevent;
    end
end

hits = 0;
thisevent = 1;

while (thisevent < length(types)-50)
    
    if(types(thisevent) == 13)
        
        %start of a trial!
        actualtrialnum3 = types(thisevent+1)-22;
        actualtrialnum2 = types(thisevent+3)-22;
        actualtrialnum1 = types(thisevent+5)-22;
        actualtrialnum = actualtrialnum3*100+actualtrialnum2*10+actualtrialnum1*1;
        
        trial = actualtrialnum;
        
        if (actualtrialnum > 3 && actualtrialnum <= length(correct))
            
            firstpossibleevent = 16;
            
            categoryevent = 7;
            
            cat_trigger = types(thisevent+categoryevent);
            
            %category filter
%             if sum(find(cat_trigger == top_50_cats))
               if(1)
                    
                output = 'good category'
                for evadd = firstpossibleevent: firstpossibleevent + 35
                    if true_target
                        %True Targets
                        if ((types(thisevent+evadd) == 104 || types(thisevent+evadd) == 105) && ...
                                (~FilteredForAccuracy||Userdata.Blocks.Trials(trial).Trial_Export.review_item == 'y'))
                            types(thisevent+evadd) = 980; %left
                            hits = hits +1;
                        elseif ((types(thisevent+evadd) == 103 || types(thisevent+evadd) == 106) && ...
                                (~FilteredForAccuracy||Userdata.Blocks.Trials(trial).Trial_Export.review_item == 'y'))
                            types(thisevent+evadd) = 990; %right
                            hits = hits +1;
                        end
                    else
                        %False Targets
                        if (((types(thisevent+evadd) == 102 || types(thisevent+evadd) == 106)) && ...
                                (~FilteredForAccuracy||Userdata.Blocks.Trials(trial).Trial_Export.review_item == 'y'))
                            types(thisevent+evadd) = 980; %left
                        elseif (((types(thisevent+evadd) == 101 || types(thisevent+evadd) == 105)) && ...
                                (~FilteredForAccuracy||Userdata.Blocks.Trials(trial).Trial_Export.review_item == 'y'))
                            types(thisevent+evadd) = 990; %right
                        end
                    end
                end
            end
        end
    end
    
    thisevent = thisevent + 1;
    
end

for i = 1:length(these_events)
    these_events(i).type = types(i);
end
hits
EEG.event = these_events;

