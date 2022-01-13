function c_et_load_settings(bNewSetup)

global settings_path;

cfg_filename = [settings_path 'settings.mat'];

if ((exist(cfg_filename, 'file') == 0) || (bNewSetup == 1))
    %pref_file = matfile(cfg_filename, 'writable', true);
    
    c_setup;
    
else
    pref_file = matfile(cfg_filename, 'writable', true);
    scrW_cm = pref_file.ScreenWidthCm;
    scrH_cm = pref_file.ScreenHeightCm;
    trackerID = pref_file.trackerID;
    disp(['Screen size is: ' num2str(scrW_cm) ' x ' num2str(scrH_cm) ' cm']);
    disp(' ');
end

assignin('base', 'scrW_cm', scrW_cm);
assignin('base', 'scrH_cm', scrH_cm);
assignin('base', 'trackerID', trackerID);

if (evalin('base', 'exist(''eyetracking'', ''var'')') ~= 1)
    assignin('base', 'eyetracking', 1);
end

