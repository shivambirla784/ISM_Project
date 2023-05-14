function Results = CIRestimation(Model) 
    % Initial parameters using OLS
    Nobs = length(Model.Data);
    x = Model.Data(1:end-1);%Time series of interest rates observations
    dx = diff(Model.Data);           
    dx = dx./x.^0.5;
    regressors = [Model.TimeStep./x.^0.5, Model.TimeStep*x.^0.5];
    drift = regressors\dx;% OLS regressors coefficients estimates
    res = regressors*drift - dx;
    alpha = -drift(2);
    mu = -drift(1)/drift(2);
    sigma = sqrt(var(res, 1)/Model.TimeStep);
    InitialParams = [alpha mu sigma];% Vector of initial parameters
    if ~isfield(Model, 'Disp'), Model.Disp = 'y'; end
    if strcmp(Model.Disp, 'y')
        fprintf('\n initial alpha = %+3.6f\n initial mu    = %+3.6f\n initial sigma = %+3.6f\n', alpha, mu, sigma);
    end

    % Optimization using fminsearch
    if ~isfield(Model, 'MatlabDisp'), Model.MatlabDisp = 'off'; end
    options = optimset('LargeScale', 'off', 'MaxIter', 300, 'MaxFunEvals', 300, 'Display', Model.MatlabDisp, 'TolFun', 1e-4, 'TolX', 1e-4, 'TolCon', 1e-4); 
    if ~isfield(Model, 'Method'), Model.Method = 'besseli'; end
    if strcmp(Model.Method, 'besseli')
        [Params, Fval, Exitflag] =  fminsearch(@(Params) CIRobjective1(Params, Model), InitialParams, options);   
    end

    Results.Params = Params;
    Results.Fval = -Fval/Nobs;
    Results.Exitflag = Exitflag;

    if strcmp(Model.Disp, 'y')
        fprintf('\n alpha = %+3.6f\n mu    = %+3.6f\n sigma = %+3.6f\n', Params(1), Params(2), Params(3));
        fprintf(' log-likelihood = %+3.6f\n', -Fval/Nobs);
    end
end

