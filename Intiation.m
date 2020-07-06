clear;
clc;
close all;

%%                         Motivation of this project
%=========================================================================
%  * This project simulates Greenwald and Stiglitz (1993) model.
%  * The paper concludes the possibility of different economic cycle by
% monitoring the change in firms' equity level.
%  * While this project takes one step further, this project aims at
%  explaining why price trend normally resemble Brownian motion.
%  * Taking consideration of suppliers may possess different information
%  set, this project argues this as the source of stochastic price trend.


% Developed by FokMC, Hubert. 09May2019
%=========================================================================
%% Step (1): Defining the initial paramters
%  Parameters:
%       n_s : Number of suppliers in the economy.
%       a_0 : Initial capital of each suppliers
%       w_0 : Initial wage level
%       l_0 : Initial labor supply quantity, assume to be constant
%       temporarily.
%       sim.opt.theme: The theme of the game which can be ranged from (i)
%                      All, (ii) Econometrician, (iii) 3 players, (iv) Random, and (v)
%                      Chaos.
%       sim.opt.memory: Two options, 'Random' or 'Max', which defines the
%                       memory capacity of the player.
%       sim.opt.int: Define the motion of interest rate which can be '
%                     Constant' or 'Stochastic'. 

a_0 = 10000; % Be aware that initial capital must be sufficient to generate a concave profit function.
w_0 = 1;   % [Temp] Not sure what to put here for the wage. 
n_s = 5;  % 3 types of players, explain below.
t_end = 1000; % The time step of the game.
T = 10000; % Defines the length of history. [Longer length longer computation time.]

%% [1] Constant interest rate with full history memory.
%% (a) The usual game
n_s = 5;
sim_opt.theme="All";
sim_opt.int="Constant";
sim_opt.mem='Max';
[P_st1a, A_t1a] = simulation(a_0,w_0,n_s,T, t_end, sim_opt);
%% (b) Game with random types of players
n_s = 30;
sim_opt.theme="Random";
sim_opt.int="Constant";
sim_opt.mem='Max';
[P_st1b, A_t1b] = simulation(a_0,w_0,n_s,T, t_end, sim_opt);
%% (c) The 3 players game
n_s = 3;
sim_opt.theme="3 players";
sim_opt.int="Constant";
sim_opt.mem='Max';
[P_st1c, A_t1c] = simulation(a_0,w_0,n_s,T, t_end, sim_opt);

%% (d) Chaos game 
n_s =30;
sim_opt.theme="Chaos";
sim_opt.int="Constant";
sim_opt.mem='Max';
[P_st1d, A_t1d] = simulation(a_0,w_0,n_s,T, t_end, sim_opt);

%%                      [2] Constant interest rate but limited memory
%% (a) Chaos
n_s =30;
sim_opt.theme="Chaos";
sim_opt.int="Constant";
sim_opt.mem="Random";
[P_st2a, A_t2a] = simulation(a_0,w_0,n_s,T, t_end, sim_opt);
%%                      [3] Stochastic interest rate with limited memory.

%% (a) Chaos 
n_s =30;
sim_opt.theme="Chaos";
sim_opt.int="Stoch";
sim_opt.mem="Random";
[P_st3a, A_t3a] = simulation(a_0,w_0,n_s,T, t_end, sim_opt);
%% (b) Usual game
n_s = 5;
sim_opt.theme="All";
sim_opt.int="Stoch";
sim_opt.mem='Max';
[P_st3b, A_t3b] = simulation(a_0,w_0,n_s,T, t_end, sim_opt);
%% (c) Chaos game with full memory
n_s =30;
sim_opt.theme="Chaos";
sim_opt.int="Stoch";
sim_opt.mem="Max";
[P_st3c, A_t3c] = simulation(a_0,w_0,n_s,T, t_end, sim_opt);
%% Step (6) Visualizing the capital motion and price change.
agg_A = sum(A,1);
subplot(2,1,1);
plot(1:size(p_st,1), p_st);
title('Price trend');
ylabel('Price');
%xline(h_rec ,'--r');

subplot(2,1,2);
plot(agg_A(:,1:end-1),agg_A(:,2:end));
title('Capital Motion')
ylabel('A(t)');
xlabel('A(t-1)');
%%
figure(4);
hist(categorical(id_v));
title('Histogram of player type');

%% Optional: Mesuring the randomness of the data
%========================================================================
% Following uses the entropy function to examine the randomness of the
% data. The objective is to provide an objective method to determine the
% steadiness of the econnomy.
% Source: https://www.mathworks.com/matlabcentral/fileexchange/28692-entropy
%========================================================================
H=[]; % Matrix storing the entropy value of each series
P = [P_st1a, P_st1b, P_st1c, P_st1d, P_st2a, P_st3a, P_st3b, P_st3c]; % Construct a matrix for analysis.
for i = T-t_end-100:size(P,1) % 100 is an abitrary number to make sure sufficient samples have been provided to estimate the kernel density.
    for j = 1:size(P,2)
        [prob, p_var,~]=kdf(P(1:i,j));
        H(i-99,j)=entropy([p_var, prob]);
    end
end
figure;
plot(1:size(H,1),H);
ylabel('Entropy');
x_label('Steps');
title('Entropy of price data');