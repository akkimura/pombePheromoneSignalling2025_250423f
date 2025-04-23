%% TanakaAnalysesMCMC_ModelCA.m
%% based on TanakaAnalysesMCMC_ModelNNNW.m

np = 6;
load(sprintf('MCMC_outputPost%d.mat',np));
RowN1 = size(outputPost,1);

rowcount = 0;
for row = 1:RowN1
    if outputPost(row,1) == np
        rowcount = rowcount +1;
        output2(rowcount,:) = outputPost(row,:);
    end
end

RowN = rowcount;

%% 
INTERVAL = 100;
ExtN = floor(RowN/INTERVAL);
outputExt = zeros(ExtN,size(output2,2));

RN=29; % The number of variables
SumR = zeros(1,RN+1);
MaxR = zeros(1,RN+1);
AveR = zeros(1,RN+1);

for row = 1:ExtN
    outputExt(row,:) = output2(row.*INTERVAL,:);
    if row==1;
        MaxLL = outputExt(row,RN+3);
        MaxID = row;
        MaxR = reshape(outputExt(row,3:(RN+3)),1,RN+1);
        SumR(1,1:RN) = reshape(outputExt(row,3:(RN+2)).*exp(outputExt(row,RN+3)),1,RN);
        SumR(1,RN+1) = exp(outputExt(row,RN+3));
    elseif outputExt(row,RN+3)>MaxLL
        MaxLL = outputExt(row,RN+3);
        MaxID = row;
        MaxR = reshape(outputExt(row,3:(RN+3)),1,RN+1);
        SumR(1,1:RN) = SumR(1:RN) + outputExt(row,3:(RN+2)).*exp(outputExt(row,RN+3));
        SumR(1,RN+1) = SumR(RN+1)+exp(outputExt(row,RN+3));
    end
end

AveR = SumR ./ SumR(RN+1);
save(sprintf('OutputExt%d.mat',np),'outputExt','MaxR','AveR','SumR');

%% plot results

figure(1)
plot(1:ExtN,outputExt(1:ExtN,RN+3))
saveas(figure(1),sprintf('Output%d_Fig1.fig',np));

%% plot comparison graphs
tspan = linspace(0,149,150); % time span is 0~149 min, modified 220128
load('plotrangeCDC42.mat') % modified 220128
load('expvalueCDC42.mat')% modified 220128

%% plot fig2

figure(2)
y0 = zeros(32,1); % initial amounts of each component are zero
r = AveR(1:RN);
Yave = RtoODE_ModelCE(r,tspan,y0,expvalue125); % modified 220128
for i=1:12 % modified 220128
    subplot(6,2,i) % modified 220128
    temp = plotrange(i,2):plotrange(i,3);
    plot(expvalue125(temp,2),expvalue125(temp,3),'b-',expvalue125(temp,2),Yave(temp),'r--')
    legend('True','Fit','Location','best')
    title(['Yave, y(',num2str(plotrange(i,1)),')'])
end
saveas(figure(2),sprintf('Output%d_Fig2.fig',np));

%% plot fig3

figure(3)
y0 = zeros(32,1); % initial amounts of each component are zero
r = MaxR(1:RN);
Ymax = RtoODE_ModelCE(r,tspan,y0,expvalue125);
for i=1:12 % modified 220128
    subplot(6,2,i) % modified 220128
    temp = plotrange(i,2):plotrange(i,3);
    plot(expvalue125(temp,2),expvalue125(temp,3),'b-',expvalue125(temp,2),Ymax(temp),'r--')
    legend('True','Fit','Location','best')
    title(['Ymax, y(',num2str(plotrange(i,1)),')'])
end
saveas(figure(3),sprintf('Output%d_Fig3.fig',np));

%% plot fig4

figure(4)
y0 = zeros(32,1); % initial amounts of each component are zero
load('Output.mat')
r = output;
Yini = RtoODE_ModelCE(r,tspan,y0,expvalue125); % modified 220128
for i=1:12 % modified 220128
    subplot(6,2,i) % modified 220128
    temp = plotrange(i,2):plotrange(i,3);
    plot(expvalue125(temp,2),expvalue125(temp,3),'b-',expvalue125(temp,2),Yini(temp),'r--')
    legend('True','Fit','Location','best')
    title(['Yini, y(',num2str(plotrange(i,1)),')'])
end
saveas(figure(4),sprintf('Output%d_Fig4.fig',np));
