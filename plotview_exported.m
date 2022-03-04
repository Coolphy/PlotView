classdef plotview_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        PlotviewUIFigure    matlab.ui.Figure
        OpenButton          matlab.ui.control.Button
        PATHEditFieldLabel  matlab.ui.control.Label
        PATHEditField       matlab.ui.control.EditField
        ListBox             matlab.ui.control.ListBox
        CompareCheckBox     matlab.ui.control.CheckBox
        INFOTextArea        matlab.ui.control.TextArea
        PositionEditField   matlab.ui.control.EditField
        XEditFieldLabel     matlab.ui.control.Label
        XEditField          matlab.ui.control.NumericEditField
        YEditFieldLabel     matlab.ui.control.Label
        YEditField          matlab.ui.control.NumericEditField
        UIAxes              matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: OpenButton
        function OpenButtonPushed(app, event)
            app.PATHEditField.Value = uigetdir('C:\');
            PATHEditFieldValueChanged(app, event);
        end

        % Value changed function: PATHEditField
        function PATHEditFieldValueChanged(app, event)
            global filepath;
            filepath = app.PATHEditField.Value;
            fileinfo = dir([filepath,'/*.*']);
            app.ListBox.Items = {fileinfo.name};
            cd(filepath);
            cd('..');
        end

        % Value changed function: ListBox
        function ListBoxValueChanged(app, event)
            global xcol ycol;
            filelist = app.ListBox.Value;
            xcol = app.XEditField.Value;
            ycol = app.YEditField.Value;
            [fileinfo,xdata,ydata] = lineplot(filelist);
            app.INFOTextArea.Value = fileinfo;
            plot(app.UIAxes,xdata,ydata);        
        end

        % Value changed function: CompareCheckBox
        function CompareCheckBoxValueChanged(app, event)
            value = app.CompareCheckBox.Value;
            if value == 1
                app.UIAxes.NextPlot = 'add';
            else
                app.UIAxes.NextPlot = 'replacechildren';
            end
        end

        % Window button motion function: PlotviewUIFigure
        function PlotviewUIFigureWindowButtonMotion(app, event)
            currPt = app.UIAxes.CurrentPoint;
            app.PositionEditField.Value = sprintf('( %.3f , %.3f )',currPt(1,1),currPt(1,2));
        end

        % Value changed function: XEditField
        function XEditFieldValueChanged(app, event)
            ListBoxValueChanged(app, event);
        end

        % Value changed function: YEditField
        function YEditFieldValueChanged(app, event)
            ListBoxValueChanged(app, event);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create PlotviewUIFigure and hide until all components are created
            app.PlotviewUIFigure = uifigure('Visible', 'off');
            app.PlotviewUIFigure.Position = [100 100 839 477];
            app.PlotviewUIFigure.Name = 'Plotview';
            app.PlotviewUIFigure.WindowButtonMotionFcn = createCallbackFcn(app, @PlotviewUIFigureWindowButtonMotion, true);

            % Create OpenButton
            app.OpenButton = uibutton(app.PlotviewUIFigure, 'push');
            app.OpenButton.ButtonPushedFcn = createCallbackFcn(app, @OpenButtonPushed, true);
            app.OpenButton.Position = [18 435 114 26];
            app.OpenButton.Text = 'Open';

            % Create PATHEditFieldLabel
            app.PATHEditFieldLabel = uilabel(app.PlotviewUIFigure);
            app.PATHEditFieldLabel.HorizontalAlignment = 'right';
            app.PATHEditFieldLabel.Position = [145 437 35 22];
            app.PATHEditFieldLabel.Text = 'PATH';

            % Create PATHEditField
            app.PATHEditField = uieditfield(app.PlotviewUIFigure, 'text');
            app.PATHEditField.ValueChangedFcn = createCallbackFcn(app, @PATHEditFieldValueChanged, true);
            app.PATHEditField.Tag = 'pathtext';
            app.PATHEditField.Position = [195 435 428 26];
            app.PATHEditField.Value = 'X:\';

            % Create ListBox
            app.ListBox = uilistbox(app.PlotviewUIFigure);
            app.ListBox.Items = {};
            app.ListBox.ValueChangedFcn = createCallbackFcn(app, @ListBoxValueChanged, true);
            app.ListBox.Position = [18 95 114 326];
            app.ListBox.Value = {};

            % Create CompareCheckBox
            app.CompareCheckBox = uicheckbox(app.PlotviewUIFigure);
            app.CompareCheckBox.ValueChangedFcn = createCallbackFcn(app, @CompareCheckBoxValueChanged, true);
            app.CompareCheckBox.Text = 'Compare';
            app.CompareCheckBox.Position = [639 436 71 22];

            % Create INFOTextArea
            app.INFOTextArea = uitextarea(app.PlotviewUIFigure);
            app.INFOTextArea.Position = [639 232 188 189];

            % Create PositionEditField
            app.PositionEditField = uieditfield(app.PlotviewUIFigure, 'text');
            app.PositionEditField.Editable = 'off';
            app.PositionEditField.HorizontalAlignment = 'center';
            app.PositionEditField.Position = [639 19 188 26];

            % Create XEditFieldLabel
            app.XEditFieldLabel = uilabel(app.PlotviewUIFigure);
            app.XEditFieldLabel.HorizontalAlignment = 'right';
            app.XEditFieldLabel.Position = [18 57 25 22];
            app.XEditFieldLabel.Text = 'X';

            % Create XEditField
            app.XEditField = uieditfield(app.PlotviewUIFigure, 'numeric');
            app.XEditField.ValueChangedFcn = createCallbackFcn(app, @XEditFieldValueChanged, true);
            app.XEditField.Position = [58 57 74 22];
            app.XEditField.Value = 1;

            % Create YEditFieldLabel
            app.YEditFieldLabel = uilabel(app.PlotviewUIFigure);
            app.YEditFieldLabel.HorizontalAlignment = 'right';
            app.YEditFieldLabel.Position = [18 21 25 22];
            app.YEditFieldLabel.Text = 'Y';

            % Create YEditField
            app.YEditField = uieditfield(app.PlotviewUIFigure, 'numeric');
            app.YEditField.ValueChangedFcn = createCallbackFcn(app, @YEditFieldValueChanged, true);
            app.YEditField.Position = [58 21 74 22];
            app.YEditField.Value = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.PlotviewUIFigure);
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.FontSize = 12;
            app.UIAxes.Position = [145 7 486 414];

            % Show the figure after all components are created
            app.PlotviewUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = plotview_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.PlotviewUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.PlotviewUIFigure)
        end
    end
end