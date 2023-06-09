% Comparison of Original & Tampered Images
% K = 1 is taken as the number of clusters

i = 0;                                                                                  % image counter initialized

load('centers_original.mat');                                                           % loading cluster centers from the original image set
load('centers_tampered.mat');                                                           % loading cluster centers from the tampered image set

count = 30;                                                                             % number of samples <n> in dataset
K = 1;                                                                                  % setting the number of clusters to be formed

Diff = [];

while (i<count)
    i = i + 1;

    CO = Centers_original(:,:,i);
    CT = Centers_tampered(:,:,i);
    Eq = isequal(CO, CT);                                                               % comparing original centroids with tampered centroids

    if Eq
        fprintf('Image %d.jpg is not tampered\n', i);
        D = NaN;                                                                        % setting measure of difference ans NaN for images that are not tampered
        Diff = cat(3, Diff, D);
    else
        fprintf('Image %d.jpg is tampered\n', i);
        X = pdist2(CO, CT, 'euclidean');                                                % finding measure of difference between tampered and original centroids

        D = min(min(X));
        Diff = cat(3, Diff, D);
    end
end

save('distance.mat', 'Diff');                                                           % saving distance matrix