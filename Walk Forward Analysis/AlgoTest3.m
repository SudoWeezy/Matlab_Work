function [B0, results] = AlgoTest2(splitdata, i, endPeriod)

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

    %% Try parameters on WFA
    sample = 42;
    alpha = 0;
    width = 2;
    offset = 2;
    %%
    bwsample = offset:24;
    for nbtrade = 1:length(bwsample)
       [resdata(nbtrade),B0data(nbtrade,:)]= trading(bwsample(nbtrade),wa,hp,lp,alpha,width);
       
    end
    idx = unique(find(resdata == max(resdata)));
    results = resdata(idx);
    B0 = B0data(idx,:);
end
function [maxres, B0] = trading(sample,wa,hp,lp,alpha,width);
    %% Set data length
    leng = length(wa);
%     [Movavgvcp, UpperBandcp, LowerBandcp] = bolling(cp, sample, alpha,width);
    [Movavgvlp, UpperBandlp, LowerBandlp] = bolling(lp, sample, alpha,width);
    [Movavgvhp, UpperBandhp, LowerBandhp] = bolling(hp, sample, alpha,width);
%     [Movavgvop, UpperBandop, LowerBandop] = bolling(op, sample, alpha,width);
%     [Movavgvwa, UpperBandwa, LowerBandwa] = bolling(wa, sample, alpha,width);
    %% Offset initiale value
    offset = zeros(sample,1);
    Movavgv = [offset;Movavgvhp];
%     UpperBand = [offset;UpperBandlp];
    LowerBand = [offset;Movavgvlp];
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
    results = tabbank(j) - 1000;
    maxres = unique(max((results)));
    B0 = [sample,alpha,width];
end
