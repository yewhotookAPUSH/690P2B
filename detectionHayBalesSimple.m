function [hay_stats,not_hay_stats] = detectionHayBalesSimple(file)

close all
IMG_0034 = imread(file);
%take the fft
IMG = fft2(IMG_0034);
e_IMG = edge( IMG_0034, 'canny' );

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FILTER IMAGE
% filtering of FT across rows.
FLT_IMG = BW_Filtering( IMG, 2, 1/50 );
% filtering of FT across columns.
FLT_IMG = BW_Filtering( FLT_IMG, 1, 1/50 );
FLT_IMG = HP_Filtering( FLT_IMG, 2, 1/250 );
FLT_IMG = HP_Filtering( FLT_IMG, 1, 1/250 );
flt_img = real( ifft2( FLT_IMG ) );
figure(1);
imagesc( flt_img ), colormap('gray');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SET THRESHOLDS
%0.7 * max + 0.3 * min
thresholdMax = max(max(flt_img));
thresholdMin = min(min(flt_img));
t_img = zeros(size(flt_img));
t_img(flt_img>(thresholdMax*0.7+thresholdMin*0.3)) = 1;
figure(2);
imagesc( t_img ), colormap('gray');

%% 

% create connnect or Labeled image.
[L_img,Labels] = SizeOfRegions( t_img, 500, 1500 );
figure(3);
imagesc( L_img ), colormap('gray');

% prepare to work through connected sets.
[N,M] = size( IMG_0034 );
D_img = zeros( N, M ); 
m = 5; % counts figures.
hayCnt = 1;
notHayCnt = 1;
% loop through each labelled set.
for k = 1:Labels
    [Row, Col] = find( L_img == k );  % find list of pixels labeled k
    % if size of region is appropriate.
    if length( Row ) > 500 && length( Row ) < 1500 
        % compute center of blob.
        Center = round( sum( [Row Col] )/length(Row) );
        % extract image around blob.
        r = max(1,Center(1)-70):min(N,Center(1)+70);
        c = max(1,Center(2)-70):min(M,Center(2)+70); 
        Local = IMG_0034( r, c );
        Mask = t_img( r, c );
        % display local image.
        figure(m)
        subplot( 221 ), imagesc( Local ), colormap('gray');
        % create threshold from top and bottom band of pixels. 
        I = 1:5*141;
        Mu_O = mean( double( [Local(I) Local(end-I+1)] ) );
        Std_O = std( double( [Local(I) Local(end-I+1)] ) );
  
        % Create threshold.
        Thres = Mu_O + 2.5*Std_O;
        figure(100); % figure to display process.
        Local = GrowAroundBlobs( Mask, edge(Local,'canny',[],2), ...
                                 Local, Thres ); 
        im_stats = inv_moments(Local);
        confirm = input("Is this a haybale? (1/0)");
        if confirm == 1
            hay_stats(hayCnt) = im_stats;
            hayCnt = hayCnt + 1;
        else
            not_hay_stats(notHayCnt) = im_stats;
            notHayCnt = notHayCnt + 1;
        end
        figure(m); % move back to current figure. 
        m = m + 1;  % move to next figure
        % Display segmented image. 
        subplot( 222 ), imagesc( Local ), colormap('gray');
        %pause(2)
        close 100 % remove demo figure
        % save off segmented image.
        D_img( r, c ) = Local;
    else
      t_img( [Row Col] ) = 0;   
    end
end

figure;
subplot(211),imagesc( D_img ), colormap('gray');
D_img( D_img > 0 ) = 1;
subplot(212),imagesc( D_img ), colormap('gray');

% %%
% e1_IMG = imdilate( e_IMG, ones(5,5) );
% e2_IMG = imerode( e1_IMG, ones(5,5) );
% %DD_img = Fill2Edge_Matlab( e2_IMG, D_img ); 
% %DD_img = imfill( D_img, find(  );
% 
% figure;
% imagesc( DD_img ), colormap('gray');
return
