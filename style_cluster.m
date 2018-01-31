canto_file = 'CantoMetadata_MasterGeog_data_1.xlsx';

[~, text] = xlsread(canto_file, '1:1');
[~, ~, canto] = xlsread(canto_file,'A2:AH5899');

num_data = 5898;

canto_table = cell2table(canto);
canto_table.Properties.VariableNames = text;

cluster = canto_table.style_cluster;
cluster_name = unique(cluster);
num_cluster = length(cluster_name);

%{
count = zeros(num_cluster,1);
for i = 1:num_data
    for j = 1:num_cluster
        if strcmp(cluster(i), cluster_name(j))
            count(j) = count(j) + 1;
        end
    end
end    
%}

count = categorical(cluster, cluster_name);
histogram(count);
title('style cluster');
