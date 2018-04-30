
clear all;

iter = 1000;
nu = .0000001;
beta = .5;
alpha = .01;
n = 100;
m = 200;
x = zeros(n, 1);
A = randn(m,n);

NTTOL = 1e-8;

x = zeros(n,1);

V = []
I = []
for i = 1:iter
    f = -sum(log(1-A*x)) - sum(log(1+x)) - sum(log(1-x));
    d = 1./(1-A*x);
    grad = A'*d - 1./(1+x) + 1./(1-x);
    hessian = A'*diag(d.^2)*A + diag(1./(1+x).^2 + 1./(1-x).^2);
    dir = -hessian\grad;
    fprime = grad'*dir;
    if abs(fprime) < nu
        break;
    end
    t = 1; 
    while ((max(A*(x+t*dir)) >= 1) || (max(abs(x+t*dir)) >= 1))
        t = beta*t;
    end
    while ( -sum(log(1-A*(x+t*dir))) - sum(log(1-(x+t*dir).^2)) > f + alpha*t*fprime )
        t = beta*t;
    end
    x = x+t*dir;
    V = [V; f];
    I = [I ; i];
end

f_minus_p = [];
for i = 1:length(V)
    diff = V(i) - f
    f_minus_p = [f_minus_p; diff]
end
f_minus_p
I
semilogy(I, f_minus_p)