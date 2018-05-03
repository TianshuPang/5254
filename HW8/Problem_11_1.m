t = [.01, .02, .04, .08, .16, .32, .64, 1.28, 2.56, 5.12, 10.80]

figure(1)
fplot(@(x) power(2,x)+1, [0,6])
hold on
for i = 1:length(t)
    fplot(@(x) power(2,x)+1 + (1/t(i))*(-log(x-2)-log(4-x)))
end
hold off
xlabel("x")
ylabel("function value")
title("Log Barrier of f for various t values.")
legend("t=.01","t=.02","t=.04","t=.08","t=.16","t=.32","t=.74","t=1.28","t=5.12","t=10.80")