% sparse_idx_track_data.m
% data generation for sparse index tracking problem
% generates n, c, rbar, Sigma
clear all;
rand('state',1);
randn('state',1);
n = 500; % number of stocks
k = 20; % number of factors (not described or needed  in problem statement)
% generate rbar, Sigma
F = 1.5*rand(n,k)-0.5; % factor matrix, entries uniformon [-0.5,1]
Sigma = 0.5*F*diag(rand(k,1))*F' + diag(0.1*rand(n,1));
mu_rf = 0.2; % risk-free return (weekly, 5% annual)
SR = 0.4; % Sharpe ratio
rbar = mu_rf + SR*sqrt(diag(Sigma)); % expected return
c = 5 + exp(2*randn(n,1)); % market capitalization (index weights)


ctc = mtimes(c', c);
rbarsq = dot(rbar, rbar');
zsqr = (ctc * rbarsq)


cvx_begin
  variable w(n)
  minimize norm(w,1)
  E_num = ( (rbar' * (c * c') * rbar)) + c'*diag(Sigma) + (w' * (Sigma + (rbar * rbar')) * w) - 2 * w' *(Sigma + (rbar * rbar')) * c ;
  subject to
      E_num <= 0.01 * (ctc * rbarsq);
      w <= c;
cvx_end

E_num/(ctc * rbarsq)
sum(abs(w > 0.01))
sum(abs(c > 0.01))

