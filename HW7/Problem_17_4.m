% ad_disp_data.m
% data for online ad display problem
clear all;
rand('state',0);
n=100; %number of ads
m=30; %number of contracts
T=60; %number of periods
I=10*rand(T,1); %number of impressions in each period
R=rand(n,T); %revenue rate for each period and ad
q=T/n*50*rand(m,1); %contract target number of impressions
p=rand(m,1); %penalty rate for shortfall
Tcontr=(rand(T,m)>.8); %one column per contract. 1's at the periods to be displayed
for i=1:n
    contract=ceil(m*rand);
    Acontr(i,contract)=1; %one column per contract. 1's at the ads to be displayed
end

cvx_begin
    variable N(n,T)
    % we need s positive to ensure no negative penalties.
    s = pos(q-diag(Acontr'*N*Tcontr))
    maximize(sum(diag(R'*N())) - p'*s)
    subject to
        N >= 0;
        sum(N)== I';
cvx_end

net_profit = cvx_optval
revenue = sum(diag(R'*N))
payment = p'*s

% Highest ad revenue %
cvx_begin
    variable N(n,T)
    maximize (sum(diag(R'*N)))
    subject to
        N >= 0;
        ones(1,n)*N == I';
cvx_end
hi_ad_revenue = cvx_optval
s = pos(q-diag(Acontr'*N*Tcontr));
hi_ad_payment = p'*s
hi_ad_net_profit = hi_ad_revenue-hi_ad_payment