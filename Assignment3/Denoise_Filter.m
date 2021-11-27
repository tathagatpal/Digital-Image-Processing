image = imread('noiseIm.jpg');
    [m, n] = size(image);
    subplot(2,3,1)
    imshow(image,[]);
    hold on;
    title('input image');
    axis on;

    %Padding
    padded_img = zeros(2*m,2*n);
    for i = 1:m
        for j = 1:n
            padded_img(i,j) = image(i,j);  
        end
    end

    subplot(2,3,2)
    imshow(padded_img,[]);
    hold on;
    title('zero-padded input image');
    axis on;

    %FFT of padded image
    image_freq = fft2(padded_img);
    mag_img = log(1+abs(image_freq));

    subplot(2,3,3);
    imshow(mag_img,[]);
    hold on;
    title('magnitude spectrum of zero-padded input image');


    %Butterworth Filter

    %Cutoff frequency
    D0 = 20;
    H = zeros(2*m,2*n);

    for i = 1:2*m
        for j = 1:2*n
            %(65,65) and (450,450)
            D1 = ((i-65)^2+ (j-65)^2)^1/2;
            D2 = ((i-450)^2+ (j-450)^2)^1/2;
            H_1(i,j) = 1/( 1 + (D1/D0)^4 );
            H_2(i,j) = 1/( 1 + (D2/D0)^4 );

            H(i,j) = H_1(i,j) + H_2(i,j) + H(i,j);
        end
    end

    H = 1-H;  %Rejection filter 

    subplot(2,3,4);
    imshow(H, []);
    hold on;
    title('Filter');

    img_filtered1 = image_freq.*H;
    img_back = real(ifft2(img_filtered1));


    subplot(2,3,5);
    imshow(img_back(1:256,1:256),[]);
    hold on;
    title('Denoised Image (output)');
    axis on;

    subplot(2,3,6);
    imshow('denoiseIm.jpg');
    hold on;
    title('Denoised Image (given)');
    axis on;
