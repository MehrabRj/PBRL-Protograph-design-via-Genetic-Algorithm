% -------------------------------------------------------------------------
% Function: Energy Function
% Description:
%   calculates the norm of gap-to-capacity vector
%
% Inputs:
%   protograph B , n_v , n_c , n_r , number of first punctured column
%
% Outputs:
%   norm value of gap-to-capacity vector
%
% -------------------------------------------------------------------------

function norm_val= energy_func(B, n_v , n_c , n_r , punc_col)

punc_node=[punc_col];
threshold_vec=zeros(1,n_r+1);
Rates=zeros(1,n_r+1);
shannon_vec=zeros(1,n_r+1);

%parallel computation
parfor i=0:n_r
    reduced_mat=B(1:end-i,1:end-i);
    [m,n]=size(reduced_mat);
    Rates(i+1)=(n_v-n_c)/(n_v-1+i);
    threshold_vec(i+1)= ProEXIT(reduced_mat,punc_node,250);
    shannon_vec(i+1)=ShannonLimit(Rates(i+1));
end
norm_val=norm(threshold_vec-shannon_vec,2);
end






