image = imread('input_image.jpg');
img_size = size(image);
figure(1);
subplot(2,2,1);
imshow(image);
hold on;
axis on;
title('Original Image');

pix_freq = zeros(1, length(255));
pix_vals = 0:1:255;

for i = 0:255
    pix_freq(i+1) = nnz(image == i);
end

figure(1);
subplot(2,2,2);
bar(pix_vals, pix_freq/(img_size(1)*img_size(2)));
hold on;
title('Historgram (original)');
xlabel('Pixel Value');
ylabel('PDF');

sum_freq = sum(pix_freq);
pdf = double(pix_freq/sum_freq);

cdf = zeros(1, length(pix_vals));
cdf(1) = pdf(1);

for i = 2:length(pix_vals)
    cdf(i) = double((pdf(i) + cdf(i-1)));
end

% figure(4);
% plot(pix_vals, cdf);
% hold on;
% title('CDF');

cdf_new = round(cdf*255);

img_out = zeros(img_size(1), img_size(2));

for i = 0:length(image)-1
    for j = 0:length(img_out)-1
        img_out(i+1, j+1) = cdf_new(image(i+1, j+1)+1);
    end
end

figure(1);
subplot(2,2,3);
imshow(img_out, [0 255]);
hold on;
axis on;
title('Equalized image');

pix_freq_op = zeros(1, length(256));
pix_vals = 0:1:255;

for j = 0:255
    pix_freq_op(j+1) = nnz(img_out == j);
end

figure(1);
subplot(2,2,4);
plot(pix_vals, pix_freq_op/(img_size(1)*img_size(2)));
hold on;
title('Historgram (equalized)');
xlabel('Pixel Value');
ylabel('PDF');
