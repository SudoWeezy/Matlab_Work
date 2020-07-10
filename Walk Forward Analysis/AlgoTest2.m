function [B0,result] = AlgoTest2(splitdata, i, endPeriod)
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
    botTrigger = -0.001;
    topTrigger = 0.001;
    B0 = [botTrigger,topTrigger];
    %% Set up bandwitdh
    bwtopTrigger = 0.001:0.001:0.1;
    bwbotTrigger = -0.001:-0.001:-0.1;
    lbwbT = length(bwbotTrigger);
    lbwtT = length(bwtopTrigger);
    bw = [bwbotTrigger bwtopTrigger];
    lbw = length(bw);
    l1 = lbwbT;
    l2 = (lbwbT + lbwtT);
    %% Create diff array
    curve = cp;
    tmpcp = (curve(2:end)- curve(1:end-1))./curve(2:end);
    offset = zeros(1,1);
    tmpcp = [offset;tmpcp];
    %% Find better B;
    for k = 1 : lbw
        if k <= l1
            botTrigger = bw(k);
            topTrigger = bw(k+l1);
        elseif k > l1 && k <= l2
            botTrigger = bw(k-l1);
            topTrigger = bw(k);
        end
        if botTrigger ~= - topTrigger
            return
        end

        %% Simulate trading
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
                amount = bank * bankRisk * (1-fee)/hp(j);
                idxbuy = [idxbuy j];
                bank = bank - (bank * bankRisk);
            elseif ((tmpcp(j) > topTrigger || j == leng) && buy == 1)
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
%     subplot(2,1,1);
%     hold on
%     plot(bw(1:l1),params(1:l1))
%     xlabel('Bot');
%     ylabel('Final bank');
%     subplot(2,1,2);
%     hold on
%     plot(bw(l1+1:l2),params(l1+1:l2))
%     xlabel('Top');
%     ylabel('Final bank');
    %% Collect better params
    idbotTrigger = find(params(1:l1) == max(params(1:l1)));
    botTrigger = bwbotTrigger(idbotTrigger(1));
    
    idtopTrigger = find(params(l1+1:l2) == max(params(l1+1:l2)));
    topTrigger = bwtopTrigger(idtopTrigger(1));   
    B0 = [botTrigger topTrigger];
    %% Simulate trading
    buy = 0; % Nothing in the portfolio
    bank = 1000; % Start with 1000 USD
    bankRisk = 0.5; % trade with 50% of the bank
    fee = 0.0015; % Poloniex fee taker 0.25%
    amount = 0;
    idxbuy = [];
    idxsell = [];
    for j = 2 : leng
            if tmpcp(j) < botTrigger && buy == 0
                buy = 1;
                amount = bank * bankRisk * (1-fee)/hp(j);
                idxbuy = [idxbuy j];
                bank = bank - (bank * bankRisk);
            elseif ((tmpcp(j) > topTrigger || j == leng) && buy == 1)
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
%      plot(cp)
%     plot(Movavgv)
%     plot(UpperBand)
%     plot(LowerBand)
%      stem(idxbuy,hp(idxbuy))
%      stem(idxsell,lp(idxsell))
%      legend('cp','buy','sell')
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
    curve = cp;
    tmpcp = (curve(2:end)- curve(1:end-1))./curve(2:end);
    %% Offset initiale value
    offset = zeros(1,1);
    tmpcp = [offset;tmpcp];
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
                amount = bank * bankRisk * (1-fee)/hp(j);
                idxbuy = [idxbuy j];
                bank = bank - (bank * bankRisk);
            elseif ((tmpcp(j) > topTrigger || j == leng) && buy == 1)
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
%     figure
%     plot(tabbank)
    result = tabbank(j) - 1000;
end
