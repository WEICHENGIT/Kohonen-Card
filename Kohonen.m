function Kohonen(V)
D=
L=
lambda_L=
lambda_D=

% randomly choose an input vector V
V_pick = pickrand(V);

% determine the winning output node i closest to V
i = index_of_closest(V_pick, w);

% update weights and track weight changes
w = update_weights(w, u, x_pick, i, t, tmax, mu_i, mu_f, sigma_i, sigma_f);

