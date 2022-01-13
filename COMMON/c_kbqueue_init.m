function c_kbqueue_init(keyDevice)

ListenChar(0);
KbQueueCreate(keyDevice);
warning('off','all');
ListenChar(2);
warning('on','all');
