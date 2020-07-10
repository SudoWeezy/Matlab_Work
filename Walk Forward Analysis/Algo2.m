    i=1;
    endPeriod = 3;
    %% Store data value
    hp = [];
    lp = [];
    op = [];
    cp = [];
    vol = [];
    qvol = [];
    wa = [];

    hp = splitdata.HighPrices{i};
    lp = splitdata.LowPrices{i};
    op = splitdata.OpenPrices{i};
    cp = splitdata.ClosePrices{i};
    vol = splitdata.volume{i};
    qvol = splitdata.quoteVolume{i};
    wa = splitdata.weightedAverage{i};
    
    for ii = i+1:endPeriod %i+1 => 1  endPeriod = 3;
    hp = [hp;splitdata.HighPrices{ii}];
    lp = [lp;splitdata.LowPrices{ii}];
    op = [op;splitdata.OpenPrices{ii}];
    cp = [cp;splitdata.ClosePrices{ii}];
    vol = [vol;splitdata.volume{ii}];
    qvol = [qvol;splitdata.quoteVolume{ii}];
    wa = [wa;splitdata.weightedAverage{ii}];
    end
    %%
    curve = [];
    tmpcp = [];
    curve  =  splitdata.ClosePrices{i};
    tmpcp = (curve(2:end)- curve(1:end-1))./curve(2:end);
    tmpcp = [0;tmpcp];
    plot(tmpcp);
    %%
    botTrigger = -0.02;
    topTrigger = 0.02;
    %%
    leng = length(curve);
    %% Simulate trading WFA
    buy = 0; % Nothing in the portfolio
    bank = 1000; % Start with 1000 USD
    bankRisk = 0.5; % trade with 50% of the bank
    fee = 0.0015; % Poloniex fee taker 0.25%
    amount = 0;
    idxbuy = [];
    idxsell = [];
    tabbank = [];
    for j = 2 : leng
        if tmpcp(j) < botTrigger && buy == 0
            buy = 1;
            amount = bank * bankRisk * (1-fee)/lp(j);
            idxbuy = [idxbuy j];
            bank = bank - (bank * bankRisk);
        elseif ((tmpcp(j) > topTrigger || j == leng) && buy == 1)
            buy = 0;
            bank = bank + amount * hp(j) * (1-fee);
            idxsell = [idxsell j];
        end
        tabbank(j) = bank;
    end
    %% Plot Trading Wfa
%     figure
%     hold on
%     plot(hp)
%     plot(lp)
%     plot(Movavgv)
%     plot(UpperBand)
%     plot(LowerBand)
    hold on;
    plot(curve);
    stem(idxbuy,hp(idxbuy),'r')
    stem(idxsell,lp(idxsell),'k')
    legend('curve','buy','sell')
    
     figure
     plot(tabbank)
    result = tabbank(j) - 1000;


