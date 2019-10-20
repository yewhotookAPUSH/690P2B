function Crossplot( Z1, Z2 )
% 
% Function to generate all possible crossplots of the 
% features in the data sets of Z1 and Z2.  
%
% The data sets (Z1, Z2) are assumed to have each column 
% represent a feature, thus the number of features is equal
% to the number of columns and must then be the same in
% Z1 and Z2.  The number of rows is the number of examples
% in each set, and can be different between the two.
%
%  X = genvec(S,M,n);
%

% Date:   January 14, 1994
% Author: Dwight D. Day

[m,n] = size( Z1 );
d = 1;

k = n-1;
w = n-1;
while k > 1
   k = k - 1;
   w = w + k;
end;

while d*d < w 
   d = d + 1;
end;

w = 1;
for k = 1:n-1
   for l = k+1:n
      subplot( d,d,w ), plot( Z1(:,k), Z1(:,l), '+', Z2(:,k), Z2(:,l), 'o' );
      xlabel( ['Feature ' num2str( k ) ] );
      ylabel( ['Feature ' num2str( l ) ] );
      w = w + 1;
   end;
end;
return;