clear all;

iter = 1000;
nu = .0001;
beta = .01;
alpha = .5;
n = 100;
m = 200;
x = zeros(n, 1);
A = randn(m,n);

V = []
I = []
T = []
for i = 1:iter
    % function evaluation
    f = -sum(log(1-A*x))-sum(log(1+x)) - sum(log(1-x));
    % gradient
    grad = A'*(1./(1-A*x)) - 1./(1+x) + 1./(1-x);
    % breaking criterion using nu as threshold
    if norm(grad) < nu
        break
    end
    % Gradient direction.
    dir = -grad;
    % second compoenent of backtracking
    fprime = grad'*dir;
    t = 1; 
    while ((max(A*(x+t*dir)) >= 1) || (max(abs(x+t*dir)) >= 1))
        t = beta*t;
    end
    % backtracking algorithm
    while ( -sum(log(1-A*(x+t*dir))) - sum(log(1-(x+t*dir).^2)) > f + alpha*t*fprime )
        t = beta*t;
    end
    % update step
    x = x+t*dir;
    T = [T; t]
    V = [V; f];
    I = [I ; i]
end

f_minus_p = [];
for i = 1:length(V)
    diff = V(i) - f
    f_minus_p = [f_minus_p; diff]
end
f_minus_p
f
figure(1)
plot(I,f_minus_p);
set(gca,'yscale','log');
titlestr = "Graph of f-p* vs iterations; Alpha=%0.3f and Beta=%0.3f";
str = sprintf(titlestr,alpha,beta);
title(str);
xlabel("Iterations");
ylabel("f(x)-p*");

figure(2)
plot(I,T);
titlestr = "Graph of t vs iterations; Alpha=%0.3f and Beta=%0.3f";
str = sprintf(titlestr,alpha,beta);
title(str);
xlabel("Iterations");
ylabel("t");


