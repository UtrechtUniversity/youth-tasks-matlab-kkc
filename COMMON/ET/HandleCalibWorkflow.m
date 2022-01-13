function pts = HandleCalibWorkflow(Calib, calib_path, w, m, refrate, calib_plotfile)
%HandleCalibWorkflow Main function for handling the calibration workflow.
%   Input:
%         Calib: The calib config structure (see InitCalibration)
%         w = Screenhandle
%   Output:
%         pts: The list of points used for calibration. These could be
%         further used for the analysis such as the variance, mean etc.

fprintf('Press <strong>Space</strong> when the participant is looking at the calibration point. \n');

rng('shuffle');

while(1)

    try
        
        % make random order of the calibration points
        mOrder = randperm(Calib.points.n);
        mOrder = randperm(Calib.points.n); % do again as MATLAB has to base its first randperm on something (avoid using the same sequence for everyone)
        
        calibplot = Calibrate(Calib, calib_path, mOrder, 0, [],w,m,refrate);
        
        [pts, figh] = PlotCalibrationPoints(calibplot, Calib, mOrder, []);% Show calibration points and compute calibration.
        %saveas(figh, calib_plotfile);
        
        while(1)
            h = input('Accept calibration? ([y]/n):','s');  
            if ~isempty(find(h=='y',1)) % isempty(h) || 
                tetio_stopCalib;
                close;
                return; 
            end
            
            h = input('Recalibrate all points (a) or some points (b)? ([a]/b):','s'); 
            
            if isempty(h) || ~isempty(find(h=='a',1))
                close all;
                tetio_stopCalib;
                break; 
            else
                h = input('Please enter (space separated) the numbers that you wish to recalibrate e.g. 1 3: ', 's');
                recalibpts = str2num(h);
                calibplot = Calibrate(Calib, calib_path, mOrder, 1, recalibpts,w,m,refrate);
                [pts, figh] = PlotCalibrationPoints(calibplot, Calib, mOrder, figh);
                %saveas(figh, calib_plotfile);
            end         
            
        end
    catch %  Calibration failed
        tetio_stopCalib;
        h = input('An error occured: Do you want to try again([y]/n):','s');
        pts = -1;
        %if isempty(h) || ~isempty(find(h=='y',1))
        %    close all;            
        %    continue; 
        %else
        if ~isempty(find(h=='n',1))
            fprintf('<strong>FAILED TO CALIBRATE - CONTINUING WITHOUT CALIBRATION</strong>\n');
            return;
        else
            close all;            
            continue; 
        end
        
    end
end








