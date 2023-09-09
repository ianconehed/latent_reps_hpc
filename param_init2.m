%% parameter initialization
dt = 1;
N_length = 50;
N_cue = 10;
N_rew = 10;
N_delay = 30;
N_inp = 2*N_length + 20;
N = 1*N_inp;
cue_length = 20;
rew_length = 20;
track_length = 100;
total_maze_size = track_length + cue_length + rew_length;
eta = .000015;
eta_w = 40*eta;
eta_q = 20*eta;
eta_m = 10000*eta;
tau_e = 10;
tau_ea = 20;
tau_a = 40;
tau_r = 50000;
sigma = track_length/20; %sigma for presynaptic gaussian
lambda_w = .025;
r_0 = 0.5;
r_q = 0.6;

tau_v = 10;

num_trials = 4001;
% num_trials = 8001;

cues = rand(1,num_trials)>.5;
cue_cell = {'L','R'};
cues = cue_cell(1+cues);

rand_goals = rand(1,num_trials)>.5;
goal_cell = {'L','R'};
rand_goals = cue_cell(1+rand_goals);

%% Weight matrices initialization
W_ij = rand(N)/10000;
W_ijl = zeros(N,N,num_trials);
W_ijl(:,:,1) = W_ij;
% M_ik = eye(N,N_inp);
M_ik = rand(N,N_inp)/10000;
M_ikl = zeros(N,N_inp,num_trials);
M_ikl(:,:,1) = M_ik;
Q_li = .0001*rand(2,N);
Q_lil = zeros(2,N,num_trials);
Q_lil(:,:,1) = Q_li;
a_i = zeros(N,track_length);
s_temp = zeros(N,track_length);
left_fr = zeros(N,num_trials);
right_fr = zeros(N,num_trials);
left_fr_full = zeros(N,track_length,num_trials);
right_fr_full = zeros(N,track_length,num_trials);
s_i = zeros(N,track_length);
e_i = zeros(N,track_length);
e_ia = zeros(N,track_length);
beta_list = zeros(N,track_length);
v_l = zeros(2,track_length);
v_policy = zeros(2,track_length);
v_l_fixed = zeros(2,track_length);
correct_mat = zeros(1,num_trials);
choice_mat = zeros(4,num_trials);
beta_l = zeros(N,num_trials);

I_ij = -0.25*ones(2);
I_ij = I_ij -diag(diag(I_ij));