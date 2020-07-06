function [x,fval]=profit_max(est_p, p_r,r_t, p_t, w_t, a_t, q_l, q_u)
%=========================================================================
% Function explanation:
%   This function optimizes the expected profit for a given probability
%   distribution and expected price interval.
%
% Function input:
%   est_p: Expected price vector
%   q_t: production quantity vector.
%   r_t: Default related interest rate
%   w_t: wage
%   a_t: capital level
%   p_r: the estimated probability distribution of price level.
%   q_l[Optional]: the lower bound of output quantity
%   q_u[Optional]: the upper bound of output quantity

%  Function output:
%   x: Optimal production quantity
%   fval: expected profit.
%========================================================================
%% Preparation for customized boundary of output quantity.
if nargin == 6
    q_l = 100;
    q_u = 10000;
end

%% Step (1): Define an abitrary vector of production quantity.
q_t = randi([q_l,q_u],[size(est_p,1),1]);

%% Step (2) Compute and graph the expected profit function.
[i_p, inc, cost, c_bank]  = prod_funct(q_t, r_t, est_p, p_t, w_t, a_t,p_r);
[X,Y] = meshgrid(q_t, est_p);
%figure;
su=surf(X,Y, i_p);
su.LineStyle='none';
colormap(jet) ;
title('Surface plot of profit function');
xlabel('Production Quant');
ylabel('Price level');
zlabel('Profit');

% Comment:
%   With well defined parameters, the surface plot should demonstrate a
%   concave function. A concave function is of vital importance for the
%   following analysis. Without concavity, either linearily increasing or
%   decreasing, it is impossible to conduct the optimization 

%% Step (3): Matricize the inpput
ep_t1 = meshgrid(est_p);
p_m = meshgrid(p_r);
p_ui = cumsum(p_m');    % Produce the cummulative sum of probability of the probability vector.

%% Step (4): Define the boundary of production quantity set.
q0 = min(q_t);

%% Step (5): Concatenate the input matrices into multidimensional matrix.
xdata = cat(3,ep_t1, p_m,p_ui);

%% Step (6): Generate the bankruptcy cost
c_b= 0.1*log(q0)-0.1^2*log(q0.^2)-0.1^2*log(q0.^3)+0.1^3*log(q0.^4);
% * Aware that this is an abitrary function.

% Step (7): Non-linear optimization.
fun2 = @(q_t,xdata) xdata(:,:,2)'.*(q_t.*xdata(:,:,1)-(1+r_t)*(p_t*w_t*0.4*q_t-a_t))-c_b.*q_t.*xdata(:,:,3);

% Define the boundary and display option of the optimization program.
lb = 1;
%opt2 = optimoptions('lsqcurvefit','Display','iter')%,'PlotFcn','optimplotfval');

% Step (8): Return optimization outcome.
[x,fval]=lsqcurvefit(fun2,q0,xdata, i_p, lb,[]);


end