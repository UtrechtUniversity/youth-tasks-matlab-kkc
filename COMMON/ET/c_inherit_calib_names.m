function [myinfo] = c_inherit_calib_names(calib_save_path)
myinfo = dir([calib_save_path '*_calib_*.mat'])