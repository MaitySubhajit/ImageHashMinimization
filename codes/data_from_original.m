% Codes for calculation of K means cluster of Feature points
% K = 1 is taken as the number of clusters

% the original image directory should contain images with <number>.jpg starting from 1 to n. n is number of samples in the dataset

i = 0;                                                                                  % image counter initialized

% load ('Centers_Initiate.mat');

count = 30;                                                                             % number of samples <n> in dataset
K = 1;                                                                                  % setting the number of clusters to be formed
thres = 1000;                                                                           % setting the threshold for SURF feature strength
dataset_path = 'path/to/dataset/root/CASIAv2/';                                         % setting the dataset path
maxiter_k = 1000000;                                                                    % setting up the maximum iterations to use for clustering

Centers_original = [];
path_original = strcat(dataset_path, '/', 'original');                                  % setting path to original image directory

while (i<count)
    
    i = i + 1;
    
    imo_name = strcat(num2str(i), '.jpg');
    imo_path = strcat(path_original, imo_name); 
    
    im_original = imread(imo_path);                                                     % image read
    im_original = imresize(im_original, [256 256]);                                     % image resize
    
    info = imfinfo(imo_path);
    if (strcmp(info.ColorType, 'truecolor'))
        im_original = rgb2gray(im_original);                                            % grayscale conversion
    end
    
    points = detectSURFFeatures(im_original, 'MetricThreshold', thres);
    
    k = points.Location;                                                                % extracting key-point feature locations

    r = k(:,1);
    c = k(:,2);

    a = insertMarker(im_original, k);                                                   % marking the features on the image
    imshow(a);                                                                          % display detected SURF features
    
    k_amp = points.Metric;                                                              % extracting amplitude of the image pixel at key-point locations
    
    [idx, centers] = kmeans(k, K, 'MaxIter', maxiter_k);                                % K Means Clustering
    
    Centers_original = cat(3, Centers_original, centers);
end

save('centers_original.mat', 'Centers_original');                                       % saving cluster centroids