
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




% The partial implementation of the following papers :

% Jia, F., Shi, C., He, K., Wang, C., & Xiao, B. (2016). Document image
% binarization using structural symmetry of strokes. Frontiers in Handwriting
% Recognition (ICFHR), 2016 15th International Conference On, 411–416.


% Jia, F., Shi, C., He, K., Wang, C., & Xiao, B. (2018). Degraded document
% image binarization using structural symmetry of strokes. Pattern Recognition,
% 74, 225–240.


% Date of Implementation : 06/01/2019




clear
close all
clc
% imgPath = '/Volumes/Study_Materials/Dataset/Binarization/Short_All_Images/HW07_DIBCO_13.bmp';
imgPath = 'HW8.png';
origImg = imread(imgPath);
if(size(origImg,3)==3)
    origImg = rgb2gray(origImg);
end
output = niblack(origImg, [60 60], -0.2, 0, 'replicate');
% output = mat2gray(output);
% figure, imshow(output);
NormImag = BackGroundRemoval(origImg, output);






[Grad_Complete_Img, thetaGradImage] = GradientComputation(NormImag);

% Applly otsu binarization
level = graythresh(Grad_Complete_Img);
binGrad_Complete_Img = imbinarize(Grad_Complete_Img,level);
% figure,imshow(binGrad_Complete_Img);

% After the above processing, the potential SSP is extracted: the binarized gradient image (binGrad_Complete_Img)
% indicates its positions and the  original image I (origImg) indicates the intensities.
S_p = binGrad_Complete_Img;

% Calculate stroke width
strokeWidth = CalculateStrokeWidth(origImg);

winX = round(strokeWidth/2);
winY = round(strokeWidth/2);
% Judging the density of potential SSP
S_p_Padded = padarray(S_p,[ winX winY],'replicate');
thetaGradImage_Padded = padarray(thetaGradImage,[ winX winY],'replicate');
NormImage_Padded = padarray(NormImag,[ winX winY],'replicate');

% Assume that all pixels of the image are foreground pixels (1s)
L_p_ForeGround_Image = ones(size(S_p_Padded));


alphaStrokeWidth = 0.3;
betaAngleThresh = 0.75;
deltaLocalThresh = 5;
% contrastImg  = zeros(size(gray_image_Padded,1), size(gray_image_Padded,2));
mod_S_p_Padded_Img  = zeros(size(S_p_Padded,1), size(S_p_Padded,2));


% Define the group of angles here
% Define the group of angles here
Angle_Top_Left = 150;
Angle_Top_Right = 15;

Angle_Bottom_Left = 210;
Angle_Bottom_Right = 345;

Angle_Left_Left = 105;
Angle_Left_Right = 240;

Angle_Right_Left_1 = 300;
Angle_Right_Left_2 = 360;
Angle_Right_Right_1 = 0;
Angle_Right_Right_2 = 75;

Angle_TopRigt_Left_1 = 345;
Angle_TopRigt_Left_2 = 360;
Angle_TopRight_Right_1 = 0;
Angle_TopRight_Right_2 = 105;

Angle_BottomLeft_Left = 165;
Angle_BottomLeft_Right = 300;

Angle_Top_Left_Left = 75;
Angle_Top_Left_Right = 210;

Angle_Bottom_Right_Left_1 = 0;
Angle_Bottom_Right_Left_2 = 15;
Angle_Bottom_Right_Right_1 = 250;
Angle_Bottom_Right_Right_2 = 360;


