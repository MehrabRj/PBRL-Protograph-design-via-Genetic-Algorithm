% -------------------------------------------------------------------------
% Function: Crossover 
% Description:
%   Applies crossover to a given protograph chromosome
%
% Inputs:
%   protograph chromosome
% Outputs:
%   crossovered protograph
%
% -------------------------------------------------------------------------


function [y1, y2]=Crossover(x1,x2)

    pSinglePoint=0.5;
    pDoublePoint=0.5;
    pUniform=1-pSinglePoint-pDoublePoint;
    
    METHOD=RouletteWheelSelection([pSinglePoint pDoublePoint pUniform]);
    
    switch METHOD
        case 1
            [y1 ,y2]=SinglePointCrossover(x1,x2);
            
        case 2
            [y1, y2]=DoublePointCrossover(x1,x2);
            
        case 3
            [y1, y2]=UniformCrossover(x1,x2);
            
    end


end


function [y1, y2]=DoublePointCrossover(x1,x2)

    nVar=numel(x1);
    cc1=0;
    cc2=0;
    while ceil(cc1/10)==ceil(cc2/10)
        cc=randsample(nVar-1,2);
        cc1=min(cc);
        cc2=max(cc);
    end
   
    c1=min(cc);
    c2=max(cc);
    if c1>=210 
        c1 = floor(c1/10)*10;
    else
        c1 = ceil(c1/10)*10;
    end

    if c2>=210 
        c2 = floor(c2/10)*10;
    else
        c2 = ceil(c2/10)*10;
    end

    y1=[x1(1:c1) x2(c1+1:c2) x1(c2+1:end)];
    y2=[x2(1:c1) x1(c1+1:c2) x2(c2+1:end)];

end

function [y1 ,y2]=SinglePointCrossover(x1,x2)

    nVar=numel(x1);
    
    c=randi([1 nVar-1]);
    if c>=210 
        c = floor(c/10)*10;
    else
        c = ceil(c/10)*10;
    end
    
    y1=[x1(1:c) x2(c+1:end)];
    y2=[x2(1:c) x1(c+1:end)];

end

function [y1, y2]=UniformCrossover(x1,x2)

    alpha=randi([0 1],size(x1));
    
    y1=alpha.*x1+(~alpha).*x2;
    y2=alpha.*x2+(~alpha).*x1;

end