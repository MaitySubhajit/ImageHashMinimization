% Codes for calculation of K means cluster of Feature points
% K = 1 is taken as the number of clusters

% the tampered image directory should contain images with (<number>).jpg starting from 1 to n. n is number of samples in the dataset

i = 0;                                                                                  % image counter initialized

load ('centers_original.mat');                                                          % loading cluster centers from the original image set

count = 30;                                                                             % number of samples <n> in dataset
K = 1;                                                                                  % setting the number of clusters to be formed
thres = 1000;                                                                           % setting the threshold for SURF feature strength
dataset_path = 'path/to/dataset/root/CASIAv2/';                                         % setting the dataset path
maxiter_k = 1000000;                                                                    % setting up the maximum iterations to use for clustering

Centers_tampered = [];
path_tampered = strcat(dataset_path, '/', 'tampered');                                  % setting path to oroginal image directory

while (i<count)
    
    i = i + 1;
    
    C_Ini = Centers_original(:,:,i);                                                   
    
    imt_name = strcat('(', num2str(i), ').jpg');
    imt_path = strcat(path_tampered, imt_name);

    im_tampered = imread(imt_path);                                                     % image read
    im_tampered = imresize(im_tampered, [256 256])                                      % image resize
    
    info = imfinfo(imt_path);
    if (strcmp(info.ColorType, 'truecolor'))
        im_tampered = rgb2gray(im_tampered);                                            % grayscale conversion
    end
    
    points = detectSURFFeatures(im_tampered, 'MetricThreshold', thres);
    
    k = points.Location;                                                                % extracting key-point feature locations

    r = k(:,1);
    c = k(:,2);

    a = insertMarker(im_tampered, k);                                                   % marking the features on the image
    imshow(a);                                                                          % display detected SURF features

    k_amp = points.Metric;                                                              % extracting amplitude of the image pixel at key-point locations
    
    [idx, centers] = kmeans(k, K, 'MaxIter', maxiter_k, 'Start', C_Ini);                % K Means Clustering with original center initialization
    
    Centers_tampered = cat(3, Centers_tampered, centers);
end

save('centers_tampered.mat', 'Centers_tampered');                                       % saving cluster centroids