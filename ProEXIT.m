% This file includes code adapted from:
% https://github.com/Lcrypto/Protograph_EXIT_chart
% Licensed under the Apache License, Version 2.0


function Eb_N0 = ProEXIT(Protograph,punc_nodes,iterations)
samples=25;%number of samples(Monte Carlo) to make smooth estimation of iterative decoding treshold
leEN=-10;
riEN=10;
[m n]=size(Protograph);
R=(n-m)/(n-length(punc_nodes));

while( ~pexit(Protograph,riEN,R,punc_nodes,iterations))
    leEN=riEN;
    riEN=riEN+1;
end
for L=1:1:samples 
    midEN=(riEN+leEN)/2;
    if pexit(Protograph,midEN,R,punc_nodes,iterations)
        riEN=midEN;
    else
        leEN=midEN;
    end
end
Eb_N0=(riEN+leEN)/2; %Eb/No db
SNR = midEN + 10*log10(log2(2)*R); %SNR for BPSK log2(M), M=2
threshold_db= SNR-10*log10(log2(2)*R);

end