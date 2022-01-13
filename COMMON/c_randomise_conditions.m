function [order] = c_randomise_conditions(comb, repcnt)

err = 1;
while (err ~= 0)
    [seq, err] = randomseq(comb, repcnt);
    if (err == 1)
        disp('Randomization failed, retrying...')
    end
end

order = seq;

