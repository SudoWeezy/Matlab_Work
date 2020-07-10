delete('model.mat')
a = PoloniexApi;
a = SetCommand(a,'returnTicker');
    [output,extras] = CallApi(a);

if extras == 0
  disp('Connection error')
  return
else
  disp('Get ticker ok')
end

store = jsondecode(output);
fn = fieldnames(store);
cfn = char(fn);
wcfn = (cfn(:,1:4) == 'USDT');
pair = fn(wcfn(:,1));

end_date_datetime = datetime('today');
start_date_datetime = end_date_datetime - calmonths(1);

end_date_posix = round(posixtime(end_date_datetime));
start_date_posix = round(posixtime(start_date_datetime));
model.startdate = start_date_datetime;
model.enddate = end_date_datetime;
startval = num2str(start_date_posix);
endval = num2str(end_date_posix);
strstepValue = '14400';
for i  =  1 : length(pair)
  a = SetCommand(a,'returnChartData',pair{i},startval, endval, strstepValue);
  [output,extras] = CallApi(a);
  if extras == 0
    disp('Connection error')
    return
  else
    disp(['Get data for modeling ' pair{i} ' ok'])
    storechart = jsondecode(output);
    structure.(pair{i}) = storechart;
    [sample,alpha,width,value] = buildmodel(structure.(pair{i}));
     model.(pair{i})(1:4) = [sample,alpha,width,value];
  end
end
save('model.mat','model');
