function [results, B0] = trading(sample,wa,hp,lp,alpha,width);
    %% Set data length
    leng = length(wa);
%     [Movavgvcp, UpperBandcp, LowerBandcp] = bolling(cp, sample, alpha,width);

    [Movavgvlp, UpperBandlp, LowerBandlp] = bolling(lp, sample, alpha,width);
    [Movavgvhp, UpperBandhp, LowerBandhp] = bolling(hp, sample, alpha,width);
%     [Movavgvop, UpperBandop, LowerBandop] = bolling(op, sample, alpha,width);
%     [Movavgvwa, UpperBandwa, LowerBandwa] = bolling(wa, sample, alpha,width);
    %% Offset initiale value
    offset = zeros(sample,1);
    %Movavgv = [offset;Movavgvhp];
    UpperBand = [offset;UpperBandlp];
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
        elseif ((lp(j) > UpperBand(j) || j == leng) && buy == 1)
            buy = 0;
            bank = bank + amount * hp(j) * (1-fee);
            idxsell = [idxsell j];
        end
        tabbank(j) = bank;
    end
    results = tabbank(j) - 1000;

    B0 = [sample,alpha,width];
end
