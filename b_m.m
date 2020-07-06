function s_t = b_m(x_t,t)
%=========================================================================
% Function explanation:
%   This function generates series of historical data according to standard
%   brownian motion with Wiener noise process
%
% Function input:
%   x_t: An abitrary initial value.
%   t : time steps.
%========================================================================
if t > 100000
    fprintf('Warning: Huge data set requires longer time for optimization! \n');
end

s_t = zeros(t,1);
h = sqrt(1/t);
for i =1:t
    s_t(i+1,1) = s_t(i,1) +h*randn();
end
s_t = x_t.*(exp(s_t));
end