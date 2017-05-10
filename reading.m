clear all;
%reading data
delimiterIn = ' ';
headerlinesIn = 1;
data_training = importdata('B1_training.txt',delimiterIn,headerlinesIn);
labels_training=data_training.textdata(2:end,1);
for i=1:length(labels_training)
    temp=labels_training{i,1};
    labels_training{i,1}=temp(1);
    m00(i,1)=str2num(temp(2:end));
end
data_training=[m00,data_training.data];

delimiterIn = '&';
data_testing = importdata('B1_testing.txt',delimiterIn,headerlinesIn);
labels_testing=data_testing.textdata(2:end,1);
for i=1:length(labels_training)
    temp=labels_testing{i,1};
    labels_testing{i,1}=temp(1);
    m00(i,1)=str2num(temp(2:end));
end
data_testing=[m00,data_testing.data];