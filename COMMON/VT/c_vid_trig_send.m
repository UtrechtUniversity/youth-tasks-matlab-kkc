function [msg] = c_vid_trig_send(vt_enabled, tcpc, command, message)

msg = [];

if (vt_enabled == 1)
    write(tcpc, uint8([command length(message) uint8(message)]));
    
    resp = read(tcpc, 2);
    if (~isempty(resp))
        if (resp(2) > 0)
            msg = read(tcpc, resp(2));
        end
    end
end

