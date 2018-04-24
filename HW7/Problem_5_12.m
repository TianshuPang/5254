% ls_perm_meas_data.m
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


cvx_begin
    variable P_hat(m,m)
    variable x(n,1)
    minimize(norm(A*x-P'*y_true, 2))
    subject to
       
        
cvx_end