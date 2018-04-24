% data file for multi-label SVM problem
clear all;
randn('state', 0);
mTrain = 1000; % size of training data
mTest = 100; % size of test data
K = 10; % number of categories
n = 20; % number of features
A_true = randn(K, n);
b_true = randn(K, 1);
v = 0.2*randn(K, mTrain + mTest); % noise
data = randn(n, mTrain + mTest);
[~, label] = max(A_true * data + b_true * ones(1, mTrain + mTest) + v, [], 1);
% training data
x = data(:, 1:mTrain);
y = label(1:mTrain);
% test data
xtest = data(:, (mTrain+1):end);
ytest = label((mTrain+1):end);

up = 10^2
lo = 10^(-2)

U = [];
E = [];

ypred = round(max(A_true*xtest + b_true))
A_true*xtest + b_true * ones(1, 100)
ytest

% ypred(99);
% ytest(99);
% correct = 0
% for i = 1:100
%     "Output"
%     ypred(i)
%     ytest(i)
%     if ypred(i) == ytest(i)
%         correct = correct + 1
%     end      
% end

100*correct/100
% for s = 1:10
%     u = (up-lo).*rand(1) + lo;
%     U = [U ; u]
%     cvx_begin
%         variable z(mTrain)
%         variable A(K, n)
%         variable b(K, 1)
%         minimize(sum(z) + u*square_pos(norm(A,'fro')))
%         subject to
%         for k = 1:K
%             for i = 1:mTrain
%                 1+A(k,:)*x(:, i)+b(k,:)-y(:, i) <= z(i,:)
%             end
%         end
%         1'*b == 0
%         z >= 0
%     cvx_end
%     ypred = round(max(A*xtest + b))
%     total = length(ytest)
%     correct = 0
%     for i = 1:total
%         if ypred(:,i) == ytest(:,i)
%             correct = correct + 1
%         end      
%     end
%     percent_correct = correct/total
%     E = [E ; percent_correct]    
% end