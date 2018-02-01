code_file = '../data/Cantometrics_Coding_Data_nasality.csv';
canto_file = '../data/CantoMetadata_MasterGeog_data_1.xlsx';

code_table = readtable(code_file);
[~, text] = xlsread(canto_file, '1:1');
[~, ~, canto] = xlsread(canto_file,'A2:AH5900');
canto_table = cell2table(canto);



canto_table.Properties.VariableNames = text;

canto_id = canto_table.Coding_ID;
code_id = code_table.Coding_ID;

%dif = setdiff(code_id, canto_id);

%find(hist(code_id,unique(code_id))>1)

joined_table = join(code_table, canto_table, 'Keys', 'Coding_ID');
writetable(joined_table,'joined_data.xlsx');
%disp(joined_table.Properties);