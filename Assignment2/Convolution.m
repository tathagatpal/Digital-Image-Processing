% image = [1 1 1; 1 1 1; 1 1 1];
% filter = [1 2 3; 4 5 6; 7 8 9];
 
% image = [-1 2 -1; 3 0 1; -2 1 2];
% filter = [0 -1 0; 0 0 0; 0 1 0];

% image = [[94 47 17];[13 2 80]; [57 34 32]];
% filter = [[53 27 75];[17 66 46];[61 69 9]];

image = randi(255,3);
filter = randi(255,3);

filter_rot = rot90(rot90(filter));

size_image = size(image);
size_filter = size(filter_rot);
m = size_image(1); n = size_image(2);
p = size_filter(1); q = size_filter(2);


image_pad = padarray(image, [2 2]);
size_op = size(image_pad);

final_output = zeros(size_op(1), size_op(2));

for i = 1:size_op(1)-2
    for j = 1:size_op(2)-2
        final_output(i+1,j+1) = sum(sum(image_pad(i:i+2, j:j+2) .* filter_rot));
    end
end


final_output = final_output(2:6, 2:6)
% conv = conv2(image,filter)
    
