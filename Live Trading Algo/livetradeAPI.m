function bollingmodel = livetradeAPI(model)
    ticker = PoloniexApi;
    ticker = SetCommand(ticker,'returnTicker');
    [output,extras] = CallApi(ticker);

    if extras == 0
      disp('Connection error during ticker')
      return
    else
      disp('Get ticker ok')
    end
    store = jsondecode(output);
    fieldnamesmodel = fieldnames(model);
    end_date_datetime = datetime;
%     end_date_datetime.Hour = floor(end_date_datetime.Hour/2)*2;
%     end_date_datetime.Second = 0;
%     end_date_datetime.Minute = 1;
    start_date_datetime = end_date_datetime - day(10);
    end_date_posix = round(posixtime(end_date_datetime));
    start_date_posix = round(posixtime(start_date_datetime));
    for i = 1 : (length(fieldnamesmodel) - 2)
     current = fieldnamesmodel{i};
     chart = PoloniexApi;
     chart = SetCommand(chart,'returnChartData',current,num2str(start_date_posix), num2str(end_date_posix), '14400');
     [output,extras] = CallApi(chart);
     if extras == 0
        disp(['Connection error for' current])
        return
     else
        disp('Get chart ok')
     end
     storechart = jsondecode(output);
     sample = model.(current)(1);
     alpha = model.(current)(2);     
     width = model.(current)(3);
     [a,b,c] = bolling([storechart.low], sample, alpha,width);
     bollingmodel.(current).movelp = a;
     bollingmodel.(current).upperlp = b;
     bollingmodel.(current).lowlp = c;
     [a,b,c] = bolling([storechart.high], sample, alpha,width);
     
     bollingmodel.(current).movehp = a;
     bollingmodel.(current).upperhp = b;
     bollingmodel.(current).lowhp = c;
    end
  
end
