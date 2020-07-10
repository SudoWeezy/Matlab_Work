%% Set path
addpath(genpath(pwd));

%% clear all
clear all
close all
%% Set parameter
stepValue = 300;
testPeriod = 1;
pair = {'USDT_BTC';'USDT_ETH';'USDT_LTC';'USDT_ETC';'USDT_XRP';'USDT_ZEC';'USDT_DASH';'USDT_STR';'USDT_XMR'};
%% Set up date
globalStart = '2016-01-01';
globalEnd = '2017-07-01';

%% Convert to vector
vecglobalStart = datevec(globalStart,'yyyy-mm-dd');
vecglobalEnd = datevec(globalEnd,'yyyy-mm-dd');

%% Number of month between the 2 dates
dif = vecglobalEnd - vecglobalStart;
diftime = 12*dif(1) + dif(2);
clear('vecglobalEnd','vecglobalStart');
%% Convert strdate to datetime
gsdate = datetime(globalStart,'InputFormat','yyyy-MM-dd');
gedate = datetime(globalEnd,'InputFormat','yyyy-MM-dd');

%% Set up step datetime array
datearray = datetime(globalStart) + calmonths(1:diftime);
datearray = [gsdate datearray];
datestrArray = datestr(datearray);

%% Set up step posixtime array
posixarray = posixtime(datearray);

%% Get data
strstepValue = num2str(stepValue);
startval = num2str(posixarray(1));
endval = num2str(posixarray(end));
a = PoloniexApi;
a = SetCommand(a,'returnChartData',pair{1},startval, endval, strstepValue);
[output,extras] = CallApi(a);
if extras == 0
    disp('Connection error')
    return
end
store = matlab.internal.webservices.fromJSON(output);
clear('startval','endval')
%% Store data
data.data.Date = datetime(cell2mat({store.date})','ConvertFrom','posixtime');
data.HighPrices = cell2mat({store.high})';
data.LowPrices = cell2mat({store.low})';
data.OpenPrices = cell2mat({store.open})';
data.ClosePrices = cell2mat({store.close})';
data.volume = cell2mat({store.volume})';
data.quoteVolume = cell2mat({store.quoteVolume})';
data.weightedAverage = cell2mat({store.weightedAverage})';

clear('output','store');

%% Split data
tmpstart = 1;
for i = 1 : diftime
    tmpend = tmpstart + (posixarray(i+1)- posixarray(i))/stepValue;
    x = tmpstart:tmpend;
    splitdata.HighPrices{i} = data.HighPrices(x);
    splitdata.LowPrices{i} = data.LowPrices(x);
    splitdata.OpenPrices{i} = data.OpenPrices(x);
    splitdata.ClosePrices{i} = data.ClosePrices(x);
    splitdata.volume{i} = data.volume(x);
    splitdata.quoteVolume{i} = data.quoteVolume(x);
    splitdata.weightedAverage{i} = data.weightedAverage(x);
    tmpstart = tmpend;
end
clear('x', 'tmpstart', 'tmpend', 'i','a');

%% Moving Plot data + algo test
disp('Parameters');
disp({'stepValue',stepValue;'testPeriod',testPeriod;'globalStart',globalStart;'globalEnd',globalEnd;'pair',pair{1}});

maxPrices = max(data.weightedAverage);
sz = [1,diftime + 1];
form = posixarray;
tx = [form; form]';
ty = [maxPrices, 0];

figure(1)
for i = 1:diftime+1
    plot(tx(i,:),ty,'k')
    hold on;
end
    mainax = gca;
x = form(1):stepValue:form(end);
T = [];
plotdata = plot(x,data.weightedAverage,'b');% replace with candle
for i = 1:diftime-testPeriod
    figure(1)
    yform = [0 maxPrices maxPrices 0];
    xform = [form(i) form(i) form(i+1) form(i+1)];
    current(i) = patch(xform,yform,'r');
    for j = 1:testPeriod
        yform = [0 maxPrices maxPrices 0];
        xform = [form(i+j) form(i+j) form(i+j+1) form(i+j+1)];
        currenttest(j) = patch(xform,yform,'y');
    end
    uistack(plotdata,'top')
    set(mainax,'XTick',form,'XTickLabel',{datestrArray},'FontSize',10);
    pause(0.1)% replace with the testing function
%     [sample, alpha, width,results] = AlgoTest(splitdata, i, i+testPeriod);
%     [sample, alpha, width,results] = Algo(splitdata, i, i+testPeriod);
%     beta(i,1:3) = [sample, alpha, width];
%     [B0,results] = AlgoTest2(splitdata, i, i+testPeriod);
     [B0, results] = AlgoTest3(splitdata, i, i+testPeriod);
    Period = {datestrArray(i,:),datestrArray(i+testPeriod,:)};
    PeriodAlgo = {datestrArray(i,:),datestrArray(i+1,:)};
    PeriodWFA = {datestrArray(i+1,:),datestrArray(i+testPeriod,:)};

      T = [T;table(Period,PeriodAlgo,PeriodWFA, results)];
    delete(current(i))
    for j = 1:testPeriod
        delete(currenttest(j))
    end
end
    disp(T);
clear('maxPrices','sz','tx','ty','yform','xform',...
    'x','form','plotdata','current','currenttest',...
    'i','j','Period','PeriodAlgo','PeriodWFA','T',...
    'Results')
