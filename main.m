%% Rutas de imagenes
clc;
images_path = './images/';
image_names = dir(strcat(images_path, '*png'));

%% Funcionamiento con muestra de imagenes
% Modos de funcionamiento 
% LK matricial "matrix";
% LK analítico "analytic";
% Horn Shunck "hs";

% method = "matrix";
% method = "analytic";
method = "hs";
window_size = [3,3];
stride = 25;
alpha = 0.1;
max_iter = 100;

for i = 1:length(image_names)-1
    image_name = image_names(i);
    img_t = imread2gray(strcat(images_path, image_name.name));
    
    image_name = image_names(i+1);
    img_tplus1 = imread2gray(strcat(images_path, image_name.name));

    [X, Y, u, v] = optical_flow(window_size, img_t, img_tplus1, stride, method, alpha, max_iter);
    
    figure(1);
    imagesc(img_tplus1);
    colormap(gray)
    hold on;
    quiver(X,Y,u,v,'y');
    hold off;
    pause(0.001);
end