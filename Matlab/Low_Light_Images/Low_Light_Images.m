
close all;
clear all;
clc;

% Read the Original Image
I=imread('wild.jpg');

% Resize the image to 512 x 512 
IA = imresize(I, [512 512]);
size(I)
size(IA)

% Plot the Original Clear Image
subplot(3,3,1)
imshow(IA);
title('Original Image');

%Create the black image
IB=zeros(512,512,3,'uint8');

% Low Light Alpha Compositing Method
IC9 = 0.9 * IA + (1 - 0.9) * IB;
IC8 = 0.8 * IA + (1 - 0.8) * IB;
IC7 = 0.7 * IA + (1 - 0.7) * IB;
IC6 = 0.6 * IA + (1 - 0.6) * IB;
IC5 = 0.5 * IA + (1 - 0.5) * IB;
IC4 = 0.4 * IA + (1 - 0.4) * IB;
IC3 = 0.3 * IA + (1 - 0.3) * IB;
IC2 = 0.2 * IA + (1 - 0.2) * IB;

% Plot the Low light Images
subplot(3,3,2)
imshow(IC9);
title('90% visibility');

subplot(3,3,3)
imshow(IC8);
title('80% visibility');

subplot(3,3,4)
imshow(IC7);
title('70% visibility');

subplot(3,3,5)
imshow(IC6);
title('60% visibility');

subplot(3,3,6)
imshow(IC5);
title('50% visibility');

subplot(3,3,7)
imshow(IC4);
title('40% visibility');

subplot(3,3,8)
imshow(IC3);
title('30% visibility');

subplot(3,3,9)
imshow(IC2);
title('20% visibility');

