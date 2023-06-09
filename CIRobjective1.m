function lnL = CIRobjective1(Params, Model)
    Data = Model.Data;
    DataF = Data(2:end);
    DataL = Data(1:end-1);
    Nobs = length(Data);
    TimeStep = Model.TimeStep;
    alpha = Params(1);
    mu = Params(2);
    sigma = Params(3);

    c = 2*alpha/(sigma^2*(1-exp(-alpha*TimeStep)));
    q = 2*alpha*mu/sigma^2-1;
    u = c*exp(-alpha*TimeStep)*DataL;
    v = c*DataF;
    z = 2*sqrt(u.*v);     
    bf = besseli(q,z,1);    
    lnL= -(Nobs-1)*log(c) + sum(u + v - 0.5*q*log(v./u) - log(bf) - z);
end

