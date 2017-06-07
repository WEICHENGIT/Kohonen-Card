function [norm_training,norm_testing] = normalize_data(data_training,data_testing)

norm_training = zeros(size(data_training));
norm_testing = zeros(size(data_testing));

for i = 1:size(data_training,2)
    RMS_training = norm(data_training(:,i),2)/sqrt(size(data_training,1));
    RMS_testing = norm(data_training(:,i),2)/sqrt(size(data_testing,1));
    norm_training(:,i) = data_training(:,i)/RMS_training;
    norm_testing(:,i) = data_testing(:,i)/RMS_testing;
end

end