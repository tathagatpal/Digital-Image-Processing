image = imread('x5.bmp');
img_size = size(image);

row = img_size(1);
col = img_size(2);

image_padded = padarray(image, [4*row 4*col]);

origin_X = 4*row + 1;
origin_Y = 4*col + 1;


%Rotation matrix
deg = 45;
rotation = [cosd(deg) sind(deg) 0; -sind(deg) cosd(deg) 0; 0 0 1 ];

%Scaling matrix
sx = 2; sy = 2;
scale = [sx 0 0; 0 sy 0; 0 0 1];

%Translational matrix 
tx = 30; ty = 30;
translate = [1 0 0; 0 1 0; tx ty 1];

%Transformation matrix
transform = rotation*scale*translate
transform_inv = inv(transform);

%Output grid
op_size = size(image_padded);
op_img = zeros(op_size(1), op_size(2)) - 1;

for i = 0:op_size(1)-1
    for j = 0:op_size(2)-1
        
        if op_img(i+1,j+1) == -1
            
        i = i - origin_X;
        j = j - origin_Y;
        
        %Mapping the output to input image pixels
        trans_matrix = [i j 1]*(transform_inv);
        
        i = i + origin_X;
        j = j+ origin_Y;
        
        %4 nearest neighbours corresponding to input matrix
        trans_matrix(1) = trans_matrix(1) + origin_X;
        x = trans_matrix(1);
        trans_matrix(2) = trans_matrix(2) + origin_Y;
        y = trans_matrix(2);
        
        %If the pixel does not exist in the input image,  
        %move to the next pixel
        if x<origin_X || y<origin_Y || x>=origin_X+col || y>=origin_Y+row
                    continue
        end
        
        %If the pixel exists in the input image,  
        %perform bilinear interpolation for that given pixel value
        if ceil(x)~=x && ceil(x)<origin_X+col
                x1=floor(x);
                x2=ceil(x);
                    
        else
                if x==0
                    x1=0;
                    x2=1;
                else
                    x1=x-1;
                    x2=x;
                end
        end
                
        if ceil(y)~=y && ceil(y)<origin_Y+row
                y1=floor(y);
                y2=ceil(y);
                    
        else
                if y==0
                    y1=0;
                    y2=1;
                else
                    y1=y-1;
                    y2=y;
                end
        end    
               
            x1 = double(round(x1));
            x2 = double(round(x2));
            y1 = double(round(y1));
            y2 = double(round(y2));
            
        if x1<origin_X || x2<origin_X || y1<origin_Y || y2<origin_Y || x1>=origin_X+col || x2>=origin_X+col || y1>=origin_Y+row || y2>=origin_Y+row
                    continue    
        end
            
        X_i = [x1, y1, x1*y1, 1; x1, y2, x1*y2, 1;...
                x2, y2, x2*y2, 1; x2, y1, x2*y1, 1];
            
        Y_i = [[double(image_padded(x1+1,y1+1))]; [double(image_padded(x1+1,y2+1))]; ...
                [double(image_padded(x2+1,y2+1))]; [double(image_padded(x2+1,y1+1))]];
            
        X_id = double(X_i);
        Y_id = double(Y_i);
        A = (inv(X_i)*Y_i);
            
        op_img(i+1,j+1) = [x,y,x*y,1]*A;
            
        end
    end
end

%Registration

%3 corner values pixels of reference and the image obtained in previous part
%and obtaining the matrices O and I
O = [161 191 1; 26 36 1; 347 72 1];
I = [1014 1552 1; 1040 1140 1; 1443 1644 1]; 

figure(1);
imshow(image_padded);
title("Reference image (added)");

%calculating T (X = VT)
T = inv(O)*I
T_inv = inv(T);

registered_o = zeros(op_size(1), op_size(2)) - 1;

for i = 0:op_size(1)-1
    for j = 0:op_size(2)-1
                   
        i = i - origin_X;
        j = j - origin_Y;
        
        reg_O = [i j 1]*T;  %Inverse mapping
        
        x = reg_O(1) + origin_X/4;
        y = reg_O(2) + origin_Y/4;
        i=i+origin_X;
        j=j+origin_Y;
        
        if x<=0 || y<=0 || x>op_size(1)-1 || y>op_size(1)-1
                    continue
        end
        
        %Bilinear interpolation
        
        if ceil(x)~=x && ceil(x)<origin_X+col
                x1=floor(x);
                x2=ceil(x);
                    
        else
                if x==0
                    x1=0;
                    x2=1;
                else
                    x1=x-1;
                    x2=x;
                end
        end
                
        if ceil(y)~=y && ceil(y)<origin_Y+row
                y1=floor(y);
                y2=ceil(y);
                    
        else
                if y==0
                    y1=0;
                    y2=1;
                else
                    y1=y-1;
                    y2=y;
                end
        end    
               
            x1 = double(round(x1));
            x2 = double(round(x2));
            y1 = double(round(y1));
            y2 = double(round(y2));
    
        X_i = [x1, y1, x1*y1, 1; x1, y2, x1*y2, 1;...
                x2, y2, x2*y2, 1; x2, y1, x2*y1, 1];  
        Y_i = [[double(op_img(x1+1,y1+1))]; [double(op_img(x1+1,y2+1))]; ...
                [double(op_img(x2+1,y2+1))]; [double(op_img(x2+1,y1+1))]];
            
        X_id = double(X_i);
        Y_id = double(Y_i);
        A = (inv(X_i)*Y_i);
            
        registered_o(i+1,j+1) = [x,y,x*y,1]*A;
            
    end
end

figure(6);
imshow(registered_o, [0, 255]);
title('Registered Image');
