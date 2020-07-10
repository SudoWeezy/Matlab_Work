function [sample,alpha,width,value] = buildmodel(splitdata)

    %% Store data value

    hp = [splitdata.high];
    lp = [splitdata.low];
    op = [splitdata.open];
    cp = [splitdata.close];
    vol = [splitdata.volume];
    qvol = [splitdata.quoteVolume];
    wa = [splitdata.weightedAverage];


    %% Try parameters on WFA
    alpha = 0;
    width = 2;
    offset = 2;
    %%
    bwsample = offset:46;
    for nbtrade = 1:length(bwsample)
       [resdata(nbtrade),B0data(nbtrade,:)]= trading(bwsample(nbtrade),wa,hp,lp,alpha,width);

    end
    idx = unique(find(resdata == max(resdata)));
    sample = offset + idx(1);
    value = trading(sample,wa,hp,lp,alpha,width)
end
