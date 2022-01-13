clc; clear; close all
commandwindow;

disp('<strong>KKC DATA FIXING SCRIPT</strong>');
disp(' ');

[script_path, script_name, script_ext] = fileparts(mfilename('fullpath'));
cd(script_path)

data_path = [script_path '/DATA/'];
common_path = [script_path '/COMMON/'];

changelog_path = [script_path '/CHANGELOG/'];
if (~exist(changelog_path, 'dir'))
    mkdir(changelog_path);
end

run([common_path 'data_fixer']);



