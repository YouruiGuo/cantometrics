file = '../data/joined_data.xlsx';

[~, text] = xlsread(file, 'A1:BG1');
[~, ~, canto] = xlsread(file,'A2:BG5850');

table = cell2table(canto);
table.Properties.VariableNames = text;

canto_var = ["CANTO_VAR_1", "CANTO_VAR_2", "CANTO_VAR_3", "CANTO_VAR_4", "CANTO_VAR_5", "CANTO_VAR_6", "CANTO_VAR_7", "CANTO_VAR_8","CANTO_VAR_9", "CANTO_VAR_10", "CANTO_VAR_11", "CANTO_VAR_12", "CANTO_VAR_13", "CANTO_VAR_14", "CANTO_VAR_15", "CANTO_VAR_16", "CANTO_VAR_17", "CANTO_VAR_18", "CANTO_VAR_19", "CANTO_VAR_20", "CANTO_VAR_21", "CANTO_VAR_22", "CANTO_VAR_23", "CANTO_VAR_24","CANTO_VAR_25", "CANTO_VAR_26", "CANTO_VAR_27", "CANTO_VAR_28", "CANTO_VAR_29", "CANTO_VAR_30", "CANTO_VAR_31", "CANTO_VAR_32", "CANTO_VAR_33", "CANTO_VAR_34", "CANTO_VAR_35", "CANTO_VAR_36", "CANTO_VAR_37"]';

valid_code = ["1 2 4 5 6 7 8 9 10 11 12 13", "1 2 3 5 6 8 9 12 13", "1 2 4 5 6 7 8 9 10 11 12 13", "1 4 7 10 13", "1 4 7 10 13", "1 4 7 10 13", "1 4 7 10 13","1 4 7 10 13", "1 4 7 10 13", "1 4 7 10 13", "1 3 6 9 11 13", "1 3 5 7 9 11 13", "1 3 6 9 11 13", "1 3 5 7 9 11 13", "1 5 9 13", "1 2 3 4 5 6 7 8 9 10 11 12 13", "1 4 7 10 13", "1 3 5 6 8 9 11 13", "1 4 9 11 13", "1 4 7 10 13", "1 4 7 10 13", "1 3 6 8 10 13", "1 4 7 10 13", "1 3 5 9 11 13", "1 4 7 10 13", "1 5 9 13", "1 5 9 13", "1 5 9 13", "1 7 13", "1 7 13", "1 7 13", "1 4 7 10 13", "1 3 6 8 10 13", "1 4 7 10 13", "1 4 7 10 13", "1 4 7 10 13", "1 4 7 10 13"];

numrows = height(table);
row = 1:numrows;

error_report = ModelAdvisor.FormatTemplate('TableTemplate');
setTableTitle(error_report, 'error_report_table');
setColTitles(error_report, cellstr(["var","row#","invalid_code","count"]));
report_file = 'error_report_file.xlsx';

for i = 1:37
    f_name = strcat('../data/table_', num2str(i), '.xlsx');
    p_name = strcat('../data/CantoVariable', num2str(i));
    
    % Create FormatTemplate object, specify table format
    ft = ModelAdvisor.FormatTemplate('TableTemplate');
    % Add information to the table
    setTableTitle(ft, p_name);
    setColTitles(ft, text);
    
    v_code = valid_code(i);
    v_code = split(v_code, ' ');
    %disp(v_code)
    
    var_name = cellstr(canto_var(i));
    vars = table{row,var_name};
    
    invalid_code = 0;
    for j = 1:numrows
        splitted = split(vars(j), ' ');
        if length(splitted) == 1
            mark = 0;
            for k = 1:length(v_code)
                if str2double(splitted) == str2double(v_code(k))
                    addRow(ft, table2cell(table(j, :)));
                    mark = 1;
                    break
                end
            end  
            if mark ~= 1
                invalid_code = invalid_code + 1; 
                r = cellstr([num2str(i); num2str(j); splitted; num2str(invalid_code)]);
                addRow(error_report, r')
            end
            
        elseif length(splitted) == 3
            mark_1 = 0;
            code1 = splitted(1);
            code2 = splitted(3);
            for k = 1:length(v_code)
                if str2double(code1)==str2double(v_code(k))
                    mark_1 = mark_1 + 1;
                elseif str2double(code2)==str2double(v_code(k))
                    mark_1 = mark_1 + 1;
                end
            end
            if mark_1 ~= 2
                invalid_code = invalid_code + 1;
                r = cellstr([num2str(i); num2str(j); cellstr(strcat(splitted)); num2str(invalid_code)]);
                addRow(error_report, r')
            end
                
        else 
            mark = 0;
            code1 = splitted(1);
            code2 = splitted(3);
            code3 = splitted(5);
            for k = 1:length(v_code)
                if str2double(code1)==str2double(v_code(k))
                    mark = mark + 1;
                elseif str2double(code2)==str2double(v_code(k))
                    mark = mark + 1;
                elseif str2double(code3)==str2double(v_code(k))
                    mark = mark + 1;
                end
            end
            if mark ~= 3
                invalid_code = invalid_code + 1;
                r = cellstr([num2str(i); num2str(j); cellstr(strcat(splitted)); num2str(invalid_code)]);
                addRow(error_report, r')
            end
        end        
    end

    t = cell2table(ft.TableInfo);
    t.Properties.VariableNames = text;
    writetable(t, char(f_name));
     
    num_rows = height(t);
    rows = 1:num_rows;
    var = t{rows,var_name};
    codings = unique(var);

    codings = sort(str2double(codings));
    codings = cellstr(num2str(codings));
    %disp(codings);
    count = categorical(var, codings);
    histogram(count);
    title(var_name);   
    print(gcf, char(p_name),'-dpng'); 
    
    disp([i, invalid_code]);
    
end
error_table = cell2table(error_report.TableInfo);
error_table.Properties.VariableNames = cellstr(["canto_var","row_number","invalid_code","count"]);
writetable(error_table, char(report_file));

