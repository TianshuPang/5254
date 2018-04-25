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
tolerance = .00000001
% Seed our initial estimate of x using huber function
cvx_begin
variable x(n);
    minimize( sum(huber(A*x-y)) );
cvx_end
P_hat = eye(m)
x_prior = zeros(n)
while 1
    
    % Align the smallest indixes, find pi (the permutation index alignement) 
    % and construct the permutation matrix P_hat accordingly:
    [Ax_values, Ax_idx] = sort(A*x);
    [y_values, y_idx] = sort(y);
    pi = [y_idx' ; Ax_idx'];
    P_temp = zeros(m, m);
    for i = 1 : m
       row = pi(1,i);
       col = pi(2,i);
       P_temp(row, col) = 1;
    end
    P_hat = P_temp;
    if P_hat*P_hat' ~= eye(m)
        "Invalid P_hat!"
        break
    end
    "Distance:"
    dist = norm(x - x_prior, 2)
    if dist <= tolerance
        break
    end
    x_prior = x;
    
    % Find x_hat
    cvx_begin
        variable x(n,1)
        minimize(norm(A*x-P_hat'*y, 2))
    cvx_end;
end
P_eye = eye(m);
cvx_begin
    variable x_eye(n,1)
    minimize(norm(A*x_eye-P_eye'*y, 2))
cvx_end;
"Distance estimated x (P=I) and x_true:"
norm(x_eye - x_true, 2)
"Distance x_true and estimated x:"
norm(x_true - x, 2)
