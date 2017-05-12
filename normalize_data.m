function [normed_training,normed_testing] = normalize_data(data_training,data_testing)

normed_training = zeros(size(data_training));
normed_testing = zeros(size(data_testing));

for i = 1:size(data_training,2)
    tmp = data_training(:,i);
    tmp = [tmp;data_testing(:,i)];
    norm_fact = norm(tmp,2);
    normed_training(:,i) = data_training(:,i)/norm_fact;
    normed_testing(:,i) = data_testing(:,i)/norm_fact;
end

end