% tv_img_interp.m
% Total variation image interpolation.
% Defines m, n, Uorig, Known.
% Load original image.
pwd()
Uorig = double(imread('/home/carl/CUBoulder/coursework/5254/HW5/tv_img_interp.png'));
[m, n] = size(Uorig);
% Create 50% mask of known pixels.
rand('state', 1029);
Known = rand(m,n) > 0.5;
%%%%% Put your solution code here
% Calculate and define Ul2 and Utv.
% Placeholder:
cvx_begin
variable Ul2(m, n);
Ul2(Known) == Uorig(Known);
Ux = Ul2(2:end,2:end) - Ul2(2:end,1:end-1);
Uy = Ul2(2:end,2:end) - Ul2(1:end-1,2:end);
% Squared / l2 norm
minimize(norm([Ux(:); Uy(:)], 2)); 
cvx_end
cvx_begin
variable Utv(m, n);
Utv(Known) == Uorig(Known);
Ux = Utv(2:end,2:end) - Utv(2:end,1:end-1);
Uy = Utv(2:end,2:end) - Utv(1:end-1,2:end);
% abs or l1 norm
minimize(norm([Ux(:); Uy(:)], 1)); % tv roughness measure
cvx_end
%%%%%
% Graph everything.
figure(1); cla;
colormap gray;
subplot(221);
imagesc(Uorig)
title('Original image');
axis image;
subplot(222);
imagesc(Known.*Uorig + 256-150*Known);
title('Obscured image');
axis image;
subplot(223);
imagesc(Ul2);
title('l_2 reconstructed image');
axis image;
subplot(224);
imagesc(Utv);
title('Total variation reconstructed image');
axis image;