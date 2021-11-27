image = imread('input_image.jpg');
    [m, n] = size(image);
    subplot(2,4,1)
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

    subplot(2,4,2)
    imshow(padded_img,[]);
    hold on;
    title('zero-padded input image');
    axis on;

    %FFT of non-centered padded image
    image_freq = fft2(padded_img);
    mag_img = log(1+abs(image_freq));

    subplot(2,4,3);
    imshow(mag_img,[]);
    hold on;
    title('magnitude spectrum of zero-padded input image');


    %Centering
    for i = 1:2*m
        for j = 1:2*n
            padded_img(i,j) = padded_img(i,j)*(-1)^(i+j);
        end
    end

    %FFT of centered padded image
    image_freq = fft2(padded_img);
    mag_img = log(1+abs(image_freq));

    subplot(2,4,4);
    imshow(mag_img,[]);
    hold on;
    title('centered magnitude spectrum of zero-padded input image');


    %Filter for cut-off frequency of 10
    D0_1 = 10;

    for i = 1:2*m
        for j = 1:2*n
            D = ((i-m)^2+ (j-n)^2)^1/2;
            H_1(i,j) = 1/(1 + (D/D0_1)^4);
        end
    end

    img_filtered1 = image_freq.*H_1;

    subplot(2,4,5);
    imshow(H_1, []);
    hold on;
    title("Centered mag spectrum, D0 = " + D0_1);

    img_back_1 = real(ifft2(img_filtered1));

    for i = 1:2*m
        for j = 1:2*n
            img_back_1(i,j) = img_back_1(i,j)*(-1)^(i+j);
        end
    end


    %Filter for cut-off frequency of 30
    D0_2 = 30;

    for i = 1:2*m
        for j = 1:2*n
            D = ((i-m)^2+ (j-n)^2)^1/2;
            H_2(i,j) = 1/(1 + (D/D0_2)^4);
        end
    end

    img_filtered2 = image_freq.*H_2;
    img_back_2 = real(ifft2(img_filtered2));
    
    subplot(2,4,6);
    imshow(H_2, []);
    hold on;
    title("Spectrum of filter, D0 = " + D0_2);

    for i = 1:2*m
        for j = 1:2*n
            img_back_2(i,j) = img_back_2(i,j)*(-1)^(i+j);
        end
    end


    %Filter for cut-off frequency of 60
    D0_3 = 60;

    for i = 1:2*m
        for j = 1:2*n
            D = ((i-m)^2+ (j-n)^2)^1/2;
            H_3(i,j) = 1/(1 + (D/D0_3)^4);
        end
    end

    img_filtered3 = image_freq.*H_3;
    img_back_3 = real(ifft2(img_filtered3));
    
    subplot(2,4,7);
    imshow(H_3, []);
    hold on;
    title("Spectrum of filter, D0 = " + D0_3);

    for i = 1:2*m
        for j = 1:2*n
            img_back_3(i,j) = img_back_3(i,j)*(-1)^(i+j);
        end
    end

    %Plotting o/p images
    figure();
    subplot(1,3,1);
    imshow(img_back_1(1:m,1:n),[]);
    hold on;
    title("cropped output image for D0 = " + D0_1);

    subplot(1,3,2);
    imshow(img_back_2(1:m,1:n),[]);
    title("output image for D0 = " + D0_2);

    subplot(1,3,3);
    imshow(img_back_3(1:m,1:n),[]);
    title("output image for D0 = " + D0_3);
