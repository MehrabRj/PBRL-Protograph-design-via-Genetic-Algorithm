function EbN0_dB = ShannonLimit(r)
    delta = 1e-15;  
    sigmaL = 0; 
    sigmaH = 100;

    if r <= 0 || r >= 1
        error('rate must be in (0,1)');
    end

    while (sigmaH - sigmaL > delta)
        sigma = 0.5 * (sigmaL + sigmaH);
        c_sigma = ChannelCapacity(sigma,r);
        c_sigma = c_sigma - (1/2) * log2(2 * pi * exp(1) * sigma^2);
        
        if c_sigma > r
            sigmaL = sigma;
        else
            sigmaH = sigma; 
        end
    end    
    EbN0 = 1 / (2 *r* sigma^2);
    EbN0_dB = 10 * log10(EbN0); 
end

function c_sigma = ChannelCapacity(sigma,r)

    f = @(z) -(1/sqrt(8*pi*(sigma^2))*(exp(-(z+1).^2/(2*sigma^2))+exp(-(z-1).^2/(2*sigma^2)))).* log2(1/sqrt(8*pi*(sigma^2))*(exp(-(z+1).^2/(2*sigma^2))+exp(-(z-1).^2/(2*sigma^2))));
    
    if r>0.97
        c_sigma = integral(f, -8, 8);
    else
        c_sigma = integral(f, -15, 15);
    end
end
