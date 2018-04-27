

iter = 1000;
tolerance = .0001;
beta = .5;
alpha = .01;
n = 100;
m = 80;
x = zeros(n, 1);
A = randn(m,n);
for i = 1:iter
    f = -sum(log(1-A*x))-sum(1-power(x,2));
    grad = A'*(1./(1-A*x)) - (2*x)./(1-power(x,2));
    norm(grad)
    if norm(grad) < tolerance
        break
    end
    % Gradient direction.
    dir = -grad;
    fprime = grad'*v;
    t = 1; 
    while ((max(A*(x+t*v)) >= 1) || (max(abs(x+t*v)) >= 1))
        t = beta*t;
    end
    while ( -sum(log(1-A*(x+t*v))) - sum(log(1-(x+t*v).^2)) > f + alpha*t*fprime )
        t = beta*t;
    end
    x = x+t*v;
end
