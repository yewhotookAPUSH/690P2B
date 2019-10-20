function image_stats = inv_moments(image)

[m,n] = size(image);
if m ~= n
    if m > n
        padImage = padarray(image, [2/2, (m-n+2)/2]);
    else
        padImage = padarray(image, [(n-m+2)/2, 2/2]);
    end
else
    padImage = image;
end
image = padImage;
[m, n] = size(padImage);

Dx = [];Dy = [];
Dx = uint8(repmat(1:n, m ,1));
Dy = uint8(repmat((1:n)',1,m));

m00 = sum(sum(image));
m10 = sum(sum(Dx.*image));
m01 = sum(sum(Dy.*image));
m20 = sum(sum((Dx.^2).*image));
m02 = sum(sum((Dy.^2).*image));
m22 = sum(sum((Dy.^2).*(Dx.^2).*image));
m03 = sum(sum((Dy.^3).*image));
m30 = sum(sum((Dx.^3).*image));
m11 = sum(sum(Dx.*Dy.*image));
m12 = sum(sum(Dx.*(Dy.^2).*image));
m21 = sum(sum((Dx.^2).*(Dy).*image));

x_bar = m10 / m00;
y_bar = m01 / m00;

mu30 = m30 - 3*x_bar*m20 + 2*m10*(x_bar^2);
mu12 = m12 - 2*y_bar*m11 - x_bar*m02+2*(y_bar^2)*m10;
mu21 = m21 - 2*x_bar*m11 - y_bar*m20+2*(x_bar^2)*m01;
mu03 = m03 - 3*y_bar*m02 + 2*(y_bar^2)*m01;

nu20 = sum(sum((Dx-x_bar).^2.*image))/(m00^2);
nu02 = sum(sum((Dy-y_bar).^2.*image))/(m00^2);
nu11 = sum(sum((Dy-y_bar).*(Dx-x_bar).*image))/(m00^2);
nu12 = mu12/(m00^((1+2)/2 + 1));
nu21 = mu21/(m00^((1+2)/2 + 1));
nu03 = mu03/(m00^((0+3)/2 + 1));
nu30 = mu30/(m00^((3+0)/2 + 1));

Phi1 = nu20 + nu02;
Phi2 = (nu20 - nu02)^2 + 4*nu11^2;
Phi3 = (nu30  - 3*nu12)^2 + (3*nu21-nu03)^2;
Phi4 = (nu30 + nu12)^2 + (nu21 + nu03)^2;


image_stats = struct;

image_stats.Phi1 = Phi1;
image_stats.Phi2 = Phi2;
image_stats.Phi3 = Phi3;
image_stats.Phi4 = Phi4;
%% Not Inv moments
image_stats.mean = mean(mean(image(find(image))));
image_stats.std = std(double(image(find(image))));
