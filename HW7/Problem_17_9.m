% resource allocation for stream processing.
clear all;
rand('state',1);
randn('state',1);
J = 10; % number of job types
P = 20; % number of process types
n = 5; % number of system resources
R = sprandn(P,J,0.6);
R = abs(R) > 0; % job process matrix
x_tot = 10*(1+rand(n,1)); % total resources available
A = 3+7*rand(n,P);
x_min = 0.2*rand(n,P); % minimum resources to run each process
w = 1+rand(J,1);
t_tar = 2+8*rand(J,1); % target job traffic
l_max = 1+2*rand(J,1); % maximum allowed job latency

cvx_begin
variable t(J)
variable x(n,P)
minimize(sum(w'*max(t_tar-t, zeros(J,1))))
subject to
    t_tar-t >= zeros(J,1)
    t >= 0
    x >= x_min
    R'*(pow_p(diag(A'*x) - R*t, -1)) <= l_max;
    size(R*t)
    diag(A'*x) > R*t;
    sum(x,2) <= x_tot
cvx_end
t
t_tar