for ii = (winY+1):1:(size(S_p_Padded,1)-winY)
    for jj = (winX+1):1:(size(S_p_Padded,2)-winX)
        
        % Now move the neighborhood
        cntGoodNeigh = 0;
        
        groupTop = 0;
        groupBot = 0;
        groupLeft = 0;
        groupRight = 0;
        groupTopLeft = 0;
        groupBotLeft = 0;
        groupTopRight = 0;
        groupBottomRight = 0;
        
        sumNeighBor = 0;
        enterFlag = false;
        
        neighCnt = 0;
        for k = -winY:1:winY
            for j = -winX:1:winX
                if ((k ~= 0) || (j ~= 0) ) % To avoid the center pixel
                    
                    if( (S_p_Padded(ii+k, jj+j) == 1) )  % we would check the neighborhood in potential SSP image  which is binarized sobel gradient image
                        getAngleNeigh = thetaGradImage_Padded(ii+k, jj+j);
                        if((Angle_Top_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_Top_Right))
                            groupTop = groupTop + 1;
                        end
                        if((Angle_Bottom_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_Bottom_Right))
                            groupBot = groupBot + 1;
                        end
                        if((Angle_Left_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_Left_Right))
                            groupLeft = groupLeft + 1;
                        end
                        if( ((Angle_Right_Left_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_Right_Left_2)) ||...
                                ((Angle_Right_Right_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_Right_Right_2)) )
                            groupRight = groupRight + 1;
                        end
                        if( ((Angle_TopRigt_Left_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_TopRigt_Left_2)) ||...
                                ((Angle_TopRight_Right_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_TopRight_Right_2)) )
                            groupTopLeft = groupTopLeft + 1;
                        end
                        if((Angle_BottomLeft_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_BottomLeft_Right))
                            groupBotLeft = groupBotLeft + 1;
                        end
                        if((Angle_Top_Left_Left <= getAngleNeigh) && (getAngleNeigh <= Angle_Top_Left_Right))
                            groupTopRight = groupTopRight + 1;
                        end
                        if( ((Angle_Bottom_Right_Left_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_Bottom_Right_Left_2))|| ...
                                ((Angle_Bottom_Right_Right_1 <= getAngleNeigh) && (getAngleNeigh <= Angle_Bottom_Right_Right_2)) )
                            groupBottomRight = groupBottomRight + 1;
                        end
                        
                        cntGoodNeigh = cntGoodNeigh + 1;
                        
                        getBin = uint8 (S_p_Padded(ii+k, jj+j));
                        sumNeighBor = sumNeighBor + double (NormImage_Padded(ii+k, jj+j) * getBin);
                        enterFlag = true;
                    end
                    neighCnt = neighCnt + 1;
                end
            end
        end
        
        
        
        %% PLEASE NOTE THAT THIS PART IS CONFUSING FOE ME AS THE AUTHOR HAS
        % NOT MENTIOEND CLEARLY HOW THEY HAVE APPPLIED THIS CONDITIONS
        
        
        % THE ONLY INFROMATION IS AVAILABLE FROM THE ORIGINAL PAPER IS :
        % "﻿Binarization images achieved by density judgement, symmetry judgement and
        % local threshold sequentially. (see the caption of Fig. 4)"
        
        % I have implemented it in the way I understood (find it logical) it but may be this
        % is not the same as the way the authors of the paper wanted to mean
        
        if(enterFlag)
            % Density Adjustment
            if(cntGoodNeigh < (alphaStrokeWidth * strokeWidth))
                L_p_ForeGround_Image(ii,jj) = 0; % making background
            else
                % Symmetry Adjustment
                getMaxVals = max([groupTop,groupBot,groupLeft,groupRight,groupTopLeft,groupBotLeft,groupTopRight,groupBottomRight]);
                if(getMaxVals > (betaAngleThresh * cntGoodNeigh))
                    L_p_ForeGround_Image(ii,jj) = 0; % making background
                else
                    % Local threshold Adjustment
                    T_p = sumNeighBor/ cntGoodNeigh;
                    threshVal = round(min((T_p + deltaLocalThresh), 255));
                    if(NormImage_Padded(ii, jj) > threshVal) % if the pixel gray value is more than average gray value of neighboring SSPs then it is backgd
                        L_p_ForeGround_Image(ii,jj) = 0; % making background
                    else
                        L_p_ForeGround_Image(ii,jj) = 1; % make it foregd (which is already done)
                    end
                end
            end
        else
            L_p_ForeGround_Image(ii,jj) = 0; % making background
        end
        %%
        
        
        
    end
end

L_p_ForeGround_Image = L_p_ForeGround_Image((winY+1):(size(S_p_Padded,1)-winY), (winX+1):(size(S_p_Padded,2)-winX));
figure, imshow(L_p_ForeGround_Image);

