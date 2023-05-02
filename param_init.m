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
eta = .000005;
lambda = 1;%.975; % 1/eligibility time constant
sigma = track_length/20; %sigma for presynaptic gaussian

tau_a = 5;

num_trials = 4001;

cues = rand(1,num_trials)>.5;
cue_cell = {'L','R'};
cues = cue_cell(1+cues);

rand_goals = rand(1,num_trials)>.5;
goal_cell = {'L','R'};
rand_goals = cue_cell(1+rand_goals);

%% Weight matrices initialization
W_ij = rand(N)/10000;
M_ik = eye(N,N_inp);
Q_ij = .1*ones(2,N);
y_i = zeros(N,track_length);
z_temp = zeros(N,track_length);
left_fr = zeros(60,num_trials);
right_fr = zeros(60,num_trials);
z_i = zeros(N,track_length);
e_i = zeros(N,track_length);
beta_list = zeros(1,track_length);
a_i = zeros(2,track_length);
a_policy = zeros(2,track_length);
a_i_fixed = zeros(2,track_length);
correct_mat = zeros(1,num_trials);
choice_mat = zeros(4,num_trials);

I_ij = -0.25*ones(2);
I_ij = I_ij -diag(diag(I_ij));