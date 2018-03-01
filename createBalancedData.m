function createBalancedData(numTimeWindows,numFFTbuckets,minHz,maxHz,cnnTargetHeight,cnnTargetWidth,displayFig,classes,projectPrefix,type,overlap,chunksize)
%% load the data

% load and parse the Excel file
%classes = ["1", "7", "13"];

[~,~,y] = xlsread('../data/joined_data.xlsx');
[~, text] = xlsread('../data/joined_data.xlsx','A1:CB1');
y = y(2:end,:);
trackID = y(:,63);
nasalCodeID = y(:,39);
y = cell2table(y);
y.Properties.VariableNames = text;
count = zeros(length(classes), 1);
numrows = height(y);
filepath = sprintf('../Cantometric MP3s');
dataDir = sprintf('../Cantometric MP3s/test');
for e = 1:length(classes)
     [~,~,~] = mkdir(sprintf('%s/%s',dataDir,classes(e)));
end

for i=1:numrows
    for j=1:length(classes)
        if (strcmp(y{i, 'CANTO_VAR_34'}{1}, classes(j)))
            haveAudio =  exist(sprintf('%s/%s.mp3',filepath,trackID{i}),'file');
            if haveAudio
                count(j) = count(j) + 1;
            end
        end
    end
end
%% copy the audio files
num = min(count);
count = zeros(length(classes), 1);

for i=1:numrows
    for j=1:length(classes)
        if (strcmp(y{i, 'CANTO_VAR_34'}{1}, classes(j)))
            haveAudio =  exist(sprintf('%s/%s.mp3',filepath,trackID{i}),'file');
            if haveAudio && (count(j) < num)
                copyfile(sprintf('%s/%s.mp3',filepath,trackID{i}),sprintf('%s/%s',dataDir,char(nasalCodeID(i))),'f');                
                count(j) = count(j) + 1;
            end
        end
    end
end
disp(count)
fprintf('Located %d WAV files\n',sum(count));

%% create spectrograms
createTrainingData(dataDir,numTimeWindows,numFFTbuckets,minHz,maxHz,...,
    cnnTargetHeight,cnnTargetWidth,displayFig,projectPrefix,type,overlap,chunksize);