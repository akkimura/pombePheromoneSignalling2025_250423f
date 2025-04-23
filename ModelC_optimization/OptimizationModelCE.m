% Optimization
y0 = zeros(32,1); % initial amounts of each component are zero
tspan = linspace(0,149,150); % time span is 0~149 hrs: NEW 220120!!

% create a 29-element optimization variable r that has a lower bound of 0.1 and an upper bound of 10.
r = optimvar('r',29,"LowerBound",0.1,"UpperBound",10);

% convert the function to an optimization expression by using fcn2optimexpr. See Convert Nonlinear Function to Optimization Expression.
load('expvalueCDC42.mat')
myfcn = fcn2optimexpr(@RtoODE_ModelCE,r,tspan,y0,expvalue125);

% objective function
obj = sum((myfcn - expvalue125(:,3)).^2);
prob = optimproblem("Objective",obj);
show(prob)

% solve problem
% To find the best-fitting parameters r, give an initial guess r0 for the solver and call solve.
r0.r = ones(29,1);
[rsol,sumsq] = solve(prob,r0)
disp(rsol.r)
output = rsol.r;

%% plot results
load('plotrangeCDC42.mat')
figure
yvals2 = RtoODE_ModelCE(rsol.r,tspan,y0,expvalue125);
for i=1:12 % changed 220120
    subplot(6,2,i) % changed 220120
    temp = plotrange(i,2):plotrange(i,3);
    plot(expvalue125(temp,2),expvalue125(temp,3),'b-',expvalue125(temp,2),yvals2(temp),'r--')
    legend('True','Fit','Location','best')
    title(['y(',num2str(plotrange(i,1)),')'])
end
save Output.mat output