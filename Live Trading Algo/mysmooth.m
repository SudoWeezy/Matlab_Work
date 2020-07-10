function output = mysmooth(data,st,ty)
  if nargin == 2
    ty = 'min';
  end

      output(1:st-1) = 0;

  switch ty
    case 'min'
      for i = st : length(data)
        output(i) = min(data(i-st+1:i));
      end
    case 'median'
      for i = st : length(data)
        output(i) = median(data(i-st+1:i));
      end
    case 'max'
      for i = st : length(data)
        output(i) = max(data(i-st+1:i));
      end
    case 'reg'
      for i = st : length(data)
        ab = abs(data(i)-data(i-st+1));

        if (ab/data(i)) < 0.01
          output(i) = data(i);
        elseif (ab/data(i)) >= 0.01
          output(i) = output(i-1);
      end
  end

end
