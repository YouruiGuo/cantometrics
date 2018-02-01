canto_file = '../data/CantoMetadata_MasterGeog_data_1.xlsx';

[~, text] = xlsread(canto_file, '1:1');
[~, ~, canto] = xlsread(canto_file,'A2:AH5899');

num_data = 5898;

canto_table = cell2table(canto);
canto_table.Properties.VariableNames = text;

cluster = canto_table.style_cluster;
cluster_name = unique(cluster);
num_cluster = length(cluster_name);


count = categorical(cluster, cluster_name);
histogram(count);
title('style cluster');
print(gcf, 'style_cluster', '-dpng');
