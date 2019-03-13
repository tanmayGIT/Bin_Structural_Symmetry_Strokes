function strokeWidth = CalculateStrokeWidth(gray_image)

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
 



% The partial implementation of the following paper (The part of stroke width calculation) 

% Bolan Su, Shijian Lu, & Chew Lim Tan. (2013). A Robust Document Image Binarization 
% Technique for Degraded Document Images. IEEE Transactions on Image Processing, 
% 22(4), 1408–1417.

% Date of Implementation : 08/01/2019


stdImag = std(std( double(gray_image) ));
gamma = 0.85;
alpha = power((stdImag/128), gamma);

epsilonSU = 0.001;

gray_image_Padded = padarray(gray_image,[1 1],'replicate');

% contrastImg  = zeros(size(gray_image_Padded,1), size(gray_image_Padded,2));
modContrastImg  = zeros(size(gray_image_Padded,1), size(gray_image_Padded,2));

for ii = 2:1:(size(gray_image_Padded,1)-1)
    for jj = 2:1:(size(gray_image_Padded,2)-1)
        
        % Now move the neighborhood
        keepAllNeighVals = zeros(8,1);
        cntNeigh = 1;
        for k = -1:1:1
            for j = -1:1:1
                if ((k ~= 0) || (j ~= 0) )
                    keepAllNeighVals(cntNeigh,1) = gray_image_Padded(ii+k, jj+j);
                    cntNeigh = cntNeigh + 1;
                end
            end
        end
        numera = (max(keepAllNeighVals) - min(keepAllNeighVals));
        denom = (max(keepAllNeighVals) + min(keepAllNeighVals) + epsilonSU);
        
        C_ij = double(numera)/double(denom);
        % fprintf('The numer : %f and Denom %f and the division result : %f \n',numera, denom,C_ij );
        C_a_ij = (alpha * C_ij) + ((1-alpha) * ((max(keepAllNeighVals) -  min(keepAllNeighVals))/255));
        
        % contrastImg(ii,jj) = C_ij;
        modContrastImg(ii,jj) = C_a_ij;
        
    end
end
% contrastImg = contrastImg(2:end-1, 2:end-1);
modContrastImg = modContrastImg(2:end-1, 2:end-1);


% Applly otsu binarization
level = graythresh(modContrastImg);
modContrastImgBin = imbinarize(modContrastImg,level);
% modContrastImgBin = imcomplement(modContrastImgBin);

% Canny edge detection
lowThresh = level;
highThresh = level * 0.5;
cannyImage = CannyEdgeDetection(gray_image, lowThresh, highThresh);
cannyImage = mat2gray(cannyImage);

strokeImg = bitand(modContrastImgBin,cannyImage);
keepAllPairDist = zeros(1,1);

for ii = 1:1:size(strokeImg,1)
    storIntensityCoord = zeros(1,1);
    pointCnt = 1;
    enterFlag = false;
    for jj = 1:1:(size(strokeImg,2)-1)
        if ((strokeImg(ii, jj) == 0 ) && (strokeImg(ii, jj+1) == 1 ))
            pixIntensity = gray_image(ii,jj);
            pixIntensityNext = gray_image(ii,jj+1);
            if (pixIntensity > pixIntensityNext)
                storIntensityCoord(pointCnt,1) = ii;
                storIntensityCoord(pointCnt,2) = jj;
                enterFlag = true;
                pointCnt = pointCnt +1;
            end
        end
    end
    if( (enterFlag) && (size(storIntensityCoord,1) > 1) )
        for kVec = 1:1:(size(storIntensityCoord,1)-1)
            distPts = sqrt((storIntensityCoord(kVec,1) - storIntensityCoord((kVec+1),1))^2+...
                (storIntensityCoord(kVec,2)-storIntensityCoord((kVec+1),2))^2);
            keepAllPairDist(kVec,1) = distPts;
        end
    end
end
strokeWidth = getPerfectAvgValues(keepAllPairDist');
end