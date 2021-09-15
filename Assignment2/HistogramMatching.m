image = imread('input_image.jpg');
img_size = size(image);
figure(1);
subplot(2,2,1);
imshow(image);
hold on;
axis on;
title('Input image I');


%Gamma transformation (to find the target image)
dimage = double(image);

gamma = 0.5;
c = 255/(max(max(dimage)).^gamma); 
target_img = uint8(c*(dimage).^(gamma));
% target_img = 255 - image;
figure(1);
subplot(2,2,2);
imshow(target_img, [0 255]);
hold on;
axis on;
title('Target image T');

%Finding normalized histogram of input and target image
pix_freq_I = zeros(1, length(256));
pix_freq_T = zeros(1, length(256));
pix_vals = 0:1:255;

for i = 0:255
    pix_freq_I(i+1) = nnz(image == i);
    pix_freq_T(i+1) = nnz(target_img == i);
end

%Plotting I, T and their normalized histograms
figure(1);
subplot(2,2,3);
plot(pix_vals, pix_freq_I/(img_size(1)*img_size(2)));
hold on;
title('Historgram (I)');
xlabel('Pixel Value');
ylabel('PDF');

subplot(2,2,4);
plot(pix_vals, pix_freq_T/(img_size(1)*img_size(2)));
hold on;
title('Historgram (T)');
xlabel('Pixel Value');
ylabel('PDF');

pix_freqI = zeros(1, length(256));
pix_freqT = zeros(1, length(256));
pix_vals = 0:1:255;

for i = 0:255
    pix_freqI(i+1) = nnz(image == i);
    pix_freqT(i+1) = nnz(target_img == i);
end

sum_freqI = sum(pix_freqI);
sum_freqT = sum(pix_freqT);
pdf_I = double(pix_freqI/sum_freqI);
pdf_T = double(pix_freqT/sum_freqT);

cdf_I = zeros(1, length(pix_vals));
cdf_T = zeros(1, length(pix_vals));
cdf_I(1) = pdf_I(1);
cdf_T(1) = pdf_T(1);


for i = 2:length(pix_vals)
    cdf_I(i) = double((pdf_I(i) + cdf_I(i-1)));
    cdf_T(i) = double((pdf_T(i) + cdf_T(i-1)));
end


figure(2);
subplot(2,1,1);
plot(pix_vals, cdf_I);
hold on;
title('CDF (I)');
xlabel('Pixel Value');
ylabel('CDF');

subplot(2,1,2);
plot(pix_vals, cdf_T);
hold on;
title('CDF (T)');
xlabel('Pixel Value');
ylabel('CDF');

arg_min = zeros(1, length(256));
mapping = zeros(1, length(256));

for i = 1:256
    arg_min = abs(cdf_I(i)-cdf_T);
    index = find(min(arg_min)==arg_min);
    mapping(i)=(index(1));
end

img_match = zeros(length(img_size(1)),length(img_size(2)));
for i = 1:img_size(1)
    for j = 1:img_size(2)
        
    val=image(i,j);
    
    img_match(i,j) = mapping(val+1);
        
    end
end

figure(3);
subplot(2,2,1);
imshow(img_match, [0 255]);
hold on;
axis on;
title('Matched Image');

subplot(2,2,2);
imshow(target_img, [0 255]);
axis on;
title('Target Image');

pix_freq_match = zeros(1, length(256));
for i = 0:255
    pix_freq_match(i+1) = nnz(img_match == i);
end

figure(3);
subplot(2,2,3);
plot(pix_vals, pix_freq_match/(img_size(1)*img_size(2)));
hold on;
title('Histogram (matched)');
xlabel('Pixel Value');
ylabel('PDF');

subplot(2,2,4);
plot(pix_vals, pix_freq_T/(img_size(1)*img_size(2)));
hold on;
title('Historgram (T)');
xlabel('Pixel Value');
ylabel('PDF');
