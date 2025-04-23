% based on TanakaMCMCVIIb210611.m

load('Output.mat') % load initial values of r parameters as 'output'
load('expvalueCDC42.mat')

rinit = output;
sr = size(rinit,1);

y0 = zeros(32,1); % initial amounts of each component are zero
tspan = linspace(0,149,150); % time span is 0~149 hr NEW 220120!!!
STEP = 100000; % MCMC step number
%STEP = 100; % MCMC step number
NP = 6; % parallel computing

parfor np=1:NP
    outputPre = zeros(STEP,sr+6);
    outputPost = zeros(STEP,sr+6);
    rndtemp = randn(STEP,sr); % random number of normal distribution
    rntemp = rand(STEP,1); % random number between 0-1
    MCMCpositive = 0;

    for st = 1:STEP
        %MESSAGE = ['np= ',num2str(np),'step= ',num2str(st),' started.'];
        %disp(MESSAGE);
        % set R
        if st == 1
            r = rinit;
        else
            parloadMCMC(sprintf('MCMC_outputPost%d.mat',np));
            parloadMCMC(sprintf('MCMC_preLL%d.mat',np));
            parloadMCMC(sprintf('MCMC_preR%d.mat',np));
            r = reshape(outputPost(st-1,3:sr+2),sr,1);
            LL = outputPost(st-1,sr+3);
            preR = r;
            preLL = LL;
            %MESSAGE = ['np= ',num2str(np),' step= ',num2str(st),' preLL= ',num2str(preLL)];
            %disp(MESSAGE);
            parsaveMCMCpreLL(sprintf('MCMC_preLL%d.mat',np),preLL);
            parsaveMCMCpreR(sprintf('MCMC_preR%d.mat',np),preR);
            fold = reshape(exp(rndtemp(st,:)./100),sr,1);
            r = r.*fold;
        end
               
        % solve ODEs
        [t,y] = ode45(@(t,y) diffunModel_CF26(t,y,r), tspan, y0);

        % compare with experimental value
        expN = size(expvalue125,1);
        LL = 0;
        counter = 0;
        for row = 1:expN
            tt = expvalue125(row,2)+1; % time span is 0~24 min
            mm = expvalue125(row,1);
            S = (y(tt,mm) - expvalue125(row,3)).^2;
            LL = LL - 0.5.*(log(2.*pi.*expvalue125(row,4))+(S./expvalue125(row,4)));
            counter = counter +1;
        end
        %MESSAGE = ['np= ',num2str(np),' step= ',num2str(st),' LL= ',num2str(LL)];
        %disp(MESSAGE);

        %output
        outputPre(st,1)=np;
        outputPre(st,2)=st;
        for i=1:sr
            outputPre(st,i+2)=r(i);
        end
        outputPre(st,sr+3)=LL;      
        % judgement
        if st>1
            parloadMCMC(sprintf('MCMC_preLL%d.mat',np));
            parloadMCMC(sprintf('MCMC_preR%d.mat',np));
            MESSAGE = ['np= ',num2str(np),' step= ',num2str(st),...
            ' LL= ',num2str(LL),' preLL=', num2str(preLL)];
            disp(MESSAGE);
            if LL < preLL
                outputPre(st,sr+4)=exp(LL)/exp(preLL);
                outputPost(st,sr+4)=exp(LL)/exp(preLL);
                outputPre(st,sr+5)=rntemp(st);
                outputPost(st,sr+5)=rntemp(st);
                if isnan(exp(LL)/exp(preLL))==1 || (rntemp(st) > exp(LL)/exp(preLL))
                    decision = 1; % LL did not improve, and r remains
                    rold = r;
                    r = preR;
                    LL = preLL;
                else
                    decision = 2; % LL did not improve but r will be changed
                    MESSAGE = ['np ',num2str(np),'step ',num2str(st),': MCMC invert, preLL= ',...
                        num2str(preLL),'postLL= ',num2str(LL),'r= ',...
                        num2str(rntemp(st)),'TH= ',num2str(exp(LL)/exp(preLL))];
                    disp(MESSAGE);
                end
            else 
                outputPre(st,sr+4)=1;
                outputPost(st,sr+4)=1;
                decision = 3; % LL improved and r will be changed
                MESSAGE = ['np ',num2str(np),'step ',num2str(st),': MCMC positive, preLL= ',...
                    num2str(preLL),'postLL= ',num2str(LL)];
                disp(MESSAGE);
                MCMCpositive = MCMCpositive +1;
            end
        else % st=1
            decision = 1;
            preR = r;
            preLL = LL;
            parsaveMCMCpreLL(sprintf('MCMC_preLL%d.mat',np),preLL);
            parsaveMCMCpreR(sprintf('MCMC_preR%d.mat',np),preR);
        end
        %output
        outputPre(st,sr+6)=decision;

        outputPost(st,1)=np;
        outputPost(st,2)=st;
        for i=1:sr
            outputPost(st,i+2)=r(i);
        end
        outputPost(st,sr+3)=LL;      
        outputPost(st,sr+6)=decision;        
        %parsaveMCMC(sprintf('MCMC_output%d.mat',np),'output2','rndtemp','rntemp','MCMCpositive');
        parsaveMCMCoutPre(sprintf('MCMC_outputPre%d.mat',np),outputPre);
        parsaveMCMCoutPost(sprintf('MCMC_outputPost%d.mat',np),outputPost);
        %MESSAGE = ['np= ',num2str(np),'step= ',num2str(st),' reached'];
        %disp(MESSAGE);
        
    end
end