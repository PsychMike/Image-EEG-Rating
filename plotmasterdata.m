
function [N2pc Contra Ipsi] = plotmasterdata(masterdata,pair,condition,subpos)

pairleft = [2,12,11,13,18,19,24,26,25,27,29,14];
pairright = [1,5,7,6,9,8,10,16,17,22,23,28];

criticalElectrodes = [pairleft,pairright];

switch(pair)
    case(1)
        pairname = 'O1O2';
    case(2)
        pairname = 'P3P4';
    case(3)
        pairname = 'P7P8';
    case(4)
        pairname = 'CP3CP4';
    case(5)
        pairname = 'TP7TP8';
    case(6)
        pairname = 'C3C4';
    case(7)
        pairname = 'T7T8';
    case(8)
        pairname = 'FC3FC4';
    case(9)
        pairname = 'FT7FT8';
    case(10)
        pairname = 'F3F4';
    case(11)
        pairname = 'F7F8';
    case(12)
        pairname = 'FP1FP2';

end

trialcriterion = 30;

Checktrialscountacrosslocations = 0;

N2pc=[];
Contra=[];
Ipsi=[];
HEOL = [];
HEOR = [];

goodsubs = 0;

eyebad = 0;

reject_thresh = 100;

fp = fopen('trialcounts.csv','w');


%for sub=1:size(masterdata,1)
for sub = subpos

    %tempHEOL = mean(masterdata{n,location,condition}.HEOLefttarget,3);
    %tempHEOR = mean(masterdata{n,location,condition}.HEOrighttarget,3);

    %perform threshold rejection
    goodtrials = 0;
    % con = condition;

    %eliminate all trials in which the threshold is exceeded on left
    %channel
    for(temppair = pair)
        locleft = pairleft(temppair);
        locright = pairright(temppair);
        for( con  = 1)
            goodtrials = 0;
            if(size(masterdata{sub,con,locleft,1},1)==1)
                masterdata{sub,con,locleft,1} = masterdata{sub,con,locleft,1}';
                masterdata{sub,con,locright,1} = masterdata{sub,con,locright,1}';
            end
            for(trial = 1:size(masterdata{sub,con,locleft,1},2))
                eegdatal = masterdata{sub,con,locleft,1}(:,trial);
                eegdatar = masterdata{sub,con,locright,1}(:,trial);
                if(max(abs(eegdatal(200:500,1))) >  reject_thresh)  %check voltage from -200 to + 1000 msec
                    goodtrials(trial) = 0;
                else
                    goodtrials(trial) = 1;
                end
            end
            goodtrials = find(goodtrials ==1);

            %cut out the bad trials from the left
            masterdata{sub,con,locleft,1} = masterdata{sub,con,locleft,1}(:,goodtrials);
            masterdata{sub,con,locright,1} = masterdata{sub,con,locright,1}(:,goodtrials);

            goodtrials = 0;
            if(size(masterdata{sub,con,locleft,2},1)==1)
                masterdata{sub,con,locleft,2} = masterdata{sub,con,locleft,2}';
                masterdata{sub,con,locright,2} = masterdata{sub,con,locright,2}';

            end
            for(trial = 1:size(masterdata{sub,con,locleft,2},2))
                eegdatal = masterdata{sub,con,locleft,2}(:,trial);
                eegdatar = masterdata{sub,con,locright,2}(:,trial);

                if(max(abs(eegdatal(200:500,1))) >  reject_thresh)
                    goodtrials(trial) = 0;
                else
                    goodtrials(trial) = 1;
                end
            end
            goodtrials = find(goodtrials ==1);
            %cut out the bad trials from the right
            masterdata{sub,con,locleft,2} = masterdata{sub,con,locleft,2}(:,goodtrials);
            masterdata{sub,con,locright,2} = masterdata{sub,con,locright,2}(:,goodtrials);
        end
    end

    %check to reject subjects for having too few trials

    checkconds  = 1;

    if(Checktrialscountacrosslocations)  %check across all electrode pairs?
        loccount = 0;
        for(loc = [pairleft,pairright])
            %for(loc = [1,2,5,12])
            loccount = loccount + 1;
            for(con = checkconds)
                trialcounts(sub,con,loccount) = size(masterdata{sub,con,loc,1},2) + size(masterdata{sub,con,loc,2},2);
            end
        end
    else    %or are we just checking across the current pair?
        locleft = pairleft(pair);
        locright = pairright(pair);

        for(con = checkconds)
            trialcounts(sub,con,1) = size(masterdata{sub,con,locleft,1},2) + size(masterdata{sub,con,locleft,2},2);
            trialcounts(sub,con,2) = size(masterdata{sub,con,locright,1},2) + size(masterdata{sub,con,locright,2},2);
        end

    end


    if(min(min(trialcounts(sub,checkconds,:))) >= trialcriterion)
        subjectgood = 1;
        goodsubs = goodsubs + 1
    else
        subjectgood = 0;
    end

    fprintf(fp,'%d,',min(min(trialcounts)));

    sprintf('trialcounts: %d',trialcounts)


    startpoint = 1;
    %endpoint = 750;
    endpoint = size(masterdata{1,1,1,1}(:,1),1);
    if(subjectgood)

        %compute the N2pc for this subject
        subipsi{sub} = [masterdata{sub,condition,pairleft(pair),1}(startpoint:endpoint,:),masterdata{sub,condition,pairright(pair),2}( startpoint:endpoint,:)];
        subcontra{sub} = [masterdata{sub,condition,pairright(pair),1}( startpoint:endpoint,:),masterdata{sub,condition,pairleft(pair),2}( startpoint:endpoint,:)];
        subn2pc{sub} = subcontra{sub}-subipsi{sub};
 

        N2pcsub{sub}=mean(subn2pc{sub},2);
        Contrasub{sub}=mean(subcontra{sub},2);
        Ipsisub{sub}=mean(subipsi{sub} ,2);

        if(size(N2pc,1) ==0)
            N2pc =  mean(subn2pc{sub},2) ;
            Ipsi = mean(subipsi{sub} ,2);
            Contra = mean(subcontra{sub} ,2);
        else
            N2pc =  N2pc+  mean(subn2pc{sub},2);
            Ipsi = Ipsi + mean(subipsi{sub} ,2);
            Contra = Contra + mean(subcontra{sub} ,2);
        end
        save('N2pcsub','N2pcsub','subn2pc');
        save('Contrasub','Contrasub','subcontra');
        save('Ipsisub','Ipsisub','subipsi');

    end

end





trialcounts

N2pc = N2pc/goodsubs;
Ipsi = Ipsi/goodsubs;
Contra= Contra/goodsubs;





save('N2pc','N2pc','trialcounts');
save('Contra','Contra','trialcounts');
save('Ipsi','Ipsi','trialcounts');



sprintf('Goodsubs: %d',goodsubs)



fprintf(fp,'\n')
fclose(fp);


end
%end
