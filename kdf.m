function [p_r, x, p_dist] = kdf(p_st, b_width)
%=========================================================================
% Function explanation:
%   This function, the Kernel Density Function (kdf), generates the distribution of the observed price data for
%   a partiuclar agnet.
%
% Function input:
%   p_st: Series of price data
%   b_width: The band width of the estimation kernel.
%
% Function output:
%   pdf : the probability distribution of a value.
%   p_val: the interval of esimated price.
%   p_r: the probability of estimated price.
%
% * Note that sourceful price data is highly recommended in order to
% generate a reliable estimation.
%========================================================================
[n_r,n_c] = size(p_st);
if nargin< 2
    fprintf(' Notice: Cannot identify the input value for bandwidth, the value will be automatically determined! \n');
    b_width = ((4*abs(std(p_st))^5)/3*n_r)^(1/5);
    fprintf('bandwidth: %.2f:', b_width);
end

if n_r <30
    fprintf('Warning: Less data may yield biased inference result!')
end

p_dist = fitdist(p_st,'Kernel','BandWidth',b_width); % Generate the probability density function of all observed data.
x = [min(p_st):1:max(p_st)]';                   % Defining the domain to plot the density function
p_r = pdf(p_dist, x);
%figure;
%plot(x,p_r,'-');                         % [Suspended]: Plotting function.
%title(' Kernel distribution of price');
end
