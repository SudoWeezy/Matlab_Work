function [sample, alpha, width,result] = Algo(splitdata, i, endPeriod)
    %% Try parameters on WFA
    sample = 42;
    alpha = 0;
    width = 1;
    %% Store data value
    hp = [];
    lp = [];
    op = [];
    cp = [];
    vol = [];
    qvol = [];
    wa = [];
    for ii = i+1: endPeriod
    hp = [hp;splitdata.HighPrices{ii}];
    lp = [lp;splitdata.LowPrices{ii}];
    op = [op;splitdata.OpenPrices{ii}];
    cp = [cp;splitdata.ClosePrices{ii}];
    vol = [vol;splitdata.volume{ii}];
    qvol = [qvol;splitdata.quoteVolume{ii}];
    wa = [wa;splitdata.weightedAverage{ii}];
    end

    %% Set data length
    leng = length(wa);
    [Movavgv, UpperBand, LowerBand] = bolling(cp, sample, alpha,width);
    %% Offset initiale value
    offset = zeros(sample,1);
    Movavgv = [offset;Movavgv];
    UpperBand = [offset;UpperBand];
    LowerBand = [offset;LowerBand];
    %% Simulate trading WFA
    buy = 0; % Nothing in the portfolio
    bank = 1000; % Start with 1000 USD
    bankRisk = 0.5; % trade with 50% of the bank
    fee = 0.0015; % Poloniex fee taker 0.25%
    amount = 0;
    idxbuy = [];
    idxsell = [];
    tabbank = [];
    for j = sample : leng
        if hp(j) < LowerBand(j) && buy == 0
            buy = 1;
            amount = bank * bankRisk * (1-fee)/lp(j);
            idxbuy = [idxbuy j];
            bank = bank - (bank * bankRisk);
        elseif ((lp(j) > Movavgv(j) || j == leng) && buy == 1)
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
%     stem(idxbuy,hp(idxbuy))
%     stem(idxsell,lp(idxsell))
%     legend('hp','lp','Movavgv','UpperBand','LowerBand','buy','sell')
%     
     figure
     plot(tabbank)
    result = tabbank(j) - 1000;
end
