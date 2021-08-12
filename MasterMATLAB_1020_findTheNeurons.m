%%
%     COURSE: Master MATLAB through guided problem-solving
%    SECTION: Segmentation
%      VIDEO: Brain cell size and count
% Instructor: mikexcohen.com
%
%%

% image downloaded from:
% http://atlas.brain-map.org/atlas?atlas=1&plate=100960324#atlas=1&plate=100960324

% read in image and take a look
img = imread('100048576_197.jpg');
figure(1), clf
imshow(img)

% cut out subsection
img = squeeze(mean( img(1073:2335,2180:3803,:) ,3));% Remove dimensions of length 1..here we want to get rid 
%of the thrid dimension which corresponds to the color 

% now look at the subsection
imagesc(img), axis image
colormap gray


% find an appropriate threshold; we do this by looking at the histogram of
% the image. And inputing a 2D matrix would create a seperate histogram for
% each column which is not what we want. To avoid this, we vectorize the
% matrix. 

figure(2), clf
hist(img(:),500)

thresh = 190 ; %based on visual inspection and trial and error

% create a binarized thresholded map
threshmap = img < thresh; 

% get information about the 'islands' in that map
units = bwconncomp(threshmap); % Find connected components in binary image. From Image processing toolbox 


% show an image of the map again
imagesc(img), hold on
contour(threshmap,1,'r') % Contour plot of matrix , using one single contour in red color
axis image
colormap gray
zoom on

% remove if too small
unitsizes = cellfun(@length,units.PixelIdxList) %another method is using a for loop. Cellfun  will allow us to apply
%the function length on the entire cell array. We need to do this bc hist
%inputs must be numeric or a categorical array
%can't just apply hist 
figure(3), clf
hist(unitsizes,900)
set(gca,'xlim',[0 250])
xlabel('Unit size (pixels)'), ylabel('Count')

% select a pixel threshold
pixthresh = 8 % we found this by inspection from the histogram 

% now have to reconstruct a threshmap
threshmapFilt = false(size(threshmap));%we are filtering out the really small cluters 
for ui=1:units.NumObjects  %loop through all the clusters in the image 
    
    % skip this unit if too small
    if unitsizes(ui) < pixthresh
        continue ; 
    end 
    
    threshmapFilt(units.PixelIdxList{ui}) = 1;
end

% redraw on previous map
figure(4)
imagesc(img), hold on
contour(threshmap,1,'r')
axis image
colormap gray
zoom on
contour(threshmapFilt,1,'b')
% notice the red contours are the ones that got filtered out. 



%%
