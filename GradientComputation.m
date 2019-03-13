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



function [Grad_Complete_Img_New, thetaGradImage] = GradientComputation(imag)
G_x = [-3, 0, 3; -10, 0, 10; -3, 0, 3];
G_y = [-3, -10, -3; 0, 0, 0; 3, 10, 3];

Grad_X_Imag = conv2(imag, G_x);
Grad_X_Imag = Grad_X_Imag(2:end-1, 2:end-1);
Grad_Y_Imag = conv2(imag, G_y);
Grad_Y_Imag = Grad_Y_Imag(2:end-1,2:end-1);
% cPercent = 0.4;
Grad_Complete_Img = (abs(Grad_X_Imag) + abs(Grad_Y_Imag));


% here we have used uint8 that's why I have not used the factor c
min1 = min(min(Grad_Complete_Img));
max1 = max(max(Grad_Complete_Img));

% Normalize the image
Grad_Complete_Img_New = uint8(255 .* ((double(Grad_Complete_Img)-...
                                    double(min1))) ./ double(max1-min1));
                                
thetaGradImage = CalculateAngleFromGradient(Grad_X_Imag, Grad_Y_Imag);                            
return;
end

function thetaImage = CalculateAngleFromGradient(Grad_X_Imag, Grad_Y_Imag)
                                
thetaImage = atan2d(Grad_Y_Imag, Grad_X_Imag);
thetaImage = thetaImage + (thetaImage < 0)*360;  % turning it into 0-360 deg 
% angleInDegrees = rad2deg(thetaImage);
return
end