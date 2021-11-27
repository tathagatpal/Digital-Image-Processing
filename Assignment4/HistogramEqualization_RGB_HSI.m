image = imread('rgb.tif');

I = double(image)/255;

R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

%Hue
numerator = 1/2*((R-G)+(R-B));
denominator = ((R-G).^2+((R-B).*(G-B))).^0.5;

H = acosd(numerator./(denominator+10E-8));

% B > G => H = 360-Theta
H(B > G) = 360-H(B > G);

%Normalizing H to [0 1]
H = H/360;

%Saturation
S = 1-(3./(sum(I,3)+10E-8)).*min(I,[],3);

%Intensity
I=sum(I,3)./3;

%HSI
HSI=zeros(size(image));
HSI(:,:,1) = H;
HSI(:,:,2) = S;
HSI(:,:,3) = I;

img_size = size(HSI);

%Equalization______________________________________________________________

I = uint8(I * 255);

pix_freq = zeros(1, length(255));
pix_vals = 0:1:255;

for i = 0:255
    pix_freq(i+1) = nnz(I == i);
end

sum_freq = sum(pix_freq);
pdf = double(pix_freq/sum_freq);

cdf = zeros(1, length(pix_vals));
cdf(1) = pdf(1);

for i = 2:length(pix_vals)
    cdf(i) = double((pdf(i) + cdf(i-1)));
end

cdf_new = round(cdf*255);

I_equalized = zeros(img_size(1), img_size(2));

for i = 0:length(I)-1
    for j = 0:length(I_equalized)-1
        I_equalized(i+1, j+1) = cdf_new(I(i+1, j+1)+1);
    end
end

pix_freq_op = zeros(1, length(256));
pix_vals = 0:1:255;

for j = 0:255
    pix_freq_op(j+1) = nnz(I_equalized == j);
end


%Back to RGB_______________________________________________________________
HSI_equalized = zeros(size(image));

H_eq=HSI(:,:,1);  
S_eq=HSI(:,:,2);  
I_eq = I_equalized;
 
%H * 360 => range of H [0 360]  
H_eq=H_eq*360;                                               

R_eq=zeros(size(H_eq));  
G_eq=zeros(size(H_eq));  
B_eq=zeros(size(H_eq));  
RGB_eq=zeros([size(H_eq),3]);  
    

%R-G(0<=H<120)  
R_eq(H_eq < 120 )= I_eq(H_eq < 120).*(1+((S_eq(H_eq < 120)...
    .*cosd(H_eq(H_eq < 120)))./cosd(60-H_eq(H_eq < 120))));  
G_eq(H_eq < 120) = 3.*I_eq(H_eq < 120)-(R_eq(H_eq < 120)+B_eq(H_eq < 120)); 
B_eq(H_eq < 120) = I_eq(H_eq < 120).*(1-S_eq(H_eq < 120));  

%G-B(120<=H<240)  
H2=H_eq-120;  
R_eq(H_eq >= 120 & H_eq < 240) = I_eq(H_eq >= 120 & H_eq < 240)...
    .*(1-S_eq(H_eq >= 120 & H_eq < 240));  
G_eq(H_eq >= 120 & H_eq <240) = I_eq(H_eq >= 120 & H_eq < 240)...
    .*(1+((S_eq(H_eq >= 120 & H_eq < 240).*cosd(H2(H_eq >= 120 & H_eq < 240)))...
    ./cosd(60-H2(H_eq >= 120 & H_eq < 240))));  
B_eq(H_eq >= 120 & H_eq < 240) = 3.*I_eq(H_eq >= 120 & H_eq < 240)...
    -(R_eq(H_eq >= 120 & H_eq < 240) + G_eq(H_eq >= 120 & H_eq < 240));  


    
%B-R (240<=H<=360)  
H2 = H_eq - 240;  
R_eq(H_eq >= 240 & H_eq <= 360) = 3.*I_eq(H_eq >= 240 & H_eq <= 360)-(G_eq(H_eq >= 240 & H_eq <= 360)...
     +B_eq(H_eq >= 240 & H_eq <= 360));  
G_eq(H_eq >= 240 & H_eq <= 360) = I_eq(H_eq >= 240 & H_eq <=360).*(1-S_eq(H_eq >= 240 & H_eq <= 360));  
B_eq(H_eq >= 240 & H_eq <= 360) = I_eq(H_eq >=240 & H_eq <=360).*(1+((S_eq(H_eq >= 240 &H_eq <=360)...
     .*cosd(H2(H_eq >= 240 & H_eq <= 360)))./cosd(60 - H2(H_eq >= 240 & H_eq <= 360))));  
 
%Reconstruct RGB Image  
RGB_eq(:,:,1)=R_eq;  
RGB_eq(:,:,2)=G_eq;  
RGB_eq(:,:,3)=B_eq;  

RGB_eq=im2uint8(RGB_eq/255);  
 
figure(1);
subplot(2,2,1);
imshow(image,[0 255]);
hold on;
axis on;
title('Original Image');
 
figure(1);
subplot(2,2,2);
bar(pix_vals, pix_freq/(img_size(1)*img_size(2)));
hold on;
title('Historgram (original)');
xlabel('Pixel Value');
ylabel('PDF');


figure(1);
subplot(2,2,3);
imshow(RGB_eq,[0 255]);
hold on;
axis on;
title('Equalized image');


figure(1);
subplot(2,2,4);
bar(pix_vals, pix_freq_op/(img_size(1)*img_size(2)));
hold on;
title('Historgram (equalized)');
xlabel('Pixel Value');
ylabel('PDF');
