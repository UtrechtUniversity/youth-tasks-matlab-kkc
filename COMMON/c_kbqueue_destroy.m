function c_kbqueue_destroy(keyDevice)

KbQueueStop(keyDevice);
KbQueueFlush(keyDevice);
KbQueueRelease(keyDevice);
ListenChar(0);
