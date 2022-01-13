
commandwindow;

[keyDevice, barcodeKB] = c_find_keyboards();

c_kbqueue_init(keyDevice);
c_kbqueue_start(keyDevice);


bDone = 0;

while (bDone == 0)
    [pressed, firstPress, firstRelease, lastPress, lastRelease] = KbQueueCheck(keyDevice);
    if (find(pressed ~= 0))
        bDone = 1;
    end
end


c_kbqueue_stop(keyDevice);
c_kbqueue_destroy(keyDevice);
    


