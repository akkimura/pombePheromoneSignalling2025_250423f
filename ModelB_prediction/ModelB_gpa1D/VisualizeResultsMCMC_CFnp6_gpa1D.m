% VisualizeResultsMCMC_CA.m
% created on Jan 28, 2022, based on VisualizeResultsMCMC_NNNW.m

y0 = zeros(32,1); % initial amounts of each component are zero
tspan = linspace(0,149,150); % time span is 0~149 min, modified 220128

% load or define r
np=6;
RN=26;
load input.mat; %'outputExt','MaxR','AveR','SumR'

[T1 Y1] = ode45(@(t,y)diffunModel_CF26_gpa1D(t,y,r),tspan,y0);

load('expvalueCDC42.mat')
load('plotrangeCDC42.mat')
molecule = [1 8 14 20 25 ...
    2 9 15 21 26 ...
    3 0 16 0 27 ...
    4 10 17 22 0 ...
    5 11 0 0 28 ...
    6 12 18 23 29 ...
    7 13 19 24 30];
%j1 = molecule(26:35); %commented out 220128
%j2 = reshape(j1,5,2); %commented out 220128
%j3 = j2.'; %commented out 220128
%j4 = reshape(j3,1,10); %commented out 220128

figure
for i = 1:35 % position of the plot
    subplot(7,5,i)
    k = molecule(i); % molecule
    if k~=0
        %if i<31
            plot(T1,Y1(:,k),'r-')
            xline(100);
        %else
        %    jj = j4(i-30);
        %    temp = plotrange(jj,2):plotrange(jj,3);
        %    plot(expvalue(temp,2),expvalue(temp,3),'b-',T1,Y1(:,k),'r--')
        %    legend('True','Fit','Location','best')
        %end
        title(['y(',num2str(k),')'])
    end
end