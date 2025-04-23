function simvalue = RtoODE_ModelCF(r,tspan,y0,expvalue125)
sol = ode45(@(t,y)diffunModel_CF26(t,y,r),tspan,y0);
solpts = deval(sol,tspan);
rn = size(expvalue125,1);
simvalue = zeros(rn,1);
    for r = 1:rn
    simvalue(r) = solpts(expvalue125(r,1),expvalue125(r,2)+1);
    end
end