% =========================================================================
% Title: PBRL Protograph design via Genetic Algorithm
% Author: Mehrab Rajabi
% Email: mehrab.rajabi@aut.ac.ir
% Date: July 2025
%
% Description:
%   This MATLAB code designs protograph of a rate-compatible LDPC Codes in
%   Protograph-Based Raptor-like (PBRL) LDPC codes structure which
%   optimizes decoding threshold of the protograph via genetic algorithm.
%   It minimizes norm of gap-to-capacity threshold, reducing threshold in
%   every single rate simultanously.
%
%   The code is part of the work described in the paper:
%   "Simultaneous Multi-Rate Threshold Optimization of Protograph-Based 
%    Raptor-Like LDPC Codes via Genetic Algorithm"
%
% Repository: https://github.com/MehrabRj/PBRL-Protograph-design-via-Genetic-Algorithm
%
% =========================================================================

clc;
clear;
close all;
tic
%% Problem Definition

% The example below is the short-blocklength example of original PBRL paper 
% HRC part of protograph 
B_hrc=[ 
       3 1 3 1 3 1 3 1 2 1 
       1 3 1 3 1 3 1 2 1 2
      ];

I = eye(15);                   
zero_matrix = zeros(2, 15);

% Protograph Parameters
n_r=15;  % number of supported rates (Check nodes in IRC matrix)
n_v=10;  % number of variable nodes in HRC matrix
n_c=2;   % number of check nodes in HRC

% construction of protomatrix by appending sub-matrices
construct_B = @(irc_cand) [B_hrc, zero_matrix; irc_cand , I];

% build chromosome vector from IRC matrix
vectorize_B= @(protograph) reshape(protograph',[],1)';

% build IRC matrix from chromosome vector
build_mat= @(vector) reshape(vector,10,[])';

%number of first punctured columns
punc_col = 1;

%Cost function(Norm of Gap to capacity vector across all supported rates)
CostFunction=@(vector) energy_func( construct_B(build_mat(vector)) , n_v , n_c , n_r ,punc_col); 

nVar=n_r*n_v;            % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

%% GA Parameters

% Set the number of MaxIt sufficiently large, and interrupt the program
% whenever a significantly low gap-to-capacity threshold norm is observed. 

MaxIt=1000;      % Maximum Number of Iterations

nPop=50;        % Population Size

pc=0.8;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (Parnets)

pm=0.02;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants

%mu=0.1;         % Mutation Rate
%% Selection Set Params
beta=8;         % Roulette Wheel Selection(RWS) Pressure
RWS = 1;
%% Initialization(p#0)

empty_individual.Position=[];
empty_individual.Cost=[];
pop=repmat(empty_individual,nPop,1);

% Initialize Position
for i=1:nPop
    
    
    pop(i).Position=randi([0 2],VarSize);
    pop(i).Position;
    pop(i).Cost=CostFunction(pop(i).Position);
    
end

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Array to Hold [Best Worst] Cost Values
BestCost = zeros(MaxIt,1);
WorstCost = zeros(MaxIt,1);

% Store Cost
WorstC = pop(end).Cost;
%% Main Loop

for it=1:MaxIt
    
    % Calculate Selection Probabilities
    P = exp(-beta*Costs/WorstC);
    P=P/sum(P);
    
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        % Select Parents Indices
        if RWS
            i1=RouletteWheelSelection(P);
            i2=RouletteWheelSelection(P);
        else
            i1=randi([1 nPop]);
            i2=randi([1 nPop]);
        end

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Apply Crossover
        [popc(k,1).Position,popc(k,2).Position]=Crossover(p1.Position,p2.Position);
        
        % Evaluate Offsprings
        popc(k,1).Cost=CostFunction(popc(k,1).Position);
        popc(k,2).Cost=CostFunction(popc(k,2).Position);
        
    end
    popc=popc(:);
    
    if(it<40)
        mu=0.5;
    elseif(it>=50 && it<=100)
        mu=0.25;
    else
        mu=0.05;
    end

    % Mutation
    popm=repmat(empty_individual,nm,1);
    for k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation
        popm(k).Position=Mutate(p.Position,mu);
        
        % Evaluate Mutant
        popm(k).Cost=CostFunction(popm(k).Position);
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm];
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Update Worst Cost
    WorstC = max(WorstC,pop(end).Cost);
    WorstCost(it) = pop(end).Cost;

    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    BestSol=pop(1);
    BestCost(it)=BestSol.Cost;
    
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ', Best Cost = ' num2str(BestCost(it))]);
    BestSol.Position
end


%% Results
BestSol.Position
toc