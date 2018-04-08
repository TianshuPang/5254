upper = exp(5);
lower = 0;
tolerance = .001
k = 201
t=(-3:6/(k-1):3)';
y=exp(t);
% 1 + t + t^2
T=[ones(k,1) t t.^2];

while upper - lower >= tolerance
    midpoint = (lower + upper)/2
    cvx_begin
    % a_0, a_1, a_2
    variable a(3)
    % b_0, b_1
    variable b(2)
    subject to
        abs(T*a-y.*(T*[1;b])) <= midpoint*T*[1;b]
    cvx_end
    if strcmp(cvx_status,'Solved')
        a_star = a;
        b_star = b;
        upper = midpoint;
        value = midpoint;
    else
        lower = midpoint       
    end
end

y_star = T*a_star./(T*[1;b_star]);
y_star
a_star
b_star

figure(1);
plot(t,y, t,y_star,'r+');
xlabel('t');
ylabel('y');

figure(2);
plot(t, y_star-y);
xlabel('t');
ylabel('err');