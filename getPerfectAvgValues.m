%   Copyright (c) 2019. Tanmoy Mondal <tanmoy.besu@gmail.com>.
%   Released to public domain under terms of the BSD Simplified license.
%  
%   Redistribution and use in source and binary forms, with or without
%   modification, are permitted provided that the following conditions are met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the distribution.
%     * Neither the name of the organization nor the names of its contributors
%       may be used to endorse or promote products derived from this software
%       without specific prior written permission.
%  
%     See <http://www.opensource.org/licenses/bsd-license>

%  The idea of this algorithm is to divide the list of numbers into 10 bin 
%  histogram and then to select the top 2 bins based on the number of elements 
%  present in the bins. As we can calculate the bin limits of each bins i.e.
%  the bottom and top limit of each bins. So based on this information we
%  recheck the values and only take those which are coming inside these
%  limits. Now we calculate the mean and standard deviation of these refined 
%  values. If any value is in between (mean -std)  and (mean + std) are
%  considered as re-re-refined values and then we canculate the average of
%  only these values 

% Date of Implementation : 06/01/2019



function avgVal = getPerfectAvgValues(keepAllValues)
[n,xout] = hist(keepAllValues);
width = xout(2)-xout(1);
xoutmin = xout-width/2; % getting the lower limit of each bin 
xoutmax = xout+width/2; % getting the higher limit of each bin
[sortedVal,indices] = sort(n,'descend'); % sorting based on number of elements exists in a bin 

consideredVal = 2; % how many bins you are considering, we take the top two most bins which contains maximum elements
keepxoutmin = zeros(consideredVal,1);
keepxoutmax = zeros(consideredVal,1);

totalEleBucket = 0;
for kt = 1:1:consideredVal
    keepxoutmin(kt,1) = xoutmin(1,indices(1,kt));
    keepxoutmax(kt,1) = xoutmax(1,indices(1,kt));
    totalEleBucket = totalEleBucket + sortedVal(1,kt);
end

getValidDis = zeros(totalEleBucket,1);

tr = 1;
for m = 1:1:length(keepAllValues)
    dist = keepAllValues(1,m); % get the value 
    if(  (dist <= (max(keepxoutmax))) && ((min(keepxoutmin)) <= dist)  )
        getValidDis(tr,1) = dist;
        tr = tr +1;
    end
end

avgDistance = mean(getValidDis);
stdevDistance = std(getValidDis);

getimpDist = zeros(1,1);
tr = 1;
for m = 1:1:length(keepAllValues)
    dist = keepAllValues(1,m);
    if(  ( (avgDistance-stdevDistance) <= dist ) && (dist <= (avgDistance+stdevDistance))  )
        getimpDist(tr,1) = dist;
        tr = tr +1;
    end
end
avgVal = mean(getimpDist);
avgVal = round(avgVal);
return;
end