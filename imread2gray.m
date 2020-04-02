function image = imread2gray(image_path)
    image = imread(image_path);
    image = rgb2gray(image);
    image = im2double(image);
end

