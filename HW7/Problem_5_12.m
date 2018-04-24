% ls_perm_meas_data.m
clear;
rand('seed',0);randn('seed',0)
m=100;
k=40; % max # permuted measurements
n=20;
A=10*randn(m,n);
x_true=randn(n,1); % true x value
y_true=A*x_true + randn(m,1);
% build permuted indices
perm_idxs=randperm(m);perm_idxs=sort(perm_idxs(1:k));
new_pos=perm_idxs(randperm(k));
% true permutation matrix
P=eye(m);P(perm_idxs,:)=P(new_pos,:);
perm_idxs(find(perm_idxs==new_pos))=[];
y=P*y_true;

above_tol = 1
tolerance = .000001
x_prior = zeros(n,1)

while 1
    % Find x_hat
    cvx_begin
        variable x(n,1)
        minimize(norm(A*x-P'*y, 2))
    cvx_end;
    % Align the smallest indixes, find pi (the permutation index alignement) 
    % and construct the permutation matrix P_hat accordingly:
    [Ax_values, Ax_idx] = sort(A*x);
    [y_values, y_idx] = sort(y);
    pi = [y_idx' ; Ax_idx'];
    P_hat = zeros(m, m);
    for i = 1 : m
       row = pi(1,i);
       col = pi(2,i);
       P_hat(row, col) = 1;
    end
    P = P_hat;
    if P*P' ~= eye(m)
        "Incorrect P!"
        break
    end
    x == x_prior
    dist = norm(x - x_prior, 2)
    if dist <= tolerance
        break
    end
    x_prior = x;
end
P_eye = eye(m)
cvx_begin
    variable x_eye(n,1)
    minimize(norm(A*x_eye-P_eye'*y, 2))
cvx_end;
"Distance x (P=I) and estimated x:"
norm(x_eye - x, 2)
"Distance x_true and estimated x:"
norm(x_true - x, 2)
