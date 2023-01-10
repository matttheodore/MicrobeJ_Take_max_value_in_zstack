
%%
clear
clc
tic
load maxima1.mat;   %load your maxima file

nT = 16;  % number of timepoints
nZ = 5;   % number of z stacks taken
nC = 4;   % number of channels

maxima1_fociIntensities = cell(nT,nZ); %for now defining single timepoint arbitrarily using 11
foci_intensities = cell(nT,nZ); 
%%

for i = 1:nT

    cnt = 1; % needed because the number of positions is unknown for each time point
    for nSpot = 1:length(maxima1) 

        if maxima1(nSpot).POSITION.position == i 
            
            maxima1_fociIntensities{i,cnt} = maxima1(nSpot,:);
            cnt = cnt + 1;
            
        end

    end

    % find max intensity at current time point
    for j = 1:nZ
        % index maxima1_fociIntensities cell array to get out the structure
        %   for each z slice
        first = maxima1_fociIntensities{i,j};
        if isempty(first) == 1
            break
        else
            % ensures the maximum is always pulled
            %channelVal = zeros(1,1);
            for k = 3
                channelVal = first.INTENSITY.ch(k).sum;
            end
            foci_intensities{i,j} = channelVal;
            
        end
        
    end
    

%indx = find(cellfun(@isempty,foci_intensities))
%foci_intensities2(indx) = {[]}

    
    %max = max(foci_intensities, [], 2)
%[M, I] = max(foci_intensities, [], 2)
    %maxima1max = [];    %this will be where all the maxima files will end

end

%%
for i = 1:nT 
    for j = 1:nZ
        if isempty(foci_intensities{i,j}) == 1;
            foci_intensities{i,j} = 0;
        end
    end
end

foci_intensities_mat = cell2mat(foci_intensities) 
[M,S] = max(foci_intensities_mat')  % transpose function with apostrophe 
%%
cell_index = cell(nT, 1);

for i = 1:nT
    cell_index{i,1} = maxima1_fociIntensities{i, S(i)};
end

toc