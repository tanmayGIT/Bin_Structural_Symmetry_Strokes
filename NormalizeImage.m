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
 



% The algo is taken from the following paper 

% Jia, F., Shi, C., He, K., Wang, C., & Xiao, B. (2018). Degraded document 
% image binarization using structural symmetry of strokes. Pattern Recognition, 
% 74, 225–240.

% Date of Implementation : 06/01/2019


function [I_norm] = NormalizeImage(origImg, backGdImag)
I_norm = zeros(size(origImg, 1), size(origImg,2));

for rw = 1:1:size(origImg,1)
    for col = 1:1:size(origImg,2)
        if ((origImg(rw,col) < backGdImag(rw,col)) && (backGdImag(rw,col) > 0) )
            valNume = origImg(rw,col);
            valDeno = backGdImag(rw,col);
            valTot = 255 * ( double(valNume) / double(valDeno)  );
            I_norm(rw,col) = valTot;
        else
            I_norm(rw,col) = 255;
        end
    end
end
I_norm = uint8(I_norm);
return;
end