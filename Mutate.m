% -------------------------------------------------------------------------
% Function: mutate
% Description:
%   Applies mutation to a given protograph structure
%
% Inputs:
%   protograph, mutation_rate
%
% Outputs:
%   mutated_protograph - result after mutation
%
% -------------------------------------------------------------------------


function y=Mutate(x,mu)

    nVar=numel(x);
    
    nmu=ceil(mu*nVar);
    
    j=randsample(nVar,nmu);
    y=x;
for k = 1:length(j)              
        current_value = x(j(k));      
        possible_values = [0, 1, 2];    
        possible_values(current_value + 1) = []; 
        if (x(j(k))==1 || x(j(k))==2)
            y(j(k))= ~x(j(k));
        else
            y(j(k)) = possible_values(randi(2));
        end
end

end