function [ OutImage ] = GrowAroundBlobs( blob, edge, Local, Thres )
%
% OutImage = GrowAroundBlobs( blob, edge, Local, Thres )
%

% Set up templates 
template = ones( 5,5 );
template2 = ones( 3, 3);
template2([1 1 3 3],[1 3 1 3]) = 0; % remove corner pixels.
% clean gaps in edge image.
edge = imerode( imdilate( edge, template ), template );
% threshold to 1 or 0.
blob( blob > 0 ) = 1;
% make smaller to start closer to centroid.
blob = imerode( blob, ones( 7, 7 ) );
subplot( 221 ), imagesc( blob );  % Demonstration display
I = 0;
while ~isempty(I) % if no new pixels found
    % search for edge of blob.
    TestImage = imdilate( blob, template2 ) - blob;
    % but knock out edge pixels.
    TestImage(edge > 0) = 0;
    % what pixels are left?
    I = find( TestImage > 0 );
    % throw out pixels less than thres
%    TestImage( TestImage > 0 && Local < Thres ) = 0;
    for m = 1:length(I)
        if( Local(I(m)) < Thres )
            TestImage(I(m)) = 0; 
        end
    end
    % grow blob and threshold.
    blob = blob+TestImage;
    blob( blob > 0 ) = 1;
    
    subplot(223), imagesc(edge);     % Demonstration display
    subplot(224), imagesc(blob);     % Demonstration display
    subplot(222), imagesc(edge+blob);% Demonstration display
    pause(0.1); % allow windows to paint display.
    
    % did blob grow. 
    I = find( TestImage > 0 ); 
end


OutImage = Local;
OutImage( blob == 0 ) = 0;

end