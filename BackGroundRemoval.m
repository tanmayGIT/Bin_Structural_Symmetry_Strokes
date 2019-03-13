function NormImag = BackGroundRemoval(origImg, output)


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

% Ntirogiannis, K., Gatos, B., & Pratikakis, I. (2014). 
% A combined approach for the binarization of handwritten document images. Pattern Recognition Letters, 
% 35(1), 3–15.

% SEE SECTION : 2.1
% Date of Implementation : 08/01/2019






nRows = size(origImg,1);
nCols = size(origImg,2);

copyDialatedBackGdMasks = output;
copyOrigImg = origImg;


X_Start = [1, 1, nCols, nCols];
X_End = [nCols, nCols, 1, 1];
Y_Start = [1, nRows, 1, nRows];
Y_End = [nRows, 1, nRows, 1];

putAll_P_Image = cell(4,1);
DialatedBackGdMasks = copyDialatedBackGdMasks;
temp_P_Image = zeros(nRows,nCols);




%% ****   First Image     ***/
for yy = (Y_Start(1)+1):1:(Y_End(1)-1) % For the rows
    for xx = (X_Start(1)+1):1:(X_End(1)-1) % For the columns
        
        if(DialatedBackGdMasks(yy,xx) == 0)
            avgVals =  [ (copyOrigImg(yy,xx-1) *  DialatedBackGdMasks(yy,xx-1)),...
                (copyOrigImg(yy-1,xx) * DialatedBackGdMasks(yy-1,xx)),...
                (copyOrigImg(yy,xx+1) * DialatedBackGdMasks(yy,xx+1)),...
                (copyOrigImg(yy+1,xx) * DialatedBackGdMasks(yy+1,xx))] ;
            avgVal = mean(avgVals(avgVals~=0));
            temp_P_Image(yy,xx) = round(avgVal);
            copyOrigImg(yy,xx) = round(avgVal);
            DialatedBackGdMasks(yy,xx) = 1;
        else
            temp_P_Image(yy,xx) = origImg(yy,xx);
        end
    end
end
transTemp_P_Img_1 = uint8(temp_P_Image);
putAll_P_Image{1,1} = transTemp_P_Img_1;
DialatedBackGdMasks = copyDialatedBackGdMasks;
temp_P_Image = zeros(nRows,nCols);

%% ****   Second Image     ***/
for yy = (Y_Start(2)-1):-1:(Y_End(2)+1)
    for xx = (X_Start(2)+1):1:(X_End(2)-1)
        if(DialatedBackGdMasks(yy,xx) == 0)
            avgVals =  [ (copyOrigImg(yy,xx-1) *  DialatedBackGdMasks(yy,xx-1)),...
                (copyOrigImg(yy-1,xx) * DialatedBackGdMasks(yy-1,xx)),...
                (copyOrigImg(yy,xx+1) * DialatedBackGdMasks(yy,xx+1)),...
                (copyOrigImg(yy+1,xx) * DialatedBackGdMasks(yy+1,xx))] ;
            avgVal = mean(avgVals(avgVals~=0));
            temp_P_Image(yy,xx) = round(avgVal);
            copyOrigImg(yy,xx) = round(avgVal);
            DialatedBackGdMasks(yy,xx) = 1;
        else
            temp_P_Image(yy,xx) = copyOrigImg(yy,xx);
        end
    end
end

transTemp_P_Img_2 = uint8(temp_P_Image);
putAll_P_Image{2,1} = transTemp_P_Img_2;
DialatedBackGdMasks = copyDialatedBackGdMasks;
temp_P_Image = zeros(nRows,nCols);


%% ***   Third Image     ***/
for yy = (Y_Start(3)+1):1:(Y_End(3)-1)
    for xx = (X_Start(3)-1):-1:X_End(3)+1
        
        if(DialatedBackGdMasks(yy,xx) == 0)
            avgVals =  [ (copyOrigImg(yy,xx-1) *  DialatedBackGdMasks(yy,xx-1)),...
                (copyOrigImg(yy-1,xx) * DialatedBackGdMasks(yy-1,xx)),...
                (copyOrigImg(yy,xx+1) * DialatedBackGdMasks(yy,xx+1)),...
                (copyOrigImg(yy+1,xx) * DialatedBackGdMasks(yy+1,xx))] ;
            avgVal = mean(avgVals(avgVals~=0));
            temp_P_Image(yy,xx) = round(avgVal);
            copyOrigImg(yy,xx) = round(avgVal);
            DialatedBackGdMasks(yy,xx) = 1;
        else
            temp_P_Image(yy,xx) = copyOrigImg(yy,xx);
        end
    end
end

transTemp_P_Img_3 = uint8(temp_P_Image);
putAll_P_Image{3,1} = transTemp_P_Img_3;
DialatedBackGdMasks = copyDialatedBackGdMasks;
temp_P_Image = zeros(nRows,nCols);


%% ****   Fourth Image     ***/
for yy = (Y_Start(4)-1):-1:Y_End(4)+1
    for xx = (X_Start(4)-1):-1:(X_End(4)+1)
        
        if(DialatedBackGdMasks(yy,xx) == 0)
            avgVals =  [ (copyOrigImg(yy,xx-1) *  DialatedBackGdMasks(yy,xx-1)),...
                (copyOrigImg(yy-1,xx) * DialatedBackGdMasks(yy-1,xx)),...
                (copyOrigImg(yy,xx+1) * DialatedBackGdMasks(yy,xx+1)),...
                (copyOrigImg(yy+1,xx) * DialatedBackGdMasks(yy+1,xx))] ;
            avgVal = mean(avgVals(avgVals~=0));
            temp_P_Image(yy,xx) = round(avgVal);
            copyOrigImg(yy,xx) = round(avgVal);
            DialatedBackGdMasks(yy,xx) = 1;
        else
            temp_P_Image(yy,xx) = copyOrigImg(yy,xx);
        end
    end
end

transTemp_P_Img_4 = uint8(temp_P_Image);
putAll_P_Image{4,1} = transTemp_P_Img_4;

DialatedBackGdMasks = copyDialatedBackGdMasks;
backGdImag = zeros(nRows,nCols);
for yy = Y_Start(1):1:Y_End(1)
    for xx = X_Start(1):1:X_End(1)
        if(DialatedBackGdMasks(yy,xx) == 0)
            val1 = putAll_P_Image{1,1}(yy,xx);
            val2 = putAll_P_Image{2,1}(yy,xx);
            val3 = putAll_P_Image{3,1}(yy,xx);
            val4 = putAll_P_Image{4,1}(yy,xx);
            minValue = [ val1 val2 val3 val4];
            backGdImag(yy, xx) = min(minValue);
        else
            backGdImag(yy, xx) = origImg(yy,xx);
        end
    end
end
transTemp_backGd_Img = uint8(backGdImag);
% figure,imshow((transTemp_backGd_Img));
NormImag = NormalizeImage(origImg, transTemp_backGd_Img);
return;
end