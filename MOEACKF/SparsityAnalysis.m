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
    Fitness=(Fitness-min(Fitness)+1e-6)./(max(Fitness)-min(Fitness)+1e-6)+1e-6;
    
    if size(Fitness',1) < 2
        NSV=GROUP(1,:);
        SV=GROUP(2,:);
    else
        Cluster=kmeans(Fitness',2);  
        Fitness=Fitness+(1-mean(EliteMask)).*(0.5*theta+0.5*(Problem.FE/Problem.maxFE)).*Fitness;       
        if mean(Fitness(Cluster==1)) > mean(Fitness(Cluster==2))
            NSV=Cluster==2;
            SV=Cluster==1;
        else
            NSV=Cluster==1;
            SV=Cluster==2;
        end
    end        
end