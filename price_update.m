function g_p = price_update(i_pt, i_qt)
%=========================================================================
% Function explanation:
%   This function updates the general price level by weighting individual
%   price level with market sharing or production quantity.
%
% Function input:
%   i_pt: individual price level vector in time t.
%   i_qt: individual production quantity vector in time t.
%========================================================================

% Aligning vector dimension.
[p_m, p_n] = size(i_pt); 
if p_m*p_n~=max(p_m, p_n)
    frpintf(' Error: Price should either be column or row vector!');
elseif p_m>p_n          %If price vector is a column vector
    i_pt = i_pt';       %Transforming into row vector.
end

[q_m, q_n] = size(i_qt);
if q_m*q_n~=max(q_m, q_n)
    frpintf(' Error: Price should either be column or row vector!');
elseif q_m<q_n          %If quantity is a row vector
    i_qt = i_qt';       %Transforming into column vector.
end

i_qt = i_qt./sum(i_qt); % Generate the weights of production quantity.
g_p = i_pt*i_qt;
end
