close all
clear all
addpath(genpath(pwd));

url ='https://poloniex.com/tradingApi';

key = '';
signature = '';

datestart = datetime(2014,1,1,0,0,0);
startval = num2str(round(posixtime(datestart)) + 1);
endval = num2str(round(posixtime(datetime)) + 1);

a = PoloniexApi;
a.key = key;
a.private = signature;
% a = SetCommand(a,'returnTicker');
% [output,extras] = CallApi(a);
% store2 = jsondecode(output);
% fn = fieldnames(store2);
% token = strtok(fn,'_');
% nbidx = strcmp({'USDT'},token);
% idx = find(nbidx ==1 );
%
% for i = 1 : length(idx);
%   name(i)= store2.(fn{idx(i)});
% end

pair = {'USDT_BTC';'USDT_ETH';'USDT_LTC';'USDT_ETC';'USDT_XRP';'USDT_ZEC';'USDT_DASH';'USDT_STR';'USDT_XMR'};

for i  = 1 : length(pair)
a = SetCommand(a,'returnChartData',pair{i},startval, endval, '300');
[output,extras] = CallApi(a);
store = matlab.internal.webservices.fromJSON(output);

data.(pair{i}).Date = datetime(cell2mat({store.date})','ConvertFrom','posixtime');
data.(pair{i}).HighPrices = cell2mat({store.high})';
data.(pair{i}).LowPrices = cell2mat({store.low})';
data.(pair{i}).OpenPrices = cell2mat({store.open})';
data.(pair{i}).ClosePrices = cell2mat({store.close})';
data.(pair{i}).volume = cell2mat({store.volume})';
data.(pair{i}).quoteVolume = cell2mat({store.quoteVolume})';
data.(pair{i}).weightedAverage = cell2mat({store.weightedAverage})';

end
% % candle(HighPrices,LowPrices,ClosePrices,OpenPrices,'r',date,'dd-mmm-yyyy HH:MM')
% k = 1;
% j = 1;
% idx = [];
% idx2 = [];
% bk = 100;
% A = 0;
% for i  =  1 : length(HighPrices)
%   minw = min(HighPrices(k:i));
%   maxw = max(LowPrices(j:i));
%   c1 = 0;
%   c2 = 0;
%   if LowPrices(i) >  1.1*minw && A == 0;
%     A = 1;
%     k=i;
%     c1 = HighPrices(i);
%
%   elseif LowPrices(i) < 0.9*maxw && A == 1;
%     A = 0;
%     j = i;
%     c2 = LowPrices(i);
%   end
%     idx = [idx c1];
%     idx2 = [idx2 c2];
% end
% plot(HighPrices)
% hold on
% plot(LowPrices)
% stem(idx,'r');
% stem(idx2,'k');
% legend('','','buy','sell')
