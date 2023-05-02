[R_1] = zeros(N_length,track_length); %presynaptic input array

for i = 1:N_length
    R_1(i,:) = circshift(exp(-(((1:track_length)-(track_length/2))).^2/(2*(sigma^2))),round(i*(track_length/N_length))-(track_length/2));
end



R_1(30:50,1:30) = 0;
R_1(1:20,70:track_length) = 0;

M_ij = eye(2*N_length,2*N_length);
M_ij(1:2*N_cue,1:2*N_cue) = 0;
M_ij(1:N_cue,1:2:2*N_cue) = eye(N_cue);
M_ij(N_cue+1:2*N_cue,1:2:2*N_cue) = eye(N_cue);

M_ij(2*N_cue+1:2*N_cue+2*N_delay,2*N_cue+1:2*N_cue+2*N_delay) = 0;
M_ij(2*N_cue+1:2*N_cue+2*N_delay,2*N_cue+1:2*N_cue+2*N_delay) = eye(2*N_delay);
% M_ij(2*N_cue+N_delay+1:2*N_cue+2*N_delay,2*N_cue+1:2:2*N_cue+2*N_delay) = eye(N_delay);


M_ij(2*N_cue+2*N_delay+1:2*N_cue+2*N_delay+2*N_rew,2*N_cue+2*N_delay+1:2*N_cue+2*N_delay+2*N_rew) = 0;
M_ij(2*N_cue+2*N_delay+1:2*N_cue+2*N_delay+N_rew,2*N_cue+2*N_delay+1:2:2*N_cue+2*N_delay+2*N_rew) = eye(N_rew);
M_ij(2*N_cue+2*N_delay+N_rew+1:2*N_cue+2*N_delay+2*N_rew,2*N_cue+2*N_delay+1:2:2*N_cue+2*N_delay+2*N_rew) = eye(N_rew);

% R_2 = M_ij*R_1;
R_2 = imresize(R_1,[2*N_length,track_length]);

R_2 = M_ij*R_2;



PF_map = [R_2(1:2*N_cue,:); zeros(10,track_length); R_2(2*N_cue+1:2*N_length-2*N_rew,:);...
    zeros(10,track_length); R_2(2*N_length-2*N_rew+1:2*N_length,:)];