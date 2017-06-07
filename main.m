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
%Normalisation
[data_training,data_testing]=normalize_data(data_training,data_testing);
%%
%Generate a Kohonen map

% grid size
s = 60;
d = 2;
% number of iteraion
niter=1000;

% learning parameters
D0        = 25;          
L0        = 0.08;          
lambda_D  =  niter/3;       
lambda_L  =  niter/1;      

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
    text(BMU_training(i,1),BMU_training(i,2),labels_training{i},'FontSize',15,'Color','b');
    xlim([1 s]);
    ylim([1 s]);
    hold on;
    grid on;
end
figure(1);
title(sprintf('Trained Kohonen map,\n with niter=%d, D_0=%d, L_0=%.2f, lambda_D=%.2f, lambda_L=%.2f',niter,D0,L0,lambda_D,lambda_L));

for i=1:length(data_testing)
    [ignore, BMU]=closest(data_testing(i,:),W_training);
    BMU_testing(i,:)=Grid(BMU,:);
    figure(2);
    plot(BMU_testing(i,1),BMU_testing(i,2),'');
    hold on;
    figure(3);
    plot(BMU_testing(i,1),BMU_testing(i,2),'');
    hold on;
end

Mdl = fitcknn(BMU_training,labels_training,'NumNeighbors',5,'Standardize',1);
[labels_estimate,score,cost]= predict(Mdl,BMU_testing);

correct=0;
for i=1:length(data_testing)
    if labels_estimate{i}==labels_testing{i}
        figure(2);
        text(BMU_testing(i,1),BMU_testing(i,2),labels_estimate{i},'FontSize',15,'Color','b');
        hold on;
        correct=correct+1;
        figure(3);
        hold on;
        text(BMU_testing(i,1),BMU_testing(i,2),labels_testing{i},'FontSize',15,'Color','b');
    else
        figure(2);
        hold on;
        text(BMU_testing(i,1),BMU_testing(i,2),labels_estimate{i},'FontSize',15,'Color','r');
        figure(3);
        hold on;
        text(BMU_testing(i,1),BMU_testing(i,2),labels_testing{i},'FontSize',15,'Color','r');
    end
end
figure(2);
xlim([1 s]);
ylim([1 s]);
title(sprintf('Estimated characters of test set,\n with niter=%d, D_0=%d, L_0=%.2f, lambda_D=%.2f, lambda_L=%.2f',niter,D0,L0,lambda_D,lambda_L));
hold on;
grid on;
figure(3);
xlim([1 s]);
ylim([1 s]);
title(sprintf('True characters of test set,\n with niter=%d, D_0=%d, L_0=%.2f, lambda_D=%.2f, lambda_L=%.2f',niter,D0,L0,lambda_D,lambda_L));
hold on;
grid on;
correct/length(labels_testing)
%%
%Classification without KNN
close all;
figure(1);
for i=1:length(data_training)
    [ignore, BMU]=closest(data_training(i,:),W_training);
    BMU_training(i,:)=Grid(BMU,:);
    plot(BMU_training(i,1),BMU_training(i,2),'');
    text(BMU_training(i,1),BMU_training(i,2),labels_training{i},'FontSize',15,'Color','b');
    xlim([1 s]);
    ylim([1 s]);
    hold on;
    grid on;
end

correct=0;
for i=1:length(data_testing)
    [ignore, BMU]=closest(data_testing(i,:),W_training);
    BMU_testing=Grid(BMU,:);
    figure(2);
    plot(BMU_testing(1),BMU_testing(2),'');
    hold on;
    figure(3);
    plot(BMU_testing(1),BMU_testing(2),'');
    hold on;
    
    [ignore,labels_estimate]=closest(BMU_testing,BMU_training);
    labels_estimate=labels_training{labels_estimate};
    if labels_estimate==labels_testing{i}
        figure(2);
        text(BMU_testing(1),BMU_testing(2),labels_estimate,'FontSize',15,'Color','b');
        hold on;
        correct=correct+1;
        figure(3);
        hold on;
        text(BMU_testing(1),BMU_testing(2),labels_testing{i},'FontSize',15,'Color','b');
    else
        figure(2);
        hold on;
        text(BMU_testing(1),BMU_testing(2),labels_estimate,'FontSize',15,'Color','r');
        figure(3);
        hold on;
        text(BMU_testing(1),BMU_testing(2),labels_testing{i},'FontSize',15,'Color','r');
    end
end
figure(2);
xlim([1 s]);
ylim([1 s]);
hold on;
grid on;
figure(3);
xlim([1 s]);
ylim([1 s]);
hold on;
grid on;
correct/length(labels_testing)
%%
%KNN without Kohonen
Mdl = fitcknn(data_training,labels_training,'NumNeighbors',5,'Standardize',1);
[labels_estimate,score,cost]= predict(Mdl,data_testing);

correct=0;
for i=1:length(data_testing)
    if labels_estimate{i}==labels_testing{i}
        correct=correct+1;
    end
end
correct/length(labels_testing)
