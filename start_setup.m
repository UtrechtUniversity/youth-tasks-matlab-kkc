clc; clear; close all
commandwindow;

disp('<strong>KKC TASKS SETUP</strong>');
disp(' ');

[script_path, script_name, script_ext] = fileparts(mfilename('fullpath'));
cd(script_path)

settings_path = [script_path '/SETTINGS/'];
common_path = [script_path '/COMMON/'];

confirm_settings = 1;
run([common_path 'c_setup']);


