file = '../data/joined_data.xlsx';

[~, text] = xlsread(file, 'A1:BG1');
[~, ~, canto] = xlsread(file,'A2:BG5850');


table = cell2table(canto);
table.Properties.VariableNames = text;

num_rows = height(table);
rows = 1:num_rows;
canto_var = ["CANTO_VAR_1", "CANTO_VAR_2", "CANTO_VAR_3", "CANTO_VAR_4", "CANTO_VAR_5", "CANTO_VAR_6", "CANTO_VAR_7", "CANTO_VAR_8","CANTO_VAR_9", "CANTO_VAR_10", "CANTO_VAR_11", "CANTO_VAR_12", "CANTO_VAR_13", "CANTO_VAR_14", "CANTO_VAR_15", "CANTO_VAR_16", "CANTO_VAR_17", "CANTO_VAR_18", "CANTO_VAR_19", "CANTO_VAR_20", "CANTO_VAR_21", "CANTO_VAR_22", "CANTO_VAR_23", "CANTO_VAR_24","CANTO_VAR_25", "CANTO_VAR_26", "CANTO_VAR_27", "CANTO_VAR_28", "CANTO_VAR_29", "CANTO_VAR_30", "CANTO_VAR_31", "CANTO_VAR_32", "CANTO_VAR_33", "CANTO_VAR_34", "CANTO_VAR_35", "CANTO_VAR_36", "CANTO_VAR_37"]';

% count how many zeros in each coding line
%{
count = 0;
for i = 1:num_rows
    if strcmp(vars(i),'0')
        disp(i)
        count = count + 1;
    end
end
%}

for i = 1:37
    var_name = cellstr(canto_var(i));   
    vars = table{rows,var_name};
    codings = unique(vars);

    count = categorical(vars, codings);
    histogram(count);
    title(var_name);
   
    print(gcf, char(var_name),'-dpng');
end
