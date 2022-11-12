function [Local_Knowlege,Gobal_Knowlege,Fitness,NSV,SV,theta]=SparsityAnalysis(~,Mask,FrontNo,Fitness,GROUP)
    Problem=PROBLEM.Current();
    Local_Knowlege=false(3,Problem.D);
    Gobal_Knowlege=false(3,Problem.D);
    EliteMask=Mask(FrontNo==1,:);
    Local_Knowlege(1,:)=all(EliteMask,1);
    Local_Knowlege(2,:)=all(~EliteMask,1);
    Local_Knowlege(3,:)= ~ Local_Knowlege(1,:) & ~ Local_Knowlege(2,:);
    
    Gobal_Knowlege(1,:)=all(Mask,1);
    Gobal_Knowlege(2,:)=all(~Mask,1);
    Gobal_Knowlege(3,:)= ~ Gobal_Knowlege(1,:) & ~ Gobal_Knowlege(2,:);
    
    theta=size(EliteMask,1)/size(Mask,1);
    

    
    K_Fitness=(Fitness-min(Fitness)+1e-6)./(max(Fitness)-min(Fitness)+1e-6)+1e-6;
   % To prevent loss of information, for the normalized pv, add 0.1 to variables smaller than the mean
    Fmean=mean(K_Fitness);
    K_Fitness(K_Fitness<Fmean)= K_Fitness(K_Fitness<Fmean)+repmat(0.1,1,sum(K_Fitness<Fmean));
    
    if size(Fitness',1) < 2
        NSV=GROUP(1,:);
        SV=GROUP(2,:);
    else
        Cluster=kmeans(K_Fitness',2);  
        newFitness=Fitness+(1-mean(EliteMask)).*(0.5*theta+0.5*(Problem.FE/Problem.maxFE)).*Fitness;
        Fitness=0.5.*newFitness+0.5*Fitness;
        if sum(Fitness(Cluster==1)) > sum(Fitness(Cluster==2))
            NSV=Cluster==2;
            SV=Cluster==1;
        else
            NSV=Cluster==1;
            SV=Cluster==2;
        end
    end
    
    
    
end