function [sample, alpha, width,result] = AlgoTest(splitdata, i, endPeriod)
    %% Store data value
    hp = splitdata.HighPrices{i};
    lp = splitdata.LowPrices{i};
    op = splitdata.OpenPrices{i};
    cp = splitdata.ClosePrices{i};
    vol = splitdata.volume{i};
    qvol = splitdata.quoteVolume{i};
    wa = splitdata.weightedAverage{i};
    %% Set data length
    leng = length(wa);
    %% Set up B0
    sample = 120; % Number of samples to use in computing the moving average = one day
    alpha = 0; %Exponent used to compute the element weights of the moving average. Default = 0 (simple moving average)
    width = 2; %Number of standard deviations to include in the envelope. 
               %A multiplicative factor specifying how tight the bands should be around the simple moving average. Default = 2
    B0 = [sample,alpha,width];
    %% Set up bandwitdh
    bwsample = 2:480;
    bwalpha = 0:0.1:10;
    bwwidth = 0.1:0.1:10;
    lbws = length(bwsample);
    lbwa = length(bwalpha);
    lbww = length(bwwidth);
    bw = [bwsample bwalpha bwwidth];
    lbw = length(bw);
    l1 = lbws;
    l2 = (lbwa + lbws);
    l3 = (lbwa + lbws + lbww);
    %% Find better B;
    for k = 1 : lbw
        if k <= l1
            sample = bw(k);
            alpha = B0(2);
            width = B0(3);
        elseif k > lbws && k <= l2
            sample = B0(1);
            alpha = bw(k);
            width = B0(3);
        elseif k > (lbwa + lbws) && k <= l3
            sample = B0(1);
            alpha = B0(2);
            width = bw(k);
        end
        %% Create bollinger band
        [Movavgv, UpperBand, LowerBand] = bolling(cp, sample, alpha,width);
        %% Offset initiale value
        offset = zeros(sample,1);
        Movavgv = [offset;Movavgv];
        UpperBand = [offset;UpperBand];
        LowerBand = [offset;LowerBand];
        %% Simulate trading
        buy = 0; % Nothing in the portfolio
        bank = 1000; % Start with 1000 USD
        bankRisk = 0.5; % trade with 50% of the bank
        fee = 0.0025; % Poloniex fee taker 0.25%
        amount = 0;
        idxbuy = [];
        idxsell = [];
        tabbank = [];
        for j = sample : leng
            if hp(j) < LowerBand(j) && buy == 0
                buy = 1;
                amount = bank * bankRisk * (1-fee)/hp(j);
                idxbuy = [idxbuy j];
                bank = bank - (bank * bankRisk);
            elseif ((lp(j) > Movavgv(j) || j == leng) && buy == 1)
                buy = 0;
                bank = bank + amount * lp(j) * (1-fee);
                idxsell = [idxsell j];
            end
            tabbank(j) = bank;
        end
    params(k) = tabbank(leng);
    end
    %% Plot params
%     figure
%     subplot(3,1,1);
%     hold on
%     plot(params(1:l1))
%     xlabel('Sample');
%     ylabel('Final bank');
%     subplot(3,1,2);
%     hold on
%     plot(params(l1:l2))
%     xlabel('alpha');
%     ylabel('Final bank');
%     subplot(3,1,3);
%     hold on
%     plot(params(l2:l3))
%     xlabel('width');
%     ylabel('Final bank');
%     
    %% Collect better params
    idsample = find(params(1:l1) == max(params(1:l1)));
    sample = bwsample(idsample(1));
    
    idalpha = find(params(l1+1:l2) == max(params(l1+1:l2)));
    alpha = bwalpha(idalpha(1));
    
    idwidth = find(params(l2+1:l3) == max(params(l2+1:l3)));
    width = bwwidth(idwidth(1));
    
    %% Create bollinger band
    [Movavgv, UpperBand, LowerBand] = bolling(cp, sample, alpha,width);
    %% Offset initiale value
    offset = zeros(sample,1);
    Movavgv = [offset;Movavgv];
    UpperBand = [offset;UpperBand];
    LowerBand = [offset;LowerBand];
    %% Simulate trading
    buy = 0; % Nothing in the portfolio
    bank = 1000; % Start with 1000 USD
    bankRisk = 0.5; % trade with 50% of the bank
    fee = 0.0025; % Poloniex fee taker 0.25%
    amount = 0;
    idxbuy = [];
    idxsell = [];
    for j = sample : leng
        if hp(j) < LowerBand(j) && buy == 0
            buy = 1;
            amount = bank * bankRisk * (1-fee)/hp(j);
            idxbuy = [idxbuy j];
            bank = bank - (bank * bankRisk);
        elseif ((lp(j) > Movavgv(j) || j == leng) && buy == 1)
            buy = 0;
            bank = bank + amount * lp(j) * (1-fee);
            idxsell = [idxsell j];
        end
        tabbank(j) = bank;
    end
    %% Plot result Best perdiod parameter
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
%     figure
%     plot(tabbank)
    %% Try parameters on WFA
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
    fee = 0.0025; % Poloniex fee taker 0.25%
    amount = 0;
    idxbuy = [];
    idxsell = [];
    tabbank = [];
    for j = sample : leng
        if hp(j) < LowerBand(j) && buy == 0
            buy = 1;
            amount = bank * bankRisk * (1-fee)/hp(j);
            idxbuy = [idxbuy j];
            bank = bank - (bank * bankRisk);
        elseif ((lp(j) > Movavgv(j) || j == leng) && buy == 1)
            buy = 0;
            bank = bank + amount * lp(j) * (1-fee);
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
