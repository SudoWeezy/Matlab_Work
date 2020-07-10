launcher
% if exist('livetrading') 
%     stop(livetrading);
%     delete(livetrading);
%     clear('livetrading');
%     disp('delete livetrading')
% end
% if exist('simultrading') 
%     stop(simultrading);
%     delete(simultrading);
%     clear('simultrading');
%     disp('delete simultrading')
% end
clear all
close all

load('model.mat')

if model.enddate + 15 <= datetime('today')
    launcher;
    load('model.mat')
end
livetrading = timer('ExecutionMode','fixedRate','TimerFcn','bollingmodel = livetradeAPI(model)','Period',14400);
start(livetrading);
fieldnamesmodel = fieldnames(bollingmodel);
bank = 1000*ones(length(fieldnamesmodel),1);
buy = zeros(length(fieldnamesmodel),1);
amount = zeros(length(fieldnamesmodel),1);% Nothing in the portfolio
simultrading = timer('ExecutionMode','fixedRate','TimerFcn','[bank,amount,buy] = tradesimulation(bollingmodel,bank,buy,amount);','Period',1);
start(simultrading);