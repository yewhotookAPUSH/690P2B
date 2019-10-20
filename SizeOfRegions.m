function [N_img,Count] = SizeOfRegions( Img, Lower, Upper )
% 
% [New_Img,Count] = SizeOfRegions( Img, Lower, Upper );
%
%   This function will look for connected sets of non-zero pixels
% in Img, and retain those who's size if between Lower and Upper 
% (in pixels).
%   The function returns an image (New_Img) retaining sets of the correct 
% size and the number (Count) of sets
%

[Labeled,N] = bwlabel( Img );
N_img = zeros( size( Img ) );
Count = 0;
for k = 1:N
    I = find( Labeled == k );
    if( length(I) < Upper && length(I) > Lower )
        Count = Count + 1;
        N_img(I) = Count;
    end
end

return
