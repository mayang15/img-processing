function DC_str = DC_coding(DC_err, DCTAB, h, w)
DC_str = '';
for k  = 1:h*w/64
    if DC_err(k) == 0
        current_str = '000';
    else if DC_err(k) < 0
            L = DCTAB(1+length(dec2bin(-DC_err(k))),1);
            current_str = [matrix2str(DCTAB(1+length(dec2bin(-DC_err(k))),2:1+L)),complement(dec2bin(-DC_err(k)))];
        else
            L = DCTAB(1+length(dec2bin(DC_err(k))),1);
            current_str = [matrix2str(DCTAB(1+length(dec2bin(DC_err(k))),2:1+L)),dec2bin(DC_err(k))];
        end
    end
    DC_str = [DC_str, current_str];
end
end