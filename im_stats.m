function image_stats = im_stats(bin_img,reg_img)

image_stats = struct;

[Phi1, Phi2, Phi3, Phi4] = inv_moments(bin_img);
image_stats.Phi1 = Phi1;
image_stats.Phi2 = Phi2;
image_stats.Phi3 = Phi3;
image_stats.Phi4 = Phi4;
%% Not Inv moments
[rows, cols] = find(bin_img);
image_stats.mean = mean(mean(reg_img(rows,cols)));
image_stats.std = std(std(double(reg_img(rows,cols))));
image_stats.max = max(max(reg_img(rows,cols)));
image_stats.min = min(min(reg_img(rows,cols)));