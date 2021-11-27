image = imread('noiseIm.jpg');
[m, n] = size(image);

original_img = imread('input_image.jpg');
original_img = double(original_img);

figure(1);
subplot(2,3,1);
imshow(image,[]);
hold on;
title('Noisy Image');

H = 1/121 * ones(11,11);   %Box filter
[mh, nh] = size(H);
L = [0 1 0; 1 -4 1; 0 1 0];         %Laplacian filter

padded_img = zeros(m+mh-1,n+nh-1);
for i = 1:m
    for j = 1:n
        padded_img(i,j) = image(i,j);  
    end
end

padded_img = uint8(padded_img);

H_padded = zeros(m+mh-1, n+nh-1);
for i = 1:length(H)
    for j = 1:length(H)
        
        H_padded(i,j) = H(i,j);
        
    end
end


L_padded = zeros(m+mh-1, n+nh-1);
for i = 1:length(L)
    for j = 1:length(L)
        
        L_padded(i,j) = L(i,j);
        
    end
end

lambda = 0:0.25:1;

G = fft2(padded_img);
H_f = fft2(H_padded);
L_f = fft2(L_padded);

for i = 1:length(lambda)
       
filter = conj(H_f)./(abs(H_f).^2 + lambda(i)*abs(L_f).^2);

filter_freq = log(1+abs(filter));
figure(2);
subplot(2,3,i);
imshow(filter_freq,[]);
hold on;
title("λ = " + lambda(i));

F_hat = filter.*G;
F_hat = double(real(ifft2(F_hat)));


MSE = mean((F_hat(1:256,1:256)-original_img).^2, 'all');
PSNR = 10*log10((2^8-1)^2./(MSE));

figure(1);
subplot(2,3,i+1);
imshow(F_hat(1:m,1:n),[]);
hold on;
title("λ = " + lambda(i) + ", PSNR = " + PSNR);

figure(3);
imshow(F_hat(1:m,1:n),[]);
hold on;
title("λ = " + lambda(5) + ", PSNR = " + PSNR + " (Best restored image)");


end
