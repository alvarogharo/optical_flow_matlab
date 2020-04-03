function [X, Y, u, v] = optical_flow(window_size, img_t, img_tplus1, stride, method, alpha, max_iter)
    analytic = "analytic";
    matrix = "matrix";
    hs = "hs";
    
    [img_t_dx, img_t_dy] = gradient(img_t);
    [img_tplus1_dx, img_tplus1_dy] = gradient(img_tplus1);

    dx = img_t_dx + img_tplus1_dx;
    dy = img_t_dy + img_tplus1_dy;

    dt = imgaussfilt(img_t) - imgaussfilt(img_tplus1);

    center_h = round(window_size(1)/2);
    center_w = round(window_size(2)/2);

    img_size = size(img_t);

    u_aux = zeros(size(img_t));
    v_aux = zeros(size(img_tplus1));
    
    if method == matrix || method == analytic
        for i = center_h +1:img_size(1)-center_h
            for j = center_w+1:img_size(2)-center_w
                win_dx = cropimage(dx, j, i, center_w, center_h);
                win_dy = cropimage(dy, j, i, center_w, center_h);
                win_dt = cropimage(dt, j, i, center_w, center_h);

                if method == matrix
                    sum_dx = win_dx(:);
                    sum_dy = win_dy(:);
                    sum_dt = win_dt(:);
                    
                    sum_derivative_mat = [sum_dx sum_dy];
                    uv = pinv(sum_derivative_mat)*sum_dt;

                    u_aux(i,j) = uv(1);
                    v_aux(i,j) = uv(2);
                elseif method == analytic
                    win_dxdx = win_dx.*win_dx;
                    sum_dxdx = sum(sum(win_dxdx));
                    
                    win_dydy = win_dy.*win_dy;
                    sum_dydy = sum(sum(win_dydy));
                    
                    win_dxdt = win_dx.*win_dt;
                    sum_dxdt = sum(sum(win_dxdt));
                    
                    win_dxdy = win_dx.*win_dy;
                    sum_dxdy = sum(sum(win_dxdy));
                    
                    win_dydt = win_dy.*win_dt;
                    sum_dydt = sum(sum(win_dydt));
                    
                    u_aux(i,j) = -(-sum_dydy * sum_dxdt + sum_dxdy * sum_dydt) / (sum_dxdx * sum_dydy - sum_dxdy * sum_dxdy);
                    v_aux(i,j) = -(sum_dxdy * sum_dxdt - sum_dxdx * sum_dydt) / (sum_dxdx * sum_dydy - sum_dxdy * sum_dxdy);
                end
            end
        end
    elseif method == hs
        mask = ones(window_size(1));
        mask = mask * 1/9;
        for i = 1:max_iter
            u_aux = conv2(u_aux, mask, 'same');
            v_aux = conv2(v_aux, mask, 'same');

            u_aux =  u_aux - ( dx .* ((dx .* u_aux) + (dy .* v_aux) + dt )) ./ ( alpha.^2 + dx.^2 + dy.^2);
            v_aux =  v_aux - ( dy .* ((dx .* u_aux) + (dy .* v_aux) + dt )) ./ ( alpha.^2 + dx.^2 + dy.^2);
        end
        u_aux = -u_aux;
        v_aux = -v_aux;
    else
        disp("ERROR: Method no supported try 'matrix' or 'analdtyc'")
    end
    [X,Y] = meshgrid(1:img_size(2), 1:img_size(1));
    X = stride2dmatrix(X, stride);
    Y = stride2dmatrix(Y, stride);

    u = stride2dmatrix(u_aux, stride);
    v = stride2dmatrix(v_aux, stride);
end

function image = cropimage(image, x, y, width, height)
     image = image(y-height:y+height, x-width:x+width);
end

function mat = stride2dmatrix(mat, stride)
     mat = mat(1:stride:end,1:stride:end);
end
