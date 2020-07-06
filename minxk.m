function l_p = minxk(p_st,n)
%=========================================================================
% Function explanation:
%   This function returns the lowest n member of an array.
%
% Function input:
%   p_st: Price data array
%   n:    Number of elements needed.

% Function ouput:
%   l_p: Target array
%========================================================================
y=sort(p_st,1,'ascend')
l_p=y(1:n, :);
end
