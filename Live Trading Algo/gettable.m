function [table, store] = gettable(store, table, step, ticker)

    banktotal = 0;
    [output,extras] = CallApi(ticker);
    if extras == 0
        output
      disp('Connection error')
    else
      store = jsondecode(output);
%        disp('Get ticker ok');
    end

    fnusdt = table.fnusdtidx;
    for i =  1 :  table.lenghtfnusdt
        table.(fnusdt{i}).last = [table.(fnusdt{i}).last str2num(store.(fnusdt{i}).last)];
        table.(fnusdt{i}).lowestAsk = [table.(fnusdt{i}).lowestAsk str2num(store.(fnusdt{i}).lowestAsk)];
        table.(fnusdt{i}).highestBid = [table.(fnusdt{i}).highestBid str2num(store.(fnusdt{i}).highestBid)];
        if length(table.(fnusdt{i}).last) >step
            table.(fnusdt{i}).last = table.(fnusdt{i}).last(end-step+1:end);
            table.(fnusdt{i}).lowestAsk = table.(fnusdt{i}).lowestAsk(end-step+1:end);
            table.(fnusdt{i}).highestBid = table.(fnusdt{i}).highestBid(end-step+1:end);
            

            hp = table.(fnusdt{i}).lowestAsk;
            lp = table.(fnusdt{i}).highestBid;
            
            sample=step;
            [Movavgvlp, UpperBandlp, LowerBandlp] = bolling(lp,sample); %,alpha,width)
            [Movavgvhp, UpperBandhp, LowerBandhp] = bolling(hp,sample);

            triggerBuy = Movavgvlp(end)>hp(end);
            triggerSell = UpperBandlp(end)<lp(end);
            
            table = simultrade(table,triggerBuy,triggerSell,i);
            
        end
        banktotal = banktotal + table.(fnusdt{i}).bank*table.(fnusdt{i}).highestBid(end) + table.(fnusdt{i}).bankallowed;
    end

    table.banktotal = banktotal;
end