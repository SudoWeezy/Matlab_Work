function table = simultrade(table,triggerBuy,triggerSell,i)

        fnusdt = table.fnusdtidx;
        hp = table.(fnusdt{i}).lowestAsk;
        lp = table.(fnusdt{i}).highestBid;
    if triggerBuy == 1 && table.(fnusdt{i}).bank == 0
        table.(fnusdt{i}).bank = table.(fnusdt{i}).bankallowed * (1-0.0015)/hp(end);
        table.(fnusdt{i}).bankallowed = 0;
        disp(['buy' fnusdt{i} num2str(hp(end))])
    elseif triggerSell == 1 && table.(fnusdt{i}).bankallowed == 0
        table.(fnusdt{i}).bankallowed = table.(fnusdt{i}).bank * (1-0.0015)*lp(end);
        table.(fnusdt{i}).bank = 0;
        disp(['sell' fnusdt{i} num2str(lp(end))])
    end     
end