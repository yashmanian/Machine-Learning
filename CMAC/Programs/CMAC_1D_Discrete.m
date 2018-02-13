%ENPM 808F Discrete CMAC
% By : Yash Manian
clear all
%%
% Variables 
%Given data
Input=1:1:20;
Output = transpose(Input.^2);
GenFactor = 10;

% Data points

 TrainingData=[1;2;4;5;9;11;13;15;18;19];
 TestData = sort(setdiff(Input,TrainingData))';
 [TrainingRow,TrainingColumn]=size(TrainingData);

%CMAC variables
[OutputRow,OutputColumn] = size(Output);
W_Dimension=OutputRow+(GenFactor);
Weights=zeros(W_Dimension,1);
Output_Des=zeros(OutputRow,1);
Output_Des_test=zeros(OutputRow,1);
Error_1 = 0;
Error_2 = 0;
StopVal = 0;
Error_Test = 0;
Training_Output = zeros(OutputRow,1);
Test_Output = zeros(OutputRow,1);
Time=zeros(10,1);

% Error variables
MeanSquaredError_Test = zeros(10,1);
MeanSquaredError_Training = zeros(10,1);
%%

 for GenFactor = 1:1:10
    
tic

%%
% Training Weights
%   for i=1:1:100
while(1)
    for i=1:1:TrainingRow
        Index = TrainingData(i);
        Input_Current = Input(Index);
        Training_Output(Index) = Output(Index);
        Output_Current= Output(Index);
        W_Current = Weights(Index:Index+GenFactor-1);
        Error_Current = (Output_Current - sum(W_Current));
        W_Value = Error_Current/GenFactor;
        
        for j=Index:1:Index+GenFactor-1
            Weights(j)= Weights(j) + W_Value;
        end
        
        Output_Des(Index)=sum(Weights(Index:Index+GenFactor-1));
        Error_1=(Error_1+Error_Current)/Output_Current;
    end
    if abs(Error_1) <= 0.01
            break;
    end
end

%%
% Timing
toc
Time(GenFactor) = toc;

%%
% Running on Test Data
for k=1:1:TrainingRow
    Index_Test = TestData(k);
    IC_Test = Input(Index_Test);
    OC_Test = Output(Index_Test);
    Test_Output(Index_Test) = Output(Index_Test);
    Output_Des_test(Index_Test)=sum(Weights(Index_Test:Index_Test+GenFactor-1));
end

%%
% Error
Error_Training = Training_Output-Output_Des; % Training Error Array
Error_Test = Test_Output-Output_Des_test;  % Test Error


MeanSquaredError_Training(GenFactor) = immse(Training_Output,Output_Des); % Mean Squared Training Error 
MeanSquaredError_Test(GenFactor) = immse(Test_Output,Output_Des_test); % Mean Squared Test Error
end
%%

% Plotting Results
subplot(3,2,1)
plot(Input,Output,'-b')
title('Training Data')
hold on
scatter(Input,Output_Des_test,20)
scatter(Input,Output_Des,20,'Filled')
legend('Function','Test Data','Training Data')
title('Test Data')
hold off

% Plotting Error
subplot(2,2,3)
plot(1:1:10,MeanSquaredError_Training,'-r')
title('Mean Squared Training Error vs Generalization factor')
subplot(2,2,4)
plot(1:1:10,MeanSquaredError_Test,'--b')
title('Mean Squared Test Error vs Generalization factor')

% Plotting Convergence Time
subplot(2,2,2)
plot(1:1:10,Time,'-b')
title('Convergence Time')
