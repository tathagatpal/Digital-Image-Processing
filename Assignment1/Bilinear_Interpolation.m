%Input
image_in = imread('x5.bmp');
c = 2/4
img_size = size(image);


%Zero-padding
image = padarray(image_in, [1 1]);

row = img_size(1);
col = img_size(2);

row_n = row*c;
col_n = col*c;

figure(1);
imshow(image_in, [0, 255]);
title('Original image');

%Output grid
img_new = zeros(row_n, col_n)-1;

for i=0:row-1
    for j=0:col-1
        img_new(double(round(i*c+1)),double(round(j*c+1)))=image(i+1,j+1);
    end
end

yo=i*c;
yo1=j*c;
     
%Bilinear Interpolation
for i = 0:yo-1
    for j = 0:yo1-1
        if img_new(i+1,j+1) == -1
            x = (i)/c;
            y = (j)/c;
            
            if ceil(x)~=x
                x1 = floor(x);
                x2 = ceil(x);
            else
                if x == 0
                    x1 = 0;
                    x2 = 1;
                else
                    x1 = x-1;
                    x2 = x;
                end
            end
            
            if ceil(y)~=y
                y1 = floor(y);
                y2 = ceil(y);
            else
                if y == 0
                    y1 = 0;
                    y2 = 1;
                else
                    y1 = y-1;
                    y2 = y;
                end
            end
            
 x1 = double(round(x1));
            x2 = double(round(x2));
            y1 = double(round(y1));
            y2 = double(round(y2));
            
            %Bilinear Equation
            
            X_i = [x1, y1, x1*y1, 1; x1, y2, x1*y2, 1;...
                x2, y2, x2*y2, 1; x2, y1, x2*y1, 1];
            
            Y_i = [[double(image(x1+1,y1+1))]; [double(image(x1+1,y2+1))]; ...
                [double(image(x2+1,y2+1))]; [double(image(x2+1,y1+1))]];
            
            X_id = double(X_i);
            Y_id = double(Y_i);
            A = (inv(X_i)*Y_i);
            
            img_new(i+1,j+1) = [x,y,x*y,1]*A; %V = XA

        end
    end
end

figure(2);
% img_new = img_new(c:end-c-1, c:end-c-1);
imshow(img_new, [0, 255]);
title('Interpolated image');
