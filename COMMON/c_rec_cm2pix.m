function [rec] = c_rec_cm2pix(rec_cm, scrW, scrH, scrW_cm, scrH_cm)

rec = rec_cm .* [scrW/scrW_cm scrH/scrH_cm scrW/scrW_cm scrH/scrH_cm];

