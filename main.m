clear all;
%%
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
s = 100;
d = 2;
% number of iteraion
niter=1000;

% learning parameters

D0        = 50;          
L0        = 0.2;          
lambda_D  =  niter/3;       
lambda_L  =  niter/3;      

% initialize the 8-dimensional grid
[Grid(:,1), Grid(:,2)] = ind2sub([s s], 1:s^d);

% create random initial weights
W_training = rand(s^d, size(data_training,2));

% run SOM learning for specified number of steps
for t = 1:niter
    W_training = somlearn(W_training, Grid, data_training, D0, L0, lambda_D, lambda_L, t);
    t
end
%%
figure(1);
for i=1:length(data_training)
    [ignore, BMU]=closest(data_training(i,:),W_training);
    BMU_training(i,:)=Grid(BMU,:);
    plot(BMU_training(i,1),BMU_training(i,2),'Line','none');
    text(BMU_training(i,1),BMU_training(i,2),labels_training{i},'FontSize',15,'Color','b');
    xlim([1 s]);
    ylim([1 s]);
    hold on;
    grid on;
end

correct=0
figure(2);
for i=1:length(data_testing)
    [ignore, BMU]=closest(data_testing(i,:),W_training);
    BMU_testing=Grid(BMU,:);
    plot(BMU_testing(1),BMU_testing(2),'Line','none');
    [ignore,labels_estimate]=closest(BMU_testing,BMU_training);
    labels_estimate=labels_training{labels_estimate};
    if labels_estimate==labels_testing{i}
        text(BMU_testing(1),BMU_testing(2),labels_estimate,'FontSize',15,'Color','b');
        correct=correct+1;
    else
        text(BMU_testing(1),BMU_testing(2),labels_estimate,'FontSize',15,'Color','r');
    end
    xlim([1 s]);
    ylim([1 s]);
    hold on;
    grid on;
end
correct/length(labels_testing)