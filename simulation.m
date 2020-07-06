function [p_st, A] = simulation(a_0,w_0, n_s,T, t_end, sim_opt)
%=========================================================================
% Function explanation:
%   This function initiates the simulation with the input parameters,
%   recall price and interest rate data, if any, then perform optimization for each player 
%
% Function input:
%   a_0: Initial capital
%   w_0: Wage level
%   n_s: number of players
%   T: The length of the historical data
%   t_end: Duration of the game
%   sim_opt: controls the setup of the game
%       (i) sim_opt.theme: controls the type of players participating the
%       game
%       (ii)sim_opt.int: provides constant or stochastic interest rate
%       (iii)sim_opt.mem: defines the memory capacity of the player
%
% Function output:
%   p_st: simulated price data
%   A: simulated capital level.
%======================================================================== 
%% Step (1) Define the motion of interest
if sim_opt.int =="Constant"
    r_t = 0.03;
elseif sim_opt.int =='Stoch'
    if exist('BMR.xlsx', 'file') == 2 % Check if price data exist or not
        r_st = xlsread('BMR.xlsx');
        fprintf('Found price data in : \n');
        fprintf('%sf \n',pwd);
        figure;
        plot(1:size(r_st,1),r_st);
        ylabel('Interest rate');
        xlabel('Time step');
        title('Interest rate graph');
    else
        fprintf('Cannot find any data file in the directory. \n Now generating...\n'); 
        r_st = b_m(1,t_end)./100;% Generate 10000 historical data point.
        xlswrite('BMR.xlsx',r_st);
    end
else
    fprintf('Warning: Cannot recognise the input value!')
end
    
%% Step (2) Define the theme and players in the game
id = [1,2,3,4,5]; 
if sim_opt.theme == "All"
    if n_s ~= 5
        fprintf('Warning: Number of players must be 5! \n');
    else
        id_v = [1,2,3,4,5]; % Meaning all types of players will be involved in the game.
    end
elseif sim_opt.theme == "Random"
    id_v = datasample(id,n_s); % Games with random players.
elseif sim_opt.theme == "Econometrician"
    id_v = ones(1,n_s);
elseif sim_opt.theme =='3 players'
    if n_s ~= 3
        fprintf('Warning: Number of players must be 3! \n');
        RETURN
    elseif n_s ==3
        id_v = [1,2,5];
    end
end

%% Step (3) Generate random data point
% The model assumes agents are making decision according to Markov
% property, it means that agents determine the product price by examining
% the distribution of the historical distribution. Following generates
% series of historical price using Standard Brownian motion.

if exist('BMPrice.xlsx', 'file') == 2 % Check if price data exist or not
    p_st = xlsread('BMPrice.xlsx');
    fprintf('Found price data in : \n');
    fprintf('%sf \n',pwd);
    figure;
    plot(1:size(p_st,1),p_st);
    ylabel('Price');
    xlabel('Time step');
    title('Historical price');
else
    fprintf('Cannot find any data file in the directory. \n Now generating...\n'); 
    p_0 = 10;           % Define the initial price level, assuming to be 100.
    p_st = b_m(p_0, T);% Generate 10000 historical data point.
    h_rec = size(p_st,1);
    xlswrite('BMPrice.xlsx',p_st);
end 

%% Step (4) Multiplayer simulation
%
A = a_0*ones(n_s,1);
temp_pv =[];
temp_qv =[];
temp_prf =[];
for t = 1:t_end
    %t
    if sim_opt.theme=='Chaos'
        id_v = datasample(id,n_s);
        if t>1 && randi([0,1],1) == 1            % Randomly initiate change of player type.
            id_v = datasample(id,n_s);
        end
    end
    if sim_opt.int=="Stoch"
        r_t = r_st(t,1);
    end
    for i = 1:n_s
        a_0 = A(i,t);
        i_id = id_v(:,i);
        [x,fval,e_pu]=player_opt(i_id,p_st,r_t,w_0,a_0,sim_opt);
        temp_pv = [temp_pv;e_pu];
        temp_qv = [temp_qv;x];
        temp_prf = [temp_prf; fval];
    end
    g_p = price_update(temp_pv(t,:), temp_qv(t,:));
    A = [A, A(:,end)+temp_prf(t,:)./g_p] ;% Updating capital for real profit.
    A(A<0)=0;                        % For any company with negative capital will be bankrupted with capital 0.
    p_st = [p_st;g_p];
    
end
%% Step (5) Visualizing the capital motion and price change.
agg_A = sum(A,1);
figure;

subplot(3,1,1);
plot(1:size(p_st,1), p_st);
title('Price trend');
ylabel('Price');
xline(T,'--r');

subplot(3,1,2);
plot(agg_A(:,1:end-1),agg_A(:,2:end));
title('Capital Motion')
ylabel('A(t)');
xlabel('A(t-1)');

subplot(3,1,3);
hist(categorical(id_v));
title('Histogram of player type');

t_wrd = sprintf('Game:[ Type:%s, interest rate: %s memory: %s]', sim_opt.theme, sim_opt.int, sim_opt.mem)
sgtitle(t_wrd);

end
