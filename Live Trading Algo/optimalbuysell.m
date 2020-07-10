function [output,extras] = optimalbuysell(PoloniexApi,pair, qty, bs)
  % returnOpenOrders
  % moveOrder
  %bs = 1 buy, bs = 0 sell.
  a = PoloniexApi;
  a = SetCommand(a,'returnOrderBook',pair,10);
  [output,extras] = CallApi(a);

  if extras == 0
     disp('Connection error')
     return
  end
  store = jsondecode(output);
  if bs == 1
    i = 1;
    while 1
       %% get max buy value
       bids = store.bids{i}
       [tok1,tok2] = strtok(bids{1,1},'.');
       offset = 10^-(length(tok2)-1);
       bids{1,1} = str2num(bids{1,1});
       %% get related ref quantity
       qtyPolo = bids{2,1} * bids{1,1};
       if qtyPolo < qty
         break;
       end
       i = i + 1;
    end
    rate = bids{1,1} + offset;
    amount = qty/rate;
    a = SetCommmand(a,'buy',pair,rate, amount,PostOnly);
    [output,extras] = CallApi(a);
    if extras == 0
       disp(['Connection error during buying' pair])
       return
    end
  elseif bs == 0
    i = 1;
    while 1
       %% get max buy value
       ask = store.ask{i}
       [tok1,tok2] = strtok(ask{1,1},'.');
       offset = 10^-(length(tok2)-1);
       ask{1,1} = str2num(ask{1,1});
       %% get related ref quantity
       qtyPolo = ask{2,1} * ask{1,1};
       if qtyPolo < qty
         break;
       end
       i = i + 1;
    end
    rate = ask{1,1} - offset;
    amount = qty/rate;
    a = SetCommmand(a,'sell',pair,rate, amount,PostOnly);
    [output,extras] = CallApi(a);
    if extras == 0
       disp(['Connection error during selling' pair])
       return
    end
  end
end
