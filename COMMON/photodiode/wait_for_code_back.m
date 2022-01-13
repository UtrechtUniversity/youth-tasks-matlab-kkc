function wait_for_code_back(t_box_handle,time_out_secs,code)

t0 = GetSecs;
     while (true) 
            navailable = IOPort('BytesAvailable', t_box_handle);
            if navailable>0
                [data, when, errmsg] = IOPort('Read', t_box_handle, 0, navailable);
                break;    
            end
            if (GetSecs - t0 >=time_out_secs )
              Screen('CloseAll');
              IOPort('Close',t_box_handle);
              error('RS232 error: Timeout');
            end
            pause(0.01);
     end
     
     if (data~=code)
         error('RS232 error: received data is not equal to sent data.');
     end

return