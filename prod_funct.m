function [pi_t, inc, cost, c_bank] = prod_funct(q_t, r_t, ep_t1,p_t, w_t, a_t, p_r)
%=========================================================================
% Function explanation:
%   This function determines the optimal output level for given general
%   price, wage, labor demand, capital investment and cost of bankruptcy.
%
% Function input:
%   r_t: Default related interest rate
%   p_t1: Expected general price level in time t+1.
%   w_t: wage
%   a_t: capital level
%   c : cost of bankruptcy.
%   p_r: the estimated probability distribution of price level.
%   l_t: Labor needed for production

% Function ouput:
%   pi_t : Expected profit
%   inc:    Income
%   cost:   Cost of production
%   c_bank: Cost of bankruptcy
%========================================================================

% For simplicity we assume the quantiy of labor demand equals to quantity
% of output.
c = 0.1*log(q_t)-0.1^2*log(q_t.^2)-0.1^2*log(q_t.^3)+0.1^3*log(q_t.^4);
[q_t,ep_t1] = meshgrid(q_t, ep_t1);
%P = meshgrid(p_r);
l_t = 0.4*q_t;              % Assuming 40% of the production quantity is labor cost
lev = p_t*w_t*l_t-a_t;
lev(lev<0)=0;

p_m = meshgrid(p_r);
p_ui = cumsum(p_m');   %The cumulative sum determines the likelihood of the realized price less than the determined price.
r_t = r_t+0.1*cumsum(p_r)+0.1^2*exp(lev-mean(lev)); % Adding default probability
inc = q_t.*ep_t1;
cost = (1+r_t).*(p_t*w_t*l_t-a_t);
c_bank = c'.*q_t.*p_ui;
%pi_t = inc - cost -c_bank;
pi_t = p_m'.*(q_t.*ep_t1-(1+r_t).*lev)-c'.*q_t.*p_ui; % Calculating the expected profit.

%max(inc(:))
%max(cost(:))
%max(cost_bank(:))
end