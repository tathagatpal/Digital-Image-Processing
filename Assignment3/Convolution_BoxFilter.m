image = imread('input_image.jpg');
    [m, n] = size(image);

    subplot(2,2,1)
    imshow(image,[]);
    hold on;
    title('input image');

    %Padding input image
    padded_img = zeros(m+9-1,n+9-1);
    for i = 1:m
        for j = 1:n
            padded_img(i,j) = image(i,j);  
        end
    end

    subplot(2,2,2)
    imshow(padded_img,[]);
    hold on;
    title('zero-padded input image');

    %FFT of padded image
    image_freq = fft2(padded_img);

    H = 1/81 * ones(9,9);
    padded_filter = zeros(m+9-1, n+9-1);


    %Padding filter
    for i = 1:9
        for j = 1:9

            padded_filter(i,j) = H(i,j);

        end
    end

    H_freq = fft2(padded_filter);

    op_img = image_freq.*H_freq;
    op_img = real(ifft2(op_img));

    subplot(2,2,3);
    imshow(op_img(5:260, 5:260), []);
    hold on;
    title('Output image');

    %Verification using convolution
    conv_op = conv2(image, H);
    subplot(2,2,4);
    imshow(conv_op(5:260, 5:260),[]);
    hold on;
    title('Convolution output');
