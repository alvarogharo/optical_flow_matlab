function [X, Y, u, v] = optical_flow_lk(window_size, img_t, img_tplus1, stride, method)
    analytic = "analytic";
    matrix = "matrix";
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
                    sum_dxdx = sum(win_dxdx, 'all');
                    
                    win_dydy = win_dy.*win_dy;
                    sum_dydy = sum(win_dydy, 'all');
                    
                    win_dxdt = win_dx.*win_dt;
                    sum_dxdt = sum(win_dxdt, 'all');
                    
                    win_dxdy = win_dx.*win_dy;
                    sum_dxdy = sum(win_dxdy, 'all');
                    
                    win_dydt = win_dy.*win_dt;
                    sum_dydt = sum(win_dydt, 'all');
                    
                    u_aux(i,j) = -(-sum_dydy * sum_dxdt + sum_dxdy * sum_dydt) / (sum_dxdx * sum_dydy - sum_dxdy * sum_dxdy);
                    v_aux(i,j) = -(sum_dxdy * sum_dxdt - sum_dxdx * sum_dydt) / (sum_dxdx * sum_dydy - sum_dxdy * sum_dxdy);
                end
            end
        end
    else
        disp("ERROR: Method no supported try 'matrix' or 'analityc'")
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
