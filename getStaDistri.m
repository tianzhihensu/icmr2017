function [ finalStates ] = getStaDistri( initialStates, transiMatrix1, transiMatrix2 )
%GETSTADISTRI ramdom walk process simulation, get the final stationary distribution
% 
% In the bipartite graph, two groups are seperate and the prob of reaching
% the current node is greater than zero only in even times, then is this
% function, in order to get the stationary distribution of prob of text
% regions, two steps are taken as one time in the iteration.
% Starting from the text regions group, the random walker can reach this group only in even steps.
%
% In each odd step, transiMatrix1 is used to calculate the prob of being
% each node in object region group, and in the next step, transiMatrix2 is
% exploited to estimate the prob of being nodes in text region group.
% 
% formula: \pi^{n + 1} = \pi^{n} * P,    P = transiMatrix1 * transiMatrix2
%
% Input:
%      initialStates: initial states
%      transiMatrix1: probability matrix of text regions to object regions
%      transiMatrix2: the converse of transiMatrix1, represents the
%                     probability of object regions to text regions
%
% Output:
%      finalStates: returns the final stationary distribution of states

count = 0;


tempMatrix  = []; % save the intermediate results
integratedProbMatrix = transiMatrix1 * transiMatrix2;

% first iterate
resultMatrix = integratedProbMatrix * integratedProbMatrix;
count

% iterate until to stationary
while ~isequal(tempMatrix, resultMatrix)
    tempMatrix = resultMatrix;
    resultMatrix =  resultMatrix * integratedProbMatrix;
    count = count + 1;
    count
end

finalStates = initialStates * tempMatrix;

end

