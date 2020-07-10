function data = trading_algo(pair,m, data)

  for i = 1 : length(pair)
    offsetstart = - 60 - (datetime- datetime('today'));
    datestart = datetime + offsetstart;
    startval = num2str(round(posixtime(datestart)) + 1);
    dateend = datetime;
    endval = num2str(round(posixtime(dateend) + 1));

    a = PoloniexApi;
    % a.key = key;
    % a.private = signature;
    a = SetCommand(a,'returnChartData',pair{i},startval, endval, '300');
    [output,extras] = CallApi(a)
    store = matlab.internal.webservices.fromJSON(output);

    data.(pair{i}).Date = datetime(cell2mat({store.date})','ConvertFrom','posixtime');
    data.(pair{i}).HighPrices = cell2mat({store.high})';
    data.(pair{i}).LowPrices = cell2mat({store.low})';
    %     data.(pair{i}).OpenPrices = cell2mat({store.open})';
    %     data.(pair{i}).ClosePrices = cell2mat({store.close})';
    %     data.(pair{i}).volume = cell2mat({store.volume})';
    %     data.(pair{i}).quoteVolume = cell2mat({store.quoteVolume})';
    %     data.(pair{i}).weightedAverage = cell2mat({store.weightedAverage})';

    len = length(data.(pair{i}).Date);

      m = data.(pair{i}).bestvalue;
      move = 86400/300 * m  ;

      data.(pair{i}).MiddlePrices = (data.(pair{i}).HighPrices + data.(pair{i}).LowPrices)/2;
      % data.(pair{i}).DecisionPricesHigh = smooth(data.(pair{i}).MiddlePrices, move,'moving');
      data.(pair{i}).DecisionPricesHigh = mysmooth(data.(pair{i}).MiddlePrices,move,'max');
      data.(pair{i}).DecisionPricesLow = mysmooth(data.(pair{i}).MiddlePrices,move,'min');

      target = strsplit(pair{1},'_')
      bankjson = a.SetCommand('returnBalances');
      bankref = matlab.internal.webservices.fromJSON(bankjson).(target(1));
      banktar = matlab.internal.webservices.fromJSON(bankjson).(target(2));

      trade = 0;
      k = 1;
      idx(1:3 + move-1) = 0;
      for j = 3 + move : len
        minus2 = data.(pair{i}).DecisionPricesLow(j-2);
        minus1 = data.(pair{i}).DecisionPricesLow(j-1);
        minus0 = data.(pair{i}).DecisionPricesLow(j);
        maxus2 = data.(pair{i}).DecisionPricesHigh(j-2);
        maxus1 = data.(pair{i}).DecisionPricesHigh(j-1);
        maxus0 = data.(pair{i}).DecisionPricesHigh(j);
        if (minus2 >= minus1 && minus1 < minus0 && trade == 0);
          trade = 1;
          value = data.(pair{i}).HighPrices(j);
          quant = bank(k)*(1-fee)/value;
          k = k + 1;
          bank(k) = 0;
          idx(j) = value;
        elseif (minus2 <= minus1 && minus1 > minus0 && trade == 1);
          k = k + 1;
          trade = 0;
          value = data.(pair{i}).LowPrices(j);
          bank(k) = quant*(1-fee)*value;
          quant = 0;
          idx(j) = value;
        else
          idx(j) = 0 ;
        end
      maxbank(m) = bank(end) + ank(k) = quant*(1-fee)*value;
    end

end
