classdef Gui < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure        matlab.ui.Figure
        TabGroup        matlab.ui.container.TabGroup
        Tab             matlab.ui.container.Tab
        buyButton       matlab.ui.control.Button
        sellButton      matlab.ui.control.Button
        UITable         matlab.ui.control.Table
        UIAxes          matlab.ui.control.UIAxes
        DropDown        matlab.ui.control.DropDown
        DropDown2       matlab.ui.control.DropDown
        CheckBox        matlab.ui.control.CheckBox
        SetupPanel           matlab.ui.container.Panel
        PeriodDropDownLabel  matlab.ui.control.Label
        PeriodDropDown       matlab.ui.control.DropDown
    end
    properties (Access = public)
        key = '';
        secret = '';
    end
    methods (Access = private)
      function selectData(app)
        app.PeriodDropDown.Enable = 'off';
        step = app.PeriodDropDown.Value;
        idx = (cell2mat({app.CheckBox.Value}));
        id = find(idx == 1);
        for i = 1: length(id)
          chart = cell2mat(app.UITable.RowName(id(i)));
          datestart = datetime(2017,1,1,0,0,0);
          startval = num2str(round(posixtime(datestart)) + 1);
          endval = num2str(round(posixtime(datetime)) + 1);
          a = PoloniexApi;
          a = SetCommand(a,'returnChartData',chart,startval, endval, step);
          [output,extras] = CallApi(a);
          if (extras == 0 );
            app.PeriodDropDown.Enable = 'on';
            return
          end
          store = jsondecode(output);
          date = datetime(cell2mat({store.date})','ConvertFrom','posixtime');
          HighPrices = cell2mat({store.high})';
          LowPrices = cell2mat({store.low})';
          OpenPrices = cell2mat({store.open})';
          ClosePrices = cell2mat({store.close})';
          volume = cell2mat({store.volume})';
          quoteVolume = cell2mat({store.quoteVolume})';
          weightedAverage = cell2mat({store.weightedAverage})';
          plot(app.UIAxes,date,HighPrices);
          hold(app.UIAxes,'on');
          plot(app.UIAxes,date,LowPrices);
          % plot(app.UIAxes,date,ClosePrices);
          % plot(app.UIAxes,date,OpenPrices);
          plot(app.UIAxes,date,weightedAverage);
        end
        hold(app.UIAxes,'off');
        if isempty(id)
          delete(app.UIAxes.Children);
        end
        app.PeriodDropDown.Enable = 'on';
      end
    end
    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            screensize = get( groot, 'MonitorPositions');
            tabgroupsize = [screensize(1) screensize(2) screensize(3) screensize(4)-50];
            axessize = [0 tabgroupsize(4)/3 tabgroupsize(3)*2/3 tabgroupsize(4)*2/3-50];
            tablesize = [axessize(3)+20 axessize(2) tabgroupsize(3)*1/3 axessize(4)];

            panelsize = [tablesize(1) 1 tablesize(3) tabgroupsize(4)*1/3];
            sb = 18;
            cbsize = [tablesize(1)-15 tablesize(2)+tablesize(4)-35 15 15];
            buttonsize = [100 22];
            buttonbuypos = [axessize(3)/3-buttonsize(1)/2 tabgroupsize(4)/10];
            buttonsellpos = [axessize(3)*2/3-buttonsize(1)/2 tabgroupsize(4)/10];
            DDbuypos = [axessize(3)/3-buttonsize(1)/2 tabgroupsize(4)*3/10 ];
            DDsellpos = [axessize(3)*2/3-buttonsize(1)/2 tabgroupsize(4)*3/10];

            a = PoloniexApi;
            a.key = app.key;
            a.private = app.secret;
            a = SetCommand(a,'returnTicker');
            [output,extras] = CallApi(a);
            store = jsondecode(output);
            fn = fieldnames(store);
            [token,remain] = strtok(fn,'_');
            nbidx = strcmp({'USDT'},token);
            idx = find(nbidx == 1);

            cw = tablesize(3)/5;
            for i = 1 : length(idx);
              last(i)= {store.(fn{idx(i)}).last};
              lowestAsk(i)= {store.(fn{idx(i)}).lowestAsk};
              highestBid(i)= {store.(fn{idx(i)}).highestBid;};
              percentChange(i)= {store.(fn{idx(i)}).percentChange};
            end

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = screensize;
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.Visible = 'on';
            setAutoResize(app, app.UIFigure, false)

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = tabgroupsize;

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Title = 'Tab';
            app.Tab.Units = 'pixels';

            % Create Button
            app.buyButton = uibutton(app.Tab, 'push');
            app.buyButton.Position = [buttonbuypos buttonsize];
            app.buyButton.Text = 'BUY';

            % Create Button2
            app.sellButton = uibutton(app.Tab, 'push');
            app.sellButton.Position = [buttonsellpos buttonsize];
            app.sellButton.Text = 'SELL';

            % Create UITable
            app.UITable = uitable(app.Tab);
            app.UITable.ColumnName = {'last'; 'lowestAsk'; 'highestBid'; 'percentChange'};
            app.UITable.Data = [last',lowestAsk',highestBid',percentChange'];
            app.UITable.ColumnWidth = {cw,cw,cw,cw};
            app.UITable.RowName = [fn(idx)];
            app.UITable.Position = tablesize;


            for i = 1 : length(idx)
              app.CheckBox(i) = uicheckbox(app.Tab);
              app.CheckBox(i).Position = cbsize;
              app.CheckBox(i).Text = '';
              cbsize(2) = cbsize(2) - sb;
              app.CheckBox(i).UserData = {idx(i)};
              app.CheckBox(i).ValueChangedFcn =createCallbackFcn(app,@selectData);
            end
            % Create UIAxes
            app.UIAxes = uiaxes(app.Tab);
            title(app.UIAxes, 'Title');
            xlabel(app.UIAxes, 'X');
            ylabel(app.UIAxes, 'Y');
            app.UIAxes.Position = axessize;
            app.UIAxes.Box = 'on';
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';

            % Create DropDown
            app.DropDown = uidropdown(app.Tab);
            app.DropDown.Position = [DDbuypos buttonsize];

            % Create DropDown2
            app.DropDown2 = uidropdown(app.Tab);
            app.DropDown2.Position = [DDsellpos buttonsize];

            % Create SetupPanel
            app.SetupPanel = uipanel(app.UIFigure);
            app.SetupPanel.TitlePosition = 'centertop';
            app.SetupPanel.Title = 'Setup';
            app.SetupPanel.BackgroundColor = [1 1 1];
            app.SetupPanel.Position = panelsize;

            % Create PeriodDropDownLabel
            app.PeriodDropDownLabel = uilabel(app.SetupPanel);
            app.PeriodDropDownLabel.HorizontalAlignment = 'right';
            app.PeriodDropDownLabel.Position = [panelsize(3)/6-buttonsize(1)/2 panelsize(4)*5/6-buttonsize(2)/2 buttonsize];
            app.PeriodDropDownLabel.Text = 'Period';
            app.PeriodDropDown = uidropdown(app.SetupPanel);
            app.PeriodDropDown.Items = {'300', '900', '1800', '7200', '86400'};
            app.PeriodDropDown.Position = [panelsize(3)*3/6-buttonsize(1)/2 panelsize(4)*5/6-buttonsize(2)/2 buttonsize];
            app.PeriodDropDown.Value = '86400';
            app.PeriodDropDown.ValueChangedFcn =createCallbackFcn(app,@selectData);


        end
    end

    methods (Access = public)

        % Construct app
        function app = Gui()

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            % registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
