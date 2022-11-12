function [TDec,TMask,TempPop,Fitness]=PriorKnowledge_initialization(Problem,REAL)

    TDec    = [];
    TMask   = [];
    TempPop = [];
    Fitness = zeros(1,Problem.D);
    for i = 1 : 1+4*REAL
        if REAL
            Dec = unifrnd(repmat(Problem.lower,Problem.D,1),repmat(Problem.upper,Problem.D,1));
        else
            Dec = ones(Problem.D,Problem.D);
        end
        Mask       = eye(Problem.D);
        Population = SOLUTION(Dec.*Mask);
        TDec       = [TDec;Dec];
        TMask      = [TMask;Mask];
        TempPop    = [TempPop,Population];
        Fitness    = Fitness + NDSort([Population.objs,Population.cons],inf);
    end 
    
    
    
    % Generate initial population
    if REAL
        Dec = unifrnd(repmat(Problem.lower,Problem.N,1),repmat(Problem.upper,Problem.N,1));
    else
        Dec = ones(Problem.N,Problem.D);
    end
    Mask = zeros(Problem.N,Problem.D);
    for i = 1 : Problem.N
        Mask(i,TournamentSelection(2,ceil(rand*Problem.D),Fitness)) = 1;
    end
    Population = SOLUTION(Dec.*Mask);
    TDec       = [TDec;Dec];
    TMask      = [TMask;Mask];
    TempPop    = [TempPop,Population];
end