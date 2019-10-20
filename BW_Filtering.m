function [X_F,H] = BW_Filtering( X, Axis, Cutoff )
% 
% Simple cutoff filter of image FT X
% Axis = 1 for across rows, 2 across columns
% Cutoff is the normalized frequency cutoff (0 to 0.5)
%
% It should be noted that this assumes that the
% FFT has an even number of rows and an even number of columns.

% check for inputs
if nargin < 3 
    Cutoff = 0.25; % default  
end
if nargin < 2 
    Axis = 1; % default across rows
end

% Check size 
[n,m] = size(X);

X_F = X; % preallocation of output.

if Axis == 1  % filter is applied across the rows.
   H = zeros(1,m);
   k_cutoff = m*Cutoff;
   for k = 1:m/2+1
       k_norm = (k / k_cutoff)^2;
       H(k) = 1 / sqrt( ( 1 + k_norm ) ...
                      * ( ( 1 - k_norm^2 )^2 + k_norm ) );
   end
   H( (m/2+2):m ) = H(m/2:-1:2); % Conjugate Symmetry
   for k = 1:m
       X_F(:,k) = H(k)*X(:,k);
   end
else
   H = zeros(n,1);
   k_cutoff = n*Cutoff;
   for k = 1:n/2+1
       k_norm = (k / k_cutoff)^2;
       H(k) = 1 / sqrt( ( 1 + k_norm ) ...
                      * ( ( 1 - k_norm^2 )^2 + k_norm ) );
   end
   H( (n/2+2):n ) = H(n/2:-1:2); % Conjugate Symmetry
   for k = 1:n
       X_F(k,:) = H(k)*X(k,:);
   end
end

return
