%% Rutas de imagenes
clc;
images_path = "./images/";
image_names = dir(strcat(images_path, "*png"));

%% Funcionamiento con muestra de imagenes
%{
method = "analytic";
window_size = [3,3];
stride = 25;

for i = 1:length(image_names)-1
    image_name = image_names(i);
    img_t = imread2gray(strcat(images_path, image_name.name));
    
    image_name = image_names(i+1);
    img_tplus1 = imread2gray(strcat(images_path, image_name.name));

    [X, Y, u, v] = optical_flow_lk(window_size, img_t, img_tplus1, stride, method);
    
    figure(1);
    imagesc(img_tplus1);
    colormap(gray)
    hold on;
    quiver(X,Y,u,v,'y');
    hold off;
    pause(0.001);
end

Analytic, (3,3)
Elapsed time is 23.267106 seconds.
Analytic, (5,5)
Elapsed time is 25.333196 seconds.
Analytic, (10,10)
Elapsed time is 29.254811 seconds.
matrix, (3,3)
Elapsed time is 192.082964 seconds.
matrix, (5,5)
Elapsed time is 195.086775 seconds.
matrix, (10,10)
Elapsed time is 348.101151 seconds.

%}
%% Test de rendimiento metodo lk analitico, ventana (3,3), 20 imagenes
method = "analytic";
window_size = [3,3];
stride = 25;

disp("Analytic, (3,3)")
tic
for i = 1:length(image_names)-1
    image_name = image_names(i);
    img_t = imread2gray(strcat(images_path, image_name.name));
    
    image_name = image_names(i+1);
    img_tplus1 = imread2gray(strcat(images_path, image_name.name));

    [X, Y, u, v] = optical_flow_lk(window_size, img_t, img_tplus1, stride, method);
end
toc

%% Test de rendimiento metodo lk analitico, ventana (5,5), 20 imagenes
window_size = [5,5];
stride = 25;

disp("Analytic, (5,5)")
tic
for i = 1:length(image_names)-1
    image_name = image_names(i);
    img_t = imread2gray(strcat(images_path, image_name.name));
    
    image_name = image_names(i+1);
    img_tplus1 = imread2gray(strcat(images_path, image_name.name));

    [X, Y, u, v] = optical_flow_lk(window_size, img_t, img_tplus1, stride, method);
end
toc

%% Test de rendimiento metodo lk analitico, ventana (5,5), 20 imagenes
window_size = [10,10];
stride = 25;

disp("Analytic, (10,10)")
tic
for i = 1:length(image_names)-1
    image_name = image_names(i);
    img_t = imread2gray(strcat(images_path, image_name.name));
    
    image_name = image_names(i+1);
    img_tplus1 = imread2gray(strcat(images_path, image_name.name));

    [X, Y, u, v] = optical_flow_lk(window_size, img_t, img_tplus1, stride, method);
end
toc

%% Test de rendimiento metodo lk analitico, ventana (3,3), 20 imagenes
method = "matrix";
window_size = [3,3];
stride = 25;

disp("matrix, (3,3)")
tic
for i = 1:length(image_names)-1
    image_name = image_names(i);
    img_t = imread2gray(strcat(images_path, image_name.name));
    
    image_name = image_names(i+1);
    img_tplus1 = imread2gray(strcat(images_path, image_name.name));

    [X, Y, u, v] = optical_flow_lk(window_size, img_t, img_tplus1, stride, method);
end
toc

%% Test de rendimiento metodo lk analitico, ventana (5,5), 20 imagenes
window_size = [5,5];
stride = 25;

disp("matrix, (5,5)")
tic
for i = 1:length(image_names)-1
    image_name = image_names(i);
    img_t = imread2gray(strcat(images_path, image_name.name));
    
    image_name = image_names(i+1);
    img_tplus1 = imread2gray(strcat(images_path, image_name.name));

    [X, Y, u, v] = optical_flow_lk(window_size, img_t, img_tplus1, stride, method);
end
toc

%% Test de rendimiento metodo lk analitico, ventana (5,5), 20 imagenes
window_size = [10,10];
stride = 25;

disp("matrix, (10,10)")
tic
for i = 1:length(image_names)-1
    image_name = image_names(i);
    img_t = imread2gray(strcat(images_path, image_name.name));
    
    image_name = image_names(i+1);
    img_tplus1 = imread2gray(strcat(images_path, image_name.name));

    [X, Y, u, v] = optical_flow_lk(window_size, img_t, img_tplus1, stride, method);
end
toc