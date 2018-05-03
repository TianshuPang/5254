MAXITERS = 200;
ALPHA = 0.01;
BETA = 0.5;
NTTOL = 1e-8;
% terminate Newton iterations if lambda^2 < NTTOL
MU = 20;
TOL = 1e-4;
% terminate if duality gap less than TOL
Ap = max(A,0); Am = max(-A,0);
r = max(Ap*ones(n,1) + Am*ones(n,1));
u = (.5/r)*ones(n,1); l = -(.5/r)*ones(n,1);
t = 1;
for iter = 1:MAXITERS
    y = b+Am*l-Ap*u;
    val = -t*sum(log(u-l)) - sum(log(y));
    grad = t*[1./(u-l); -1./(u-l)] + [-Am'; Ap']*(1./y);
    hess = t*[diag(1./(u-l).^2), -diag(1./(u-l).^2);
    -diag(1./(u-l).^2), diag(1./(u-l).^2)] + ...
    [-Am'; Ap']*diag(1./y.^2)*[-Am Ap];
    step = -hess\grad; fprime = grad'*step;
    if (abs(fprime) < NTTOL)
        gap = (2*m)/t;
        disp(['iter', int2str(iter), '; gap = ', num2str(gap)]);
        if (gap<TOL)
            break;
        end
        t = MU*t;
     else
        dl = step(1:n); du = step(n+[1:n]);
        dy = Am*dl-Ap*du;
        tls = 1;
        while (min([u-l+tls*(du-dl); y+tls*dy]) <= 0)
            tls = BETA*tls;
        end
        while (-t*sum(log(u-l+tls*(du-dl))) - sum(log(y+tls*dy)) >= val + tls*ALPHA*fprime)
            tls = BETA*tls;
        end
        l = l+tls*dl; u = u+tls*du;
    end
end