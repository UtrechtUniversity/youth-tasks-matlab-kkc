function [r] = c_scale_rec(rec_in, rec_out)

w1 = (rec_in(3) - rec_in(1));
h1 = (rec_in(4) - rec_in(2));
w2 = (rec_out(3) - rec_out(1));
h2 = (rec_out(4) - rec_out(2));

ratio1 = w1 / h1;
ratio2 = w2 / h2;

if (ratio2 > ratio1)
    scale = h2 / h1;
else
    scale = w2 / w1;
end

w1 = scale * w1;
h1 = scale * h1;
r = [rec_out(1)+(w2-w1)/2, rec_out(2)+(h2-h1)/2, rec_out(1)+(w2+w1)/2, rec_out(2)+(h2+h1)/2];
