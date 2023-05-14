%%RUN ESTIMATION ROUTINE

clc
clear all
close all

load Pribor3M

Model.Data = Pribor3M;
Model.TimeStep = 1/250;      % recommended: 1/250 for daily data, 1/12 for monthly data, etc
Model.Disp = 'y';           % 'y' | 'n' (default: y)
Model.MatlabDisp = 'iter';  % 'off'|'iter'|'notify'|'final'  (default: off)
Model.Method = 'besseli';   % 'besseli' 

Results = CIRestimation(Model);
