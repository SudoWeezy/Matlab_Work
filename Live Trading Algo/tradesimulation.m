function [bank,amount,buy] = tradesimulation(bollingmodel,bank,buy,amount)
    ticker = PoloniexApi;
    ticker = SetCommand(ticker,'returnTicker');
    [output,extras] = CallApi(ticker);
    if extras == 0
      disp('Connection error during ticker')
      return
    else
      %disp('Get ticker ok')
    end
    store = jsondecode(output);
    fieldnamesmodel = fieldnames(bollingmodel);
    fee = 0.0015;

     % Start with 1000 USD
    bankRisk = 0.5;
    for j = 1 : length(fieldnamesmodel)
       hp = str2num(store.(fieldnamesmodel{j}).highestBid);
       lp = str2num(store.(fieldnamesmodel{j}).lowestAsk);
       LowerBand = bollingmodel.(fieldnamesmodel{j}).movelp(end);%movelp
       UpperBand = bollingmodel.(fieldnamesmodel{j}).lowhp(end);
       if hp < LowerBand && buy(j) == 0
            buy(j) = 1;
            amount(j) = bank(j) * bankRisk * (1-fee)/lp;
            bank(j) = bank(j) - (bank(j) * bankRisk);
            disp(['buy ' fieldnamesmodel{j} num2str(lp)]);
        elseif ((lp > UpperBand) && buy(j) == 1)
            buy(j) = 0;
            bank(j) = bank(j) + amount(j) * hp * (1-fee);
            disp(['sell ' fieldnamesmodel{j} num2str(hp)])
       end
    end
end