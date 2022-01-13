function c_et_destroy()

try
    tetio_stopTracking;
catch err
end

try
    tetio_disconnectTracker;
catch err
end

try
    tetio_cleanUp;
catch err
end
