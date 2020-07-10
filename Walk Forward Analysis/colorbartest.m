close all
clear all

c = colorbar;
c.Label.Units = 'normalized';
c.Label.String = 'Label Text Goes Here';
c.Label.HorizontalAlignment = 'left';
c.Label.VerticalAlignment = 'top';
c.Label.Rotation = 0;
c.Label.Position(1) = 0;
c.Label.Position(2) = 0;