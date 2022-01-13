clc; clear; close all
commandwindow;

disp('<strong>KKC TEMPORARY SUBJECT DATA CLEANUP</strong>');
disp(' ');

[script_path, script_name, script_ext] = fileparts(mfilename('fullpath'));
cd(script_path)

subject_path = [script_path '/DATA/SUBJECTS/'];
common_path = [script_path '/COMMON/'];

run([common_path 'subject_cleanup']);


