function [x,fval, e_pu] = player_opt(id, p_st,r_t,w_t,a_t, sim_opt)
%=========================================================================
% Function explanation:
%   This function updates the price
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
%   x: Optimized production quantity
%   fval: Production profit
%   e_pu: expected price.
%========================================================================
if sim_opt.mem =="Random"
    if id == 1
        i_pst = p_st;
    elseif id == 2
        m_cap = round(0.1*randi([300,size(p_st,1)])); % Define the capacity of memory, the max. capacity is only 10% of the history.
        i_pst = p_st(end-m_cap:end,:); % Short memory
    elseif id == 3
        i_pst = maxk(p_st,randi([100,size(p_st,1)])); % Only remember the highest price.
    elseif id == 4
        i_pst = minxk(p_st,randi([100,size(p_st,1)])); % Only remember the lowest 
    else
        s_size= randi([100,size(p_st,1)]);       % Define a random range of sample size
        i_pst = datasample(p_st,s_size); % Fuzzy memory: Random sampling from memory. 
    end
elseif sim_opt.mem =="Max"
        if id == 1
        i_pst = p_st;
    elseif id == 2
        m_cap = round(0.1*size(p_st,1)); % Define the capacity of memory, the max. capacity is only 10% of the history.
        i_pst = p_st(end-m_cap:end,:); % Short memory
    elseif id == 3
        i_pst = maxk(p_st,size(p_st,1)); % Only remember the highest price.
    elseif id == 4
        i_pst = minxk(p_st,size(p_st,1)); % Only remember the lowest 
    else
        s_size= randi([100,size(p_st,1)]);       % Define a random range of sample size
        i_pst = datasample(p_st,s_size); % Fuzzy memory: Random sampling from memory. 
        end
end
p_t = p_st(end,:);                % Current price level
[p_r, est_p, p_dist] = kdf(i_pst); % Using bandwidth for the ease of computation.
e_pu = p_r'*est_p;                % Compute the expected price according to the probability distribution.
[x,fval] = profit_max(est_p, p_r, r_t, p_t, w_t, a_t);
end
