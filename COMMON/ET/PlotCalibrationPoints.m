function [pts figh] = PlotCalibrationPoints(calibPlot, Calib, mOrder, figh)

if (~isempty(figh))
    try
        close(figh)
    catch
    end
    figh = [];
end

NPts = length(calibPlot) / 8;
if (NPts == 0 )
    pts = [];
    disp('no calib point found');
    return;
end

pts = reshape(calibPlot, 8, NPts)';

scrsize = get(0,'ScreenSize');
fig_pos = [scrsize(3)/2, scrsize(4)/2 - 60, scrsize(3)/2, scrsize(4)/2];
figh = figure('menuBar','none','name','Calib res - Press any key to continue','keypressfcn','close;','OuterPosition',fig_pos);
hold on
axis([0 Calib.xres 0 Calib.yres])
axis ij

for i = 1 : length(mOrder)
    x = Calib.points.x(mOrder(i));
    y = Calib.points.y(mOrder(i));
    
    plot(Calib.xres * x, Calib.yres * y, 'o','MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',20);
    %text(double(Calib.xres * x+60),double(Calib.yres * y),num2str(mOrder(i)),'FontSize',15,'color','k');
end

for i = 1 : NPts
    if (pts(i,5) == 1)
        line([Calib.xres*pts(i,1) Calib.xres*pts(i,3)], [Calib.yres*pts(i,2) Calib.yres*pts(i,4)], 'Color','r');
        plot(Calib.xres*pts(i,3), Calib.yres*pts(i,4), 'o','MarkerEdgeColor','r','MarkerSize',7);
    end
    if (pts(i,8) == 1)
        line([Calib.xres*pts(i,1) Calib.xres*pts(i,6)], [Calib.yres*pts(i,2) Calib.yres*pts(i,7)], 'Color','g');
        plot(Calib.xres*pts(i,6), Calib.yres*pts(i,7), 'o','MarkerEdgeColor','g','MarkerSize',7);
    end
end

for i = 1 : length(mOrder)
    x = Calib.points.x(mOrder(i));
    y = Calib.points.y(mOrder(i));
    
    %plot(Calib.xres * x, Calib.yres * y, 'o','MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',20);
    text(double(Calib.xres * x+60),double(Calib.yres * y),num2str(mOrder(i)),'FontSize',15,'color','k');
end

hold off
drawnow





