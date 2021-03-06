function w = update_weights(w, u, V_pick, i, t, ...
                            D0, L0, lambda_D, lambda_L)
% UPDATE_WEIGHTS  Update weights for Kohonen's Self-Organizing Map.
%     Generally this function should not be called directly, but is called
%     automatically by SOMLEARN.  See SOMLEARN for an explanation of the
%     parameters.

% scale learning paramters by elapsed time                        
D = D0*exp(-t/lambda_D);
L = L0*exp(-t/lambda_L);
%D = D0*0.9^t;
%L = L0*0.9^t;

% udpate the weights, tracking mean weight change
for k = 1:size(w, 1)
    theta = sum((u(i,:)-u(k,:)).^2)< D^2;
    w(k,:) = w(k,:) + theta.*L.*(V_pick - w(k,:)); 
end
        