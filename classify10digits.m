clear all;
%%
%reading data
n_training=500;
[data_training, labels_training] = readMNIST('train-images.idx3-ubyte', 'train-labels.idx1-ubyte', n_training, 0);
data_training=reshape(data_training,[400,n_training]);
data_training=data_training';
n_testing=100;
[data_testing, labels_testing] =  readMNIST('t10k-images.idx3-ubyte','t10k-labels.idx1-ubyte', n_testing,0);
data_testing=reshape(data_testing,[400,n_testing]);
data_testing=data_testing';
%%
%Normalisation
%[data_training, data_testing]=normalize_data(data_training, data_testing);
%%
%Generate a Kohonen map

% grid size
s = 100;
d = 2;
% number of iteraion
niter=10000;

% learning parameters
D0        = 50;          
L0        = 0.02;          
lambda_D  =  niter/3;       
lambda_L  =  niter/3;      

% initialize the 8-dimensional grid
[Grid(:,1), Grid(:,2)] = ind2sub([s s], 1:s^d);

% create random initial weights
rand('seed',1);
W_training = rand(s^d, size(data_training,2));

% run SOM learning for specified number of steps
for t = 1:niter
    W_training = somlearn(W_training, Grid, data_training, D0, L0, lambda_D, lambda_L, t);
    t
end
%%
%Classification with KNN
close all;
figure(1);
for i=1:length(data_training)
    [ignore, BMU]=closest(data_training(i,:),W_training);
    BMU_training(i,:)=Grid(BMU,:);
    plot(BMU_training(i,1),BMU_training(i,2),'');
    text(BMU_training(i,1),BMU_training(i,2),num2str(labels_training(i)),'FontSize',12,'Color','black');
    xlim([1 s]);
    ylim([1 s]);
    hold on;
    grid on;
end
figure(1);
title(sprintf('Kohonen map,\n with niter=%d, D_0=%d, L_0=%.2f, lambda_D=%.2f, lambda_L=%.2f',niter,D0,L0,lambda_D,lambda_L));
%%
W_labeled=zeros(100*100,400);
for i = BMU
    W_labeled(i,:)=W_training(i,:);
end

for i=1:n_testing
    [ignore, BMU]=closest(data_testing(i,:),W_labeled);
    BMU_testing(i,:)=Grid(BMU,:);
    figure(2);
    plot(BMU_testing(i,1),BMU_testing(i,2),'');
    hold on;
end

Mdl = fitcknn(BMU_training,labels_training,'NumNeighbors',10,'Standardize',1);
[labels_estimate,score,cost]= predict(Mdl,BMU_testing);

correct=0;
for i=1:n_testing
    if labels_estimate(i)==labels_testing(i)
        correct=correct+1;
        figure(2);
        hold on;
        text(BMU_testing(i,1),BMU_testing(i,2),num2str(labels_testing(i)),'FontSize',12,'Color','b');
    else
        figure(2);
        hold on;
        text(BMU_testing(i,1),BMU_testing(i,2),num2str(labels_testing(i)),'FontSize',12,'Color','r');
    end
end
figure(2);
xlim([1 s]);
ylim([1 s]);
grid on;
correct/n_testing