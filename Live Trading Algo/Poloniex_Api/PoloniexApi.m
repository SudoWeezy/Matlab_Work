classdef PoloniexApi

  properties (Access = public)
    key;
    private;
  end
  properties (Access = private)
    hmacsign = '';
    command = '';
    body = '';
    calltype = 1; %1 public 0 prive
  end

  methods
    function PoloniexApi = SetCommand(PoloniexApi, cmd, opt1, opt2, opt3, opt4, opt5)
      if ischar(cmd)
        PoloniexApi.command = cmd;
          switch cmd

          case 'returnTicker'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 1;
          case 'return24Volume'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 1;
          case 'returnOrderBook'
            PoloniexApi.body = ['command=' cmd '&currencyPair=' opt1];
            PoloniexApi.calltype = 1;
          case 'returnTradeHistory'
            PoloniexApi.body = ['command=' cmd '&currencyPair=' opt1 '&start=' opt2 '&end=' opt3];
            PoloniexApi.calltype = 1;
          case 'returnChartData'
            PoloniexApi.body = ['command=' cmd '&currencyPair=' opt1 '&start=' opt2 '&end=' opt3 '&period=' opt4];
            PoloniexApi.calltype = 1;
          case 'returnCurrencies'
            PoloniexApi.body = ['command=' cmd '&currency=' opt1];
            PoloniexApi.calltype = 1;
          case 'returnBalances'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 0;
          case 'returnCompleteBalances'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 0;
          case 'returnDepositAddresses'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 0;
          case 'generateNewAddress'
            PoloniexApi.body = ['command=' cmd  '&currency=' opt1];
            PoloniexApi.calltype = 0;
          case 'returnDepositsWithdrawals'
            PoloniexApi.body = ['command=' cmd  '&start=' opt1 '&end=' opt2];
            PoloniexApi.calltype = 0;
          case 'returnOpenOrders'
            PoloniexApi.body = ['command=' cmd  '&currencyPair=' opt1];
            PoloniexApi.calltype = 0;
          case 'returnTradeHistory'
            PoloniexApi.body = ['command=' cmd  '&currencyPair=' opt1 '&start=' opt2 '&end=' opt3];
            PoloniexApi.calltype = 0;
          case 'returnOrderTrades'
            PoloniexApi.body = ['command=' cmd  '&orderNumber=' opt1];
            PoloniexApi.calltype = 0;
          case 'buy'
            PoloniexApi.body = ['command=' cmd  '&currencyPair=' opt1 '&rate' opt2 '&amount' opt3 '&' opt4 '=1'];
            PoloniexApi.calltype = 0;
          case 'sell'
            PoloniexApi.body = ['command=' cmd  '&currencyPair=' opt1 '&rate' opt2 '&amount' opt3 '&' opt4 '=1'];
            PoloniexApi.calltype = 0;
          case 'cancelOrder'
            PoloniexApi.body = ['command=' cmd  '&orderNumber=' opt1];
            PoloniexApi.calltype = 0;
          case 'moveOrder'
            PoloniexApi.body = ['command=' cmd  '&orderNumber=' opt1 '&rate' opt2 '&amount' opt3 '&' opt4 '=1'];
            PoloniexApi.calltype = 0;
          case 'withdraw'
            PoloniexApi.body = ['command=' cmd  '&currency=' opt1 '&amount' opt2 '&adress' opt3];
            PoloniexApi.calltype = 0;
          case 'returnFeeInfo'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 0;
          case 'returnAvailableAccountBalances'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 0;
          case 'returnTradableBalances'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 0;
          case 'transferBalance'
            PoloniexApi.body = ['command=' cmd '&currency=' opt1 '&amount' opt2 '&fromAccount' opt3 '&toAccount' opt4];
            PoloniexApi.calltype = 0;
          case 'returnMarginAccountSummary'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 0;
          case 'marginBuy'
            PoloniexApi.body = ['command=' cmd '&currencyPair=' opt1 '&rate' opt2 '&amount' opt3];
            PoloniexApi.calltype = 0;
          case 'marginSell'
            PoloniexApi.body = ['command=' cmd '&currencyPair=' opt1 '&rate' opt2 '&amount' opt3];
            PoloniexApi.calltype = 0;
          case 'getMarginPosition'
            PoloniexApi.body = ['command=' cmd '&currencyPair=' opt1];
            PoloniexApi.calltype = 0;
          case 'closeMarginPosition'
            PoloniexApi.body = ['command=' cmd '&currencyPair=' opt1];
            PoloniexApi.calltype = 0;
          case 'createLoanOffer'
            PoloniexApi.body = ['command=' cmd '&currency=' opt1 '&amount=' opt2 '&duration=' opt3 '&autoRenew=' opt4 '&lendingRate=' opt5];
            PoloniexApi.calltype = 0;
          case 'cancelLoanOffer'
            PoloniexApi.body = ['command=' cmd '&orderNumber=' opt1];
            PoloniexApi.calltype = 0;
          case 'returnOpenLoanOffers'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 0;
          case 'returnActiveLoans'
            PoloniexApi.body = ['command=' cmd];
            PoloniexApi.calltype = 0;
          case 'returnLendingHistory'
            PoloniexApi.body = ['command=' cmd '&start=' opt1 '&end=' opt2 '&limit=' opt3];
            PoloniexApi.calltype = 0;
          case 'toggleAutoRenew'
            PoloniexApi.body = ['command=' cmd '&orderNumber=' opt1];
            PoloniexApi.calltype = 0;
          otherwise
            disp('Error, Wrong command')
          end

      else
        disp('Error, command should be a char')
      end
    end
    function [key, private, hmacsign, command, body] = getproperties(PoloniexApi)
      key = PoloniexApi.key;
      private = PoloniexApi.private;
      hmacsign = PoloniexApi.hmacsign;
      command = PoloniexApi.command;
      body = PoloniexApi.body;

    end
    function PoloniexApi = CreateSign(PoloniexApi)
      command = PoloniexApi.command;
      nonce = round(posixtime(datetime)) + 1;
      if ~strcmp(command,'');
        PoloniexApi.body = [PoloniexApi.body '&nonce=' num2str(nonce)];
        PoloniexApi.hmacsign = HMAC(PoloniexApi.private, PoloniexApi.body, 'SHA-512');
      else
        disp('Error, Set a command')
      end
    end
    function [output,extras] = CallApi(PoloniexApi)
      if PoloniexApi.calltype == 1
        url ='https://poloniex.com/public?';
        [url PoloniexApi.body];
        [output,extras] = urlread([url PoloniexApi.body]);
      elseif PoloniexApi.calltype == 0
        PoloniexApi = PoloniexApi.CreateSign;
        url ='https://poloniex.com/tradingApi';
        header = [ struct('name','Key','value',PoloniexApi.key);
            struct('name','Sign','value',PoloniexApi.hmacsign)];
        [output,extras] = urlread2(url,'POST',PoloniexApi.body,header);
      end
    end
  end
  methods
    function PoloniexApi = PoloniexApi()
      %disp('Class creation');
    end
  end
end
