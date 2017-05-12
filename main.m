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
%%
[data_training,data_testing]=normalize_data(data_training,data_testing);
%%

% grid size
s = 60;
d = 2;
% number of iteraion
niter=200;

% learning parameters

D0        = 20;          
L0        = 0.1;          
lambda_D  =  1;       
lambda_L  =  1;      

% initialize the 8-dimensional grid
[grid(:,1), grid(:,2)] = ind2sub([s s], 1:s^d);

% create random initial weights
W_training = rand(s^d, size(data_training,2));

% run SOM learning for specified number of steps
for t = 1:niter
    W_training = somlearn(W_training, grid, data_training, D0, L0, lambda_D, lambda_L, t);
    t
end
%%
% create random initial weights
W_testing = rand(s^d, size(data_training,2));

% run SOM learning for specified number of steps
for t = 1:niter
    W_testing = somlearn(W_testing, grid, data_testing, D0, L0, lambda_D, lambda_L, t);
    t
end


