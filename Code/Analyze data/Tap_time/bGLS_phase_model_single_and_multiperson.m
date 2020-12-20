%%%%%%%%%%%%%%%%%%%
% This method computes the bGLS for single and multiple subject.
% it is the function to use when there are no signficant tempo cahnges.
%
%   For more information see: Nori Jacoby, Naftali Tishby, Bruno H. Repp, Merav Ahissar and Peter E. Keller (2015) 
%
% Let OR(t) be the response onset at time t
% Let OS(t) be the stimulus onset at time t
% Let R(t) be the interesponse interval R(t)=OR(t)-OR(t-1)
% note that R is is slightly diffrent than the notation of 
% Vorberg and Shultze 2002 where:
% I(t)=OR(t+1)-OR(t)=R(t+1)
% for multiple person the input of As is a N by P asynchronies
% R is again N by 1 vector (we look at one subject).
% the empirical means should be computed outside.
% =====  CODE BY: Nori Jacoby (nori.viola@gmail.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ==========================================================================
% ===== For information please contact: Nori Jacoby 
% ===== Nori.viola@gmail.com
% =====
% ===== If you are using the code,
% ===== Please cite this version:
% ===== 
% ===== Jacoby, Nori, Peter Keller, Bruno H. Repp, Merav Ahissar and Naftali Tishby. 
% ===== "Parameter Estimation of Linear Sensorimotor Synchronization Models: Phase Correction, Period Correction and Ensemble Synchronization." 
% ===== Special issue of Timing & Time Perception (RPPW).
% ==========================================================================

function [alphas,st,sm]=bGLS_phase_model_single_and_multiperson(R,As,MEAN_A,MEAN_R)
ITER=20; % set parameters
TRESH=1e-3; %this is the maximal difference between old solution and new solution. 
% in the iteration if we get a change smaller than TRESH we simply stop (we
% obtaine a local maximum).

N=size(R,1)-1; %number of datapoints
P=size(As,2);  %number of partners
assert(size(R,1)==size(As,1));
assert(size(MEAN_A,2)==P);
assert(size(MEAN_A,1)==1);

% reduce mean
for p=1:P,
    As(:,p)=As(:,p)-MEAN_A(p);
end

% compute matrices
b3=R(2:end)-MEAN_R;
A3=[As(1:(end-1),:)];
    
% init acvf
K11=1;
K12=0;

zold=zeros(P,1)-9999; %init to invalid value

% do the BGLS iterations
for iter=1:ITER,
        CC=diag(K11*ones(1,N),0)+ diag(K12*ones(1,N-1),1) + diag(K12*ones(1,N-1),-1);
        iC=inv(CC);
        z=inv((A3')*iC*A3)*((A3')*iC*b3); % compute GLS
        d=A3*z-b3; % compute residual noise
        
        K=cov(d(1:(end-1)),d(2:end));    %estimate residual acvf
        K11=(K(1,1)+K(2,2))/2;
        K12=K(1,2);

        % apply bound
        if K12>0
            K12=0;
        end
        if K11<(-3*K12)
            K11=(-3*K12);
        end
       
        % if allready obtain local maxima there is no point to continue...
        if (sum(abs(z-zold))<TRESH)
            break;
        end
        zold=z;
end % end of bGLS iterations.

% output variables
alphas=-z';
sm=sqrt(-K12);
st=sqrt(K11-2*(sm^2));
    
    