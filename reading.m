%reading data
filename = 'B1_training.txt';
delimiterIn = ' ';
headerlinesIn = 1;
data_training = importdata(filename,delimiterIn,headerlinesIn);
labels=data_training.textdata(2:end,1);
for i=1:length(labels)
    temp=labels{i,1};
    labels{i,1}=temp(1);
    m00(i,1)=str2num(temp(2:end));
end

data_training=[m00,data_training.data];

