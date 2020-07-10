if exist('livetrading') 
    stop(livetrading);
    delete(livetrading);
    clear('livetrading');
    disp('delete livetrading')
end
clear all
table = [];
table.bank = 100;
ticker = PoloniexApi;
ticker = SetCommand(ticker,'returnTicker');
step = 3600*24;

[output,extras] = CallApi(ticker);
if extras == 0
    output
    disp('Connection error')
else
    store = jsondecode(output);
end
bankinit = 100;

if ~isfield(table,'fnusdt')
    fn = fieldnames(store);
    usdtidx = contains(fn,'USDT_');
    fnusdt = fn(usdtidx);
end
table.fnusdtidx = fnusdt;
table.lenghtfnusdt = length(fnusdt);
for i =  1 :  length(fnusdt)
    table.(fnusdt{i}).last = [];
        table.(fnusdt{i}).lowestAsk = [];
        table.(fnusdt{i}).highestBid = [];
        table.(fnusdt{i}).bankallowed = bankinit/length(fnusdt);
        table.(fnusdt{i}).bank = 0;
end
livetrading = timer('ExecutionMode','fixedRate','TimerFcn','[table ,store] = gettable(store, table, step, ticker);','Period',1);
start(livetrading);







