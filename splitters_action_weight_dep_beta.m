clear all
close all

rng(9)

%% initialization of parameters/matrices
run('param_init2.m')
rng(9)

M_ik = eye(N,N_inp);
% M_ik = imresize(eye(N_inp),[N N_inp]);
M_ik_orig = M_ik;
M_ik = M_ik + 0*sprandn(N,N_inp,.1)/30;
% M_ik = M_ik_orig(randperm(N),:);
%% creation of presynaptic inputs
run('input_init.m')

%% trial loop
for l = 1:num_trials
    %choose a cue
    cue_given = cues{l};
    pos_map = PF_map;
    temp = PF_map;
        
    
    %induction protocol
    if cue_given == 'L'
%         goal_choice = rand_goals{l};
        r_stem = randi([31 90],[1 30]);
        pos_map(11:20,:) = 0;
        temp(11:20,:) = 0;
        temp(31:2:90,:) = 0;
%         temp(r_stem,:) = 0;
    elseif cue_given == 'R'
%         if l>num_trials/8
%             goal_choice = 'R';
%         else
%             goal_choice = rand_goals{l};
%         end
        r_stem = randi([31 90],[1 30]);
        pos_map(1:10,:) = 0;
        temp(1:10,:) = 0;
        if l<num_trials/8
            temp(32:2:90,:) = 0;
        else
            temp(31:90,:) = 0;
        end
%         temp(r_stem,:) = 0;
    end

    z_i(:,1) = M_ik_orig*pos_map(:,1);
    y_i(:,1) = 1*W_ij'*z_i(:,1);
    y_loc = y_i(:,1)>.05;
    for x_pos = 1:100
        %% neural dynamics
        y_i(:,x_pos) = 10*W_ij'*z_i(:,1);
        y_loc = y_i(:,x_pos)>.05;
        beta = phi(sum(W_ij,1)',.75,5,1);
%         beta = phi(sum(W_ij,1)',1,5,1);
        alpha = 1-beta;
        beta_list(:,x_pos) = beta.*y_loc;
        z_i(:,x_pos) = M_ik*pos_map(:,x_pos).*(beta.*y_loc + alpha);
        z_i_noise(:,x_pos) = M_ik*pos_map(:,x_pos).*(beta.*y_loc + alpha) + 0*randn(N,1)/30;
        z_temp(:,x_pos) = M_ik*temp(:,x_pos).*(beta.*y_loc + alpha);
%         z_i(:,x_pos) = z_i(:,x_pos).*(z_i(:,x_pos)>0);
%         z_temp(:,x_pos) = z_temp(:,x_pos).*(z_temp(:,x_pos)>0);

        if x_pos>1
            e_i(:,x_pos) = lambda*e_i(:,x_pos-1) + z_i(:,x_pos);
%             y_i(:,x_pos) = lambda*y_i(:,x_pos-1) + W_ij'*z_i(:,x_pos);
        else
            e_i(:,x_pos) = z_i(:,1);
%             y_i(:,x_pos) = 10*W_ij'*z_i(:,1);
        end
%         y_loc = y_i(:,x_pos)>2;
%         if l<3*num_trials/4
%             y_loc = y_i(:,1)>.05;
%         else
%             y_loc = y_i(:,1)>.05;
%         end
        
              %ISSUE HERE WITH A DYNAMIC Y FIX THIS
%             y_i(:,x_pos) = lambda*y_i(:,x_pos-1) + 10*W_ij'*z_i(:,x_pos);
%             y_i(:,x_pos) = 10*W_ij'*z_i(:,1);
%         beta = phi(sum(W_ij(:,x_pos)),.05,40,1);
        



        %% choice point
        if x_pos == 60
            if l>num_trials/8 && rand <.95 %&& l<num_trials/2
                if sum(a_policy(1,41:60))>sum(a_policy(2,41:60))
                    goal_choice = 'L';
                else
                    goal_choice = 'R';
                end
            else
                goal_choice = rand_goals{l};
            end


            if goal_choice == cue_given
                rew_mod = 1;
%                 rew_mod = randi([0 1]);
                correct_mat(l) = 1;
                if goal_choice == 'L'
                    choice_mat(1,l) = 1;
                    pos_map(111:120,:) = 0;
                    temp(111:120,:) = 0;
                else
                    choice_mat(2,l) = 1;
                    pos_map(101:110,:) = 0;
                    temp(101:110,:) = 0;
                end
            else
                rew_mod = 0;
%                 rew_mod = randi([0 1]);
                correct_mat(l) = 0;
                if goal_choice == 'L'
                    choice_mat(3,l) = 1;
                    pos_map(111:120,:) = 0;
                    temp(111:120,:) = 0;
                else
                    choice_mat(4,l) = 1;
                    pos_map(101:110,:) = 0;
                    temp(101:110,:) = 0;
                end
            end
        end

        %% action selection
        if x_pos > 40 && x_pos<71
            del_a_i = (-a_i(:,x_pos-1) + Q_ij*z_i(:,x_pos) + I_ij*a_i(:,x_pos-1) + randn(2,1)/1)*(dt/tau_a);
            a_i(:,x_pos) = a_i(:,x_pos-1) + del_a_i;
            a_i(:,x_pos) = a_i(:,x_pos).*(a_i(:,x_pos)>0);
            if x_pos>60
                if goal_choice == 'L'
                    a_i_fixed(:,x_pos) = [1 0];
                elseif goal_choice == 'R'
                    a_i_fixed(:,x_pos) = [0 1];
                end
            end       
        end
        [maxai, maxaidx] = max(a_i(:,x_pos).*(1 + rand(2,1)/10));
        a_policy(:,x_pos) = zeros(2,1);
        a_policy(maxaidx,x_pos) = 1;
    end
    
    z_i_old = z_i;
%     z_i= z_i_noise; %z_i.*(1 + randn(N,track_length)/10) +
%     randn(N,track_length)/30; NEED TO MAKE CHANGES TO INCLUDE NOISE

    for i = 1:N
        if cue_given == 'L'
            left_fr(i,l) = max(z_i(i,:));
            left_fr_full(i,:,l) = z_i(i,:);
        elseif cue_given == 'R'
            right_fr(i,l) = max(z_i(i,:));
            right_fr_full(i,:,l) = z_i(i,:);
        end
    end

    if goal_choice == cue_given
        if goal_choice == 'L'
            ll = e_i;
        else
            rr = e_i;
        end
    else
        if goal_choice == 'L'
            rl = e_i;
        else
            lr = e_i;
        end
    end

    %% learning
    if l<200000
        del_w_i = (rew_mod-.5)*(2*eta)*(z_temp)*e_i' - lambda_w*W_ij';
        W_ij = W_ij + del_w_i';
        W_ij = W_ij.*(W_ij>0);
        W_ij(W_ij>.05) = .05;
    else
        del_w_i = - 0*lambda_w*W_ij';
        W_ij = W_ij + del_w_i';
        W_ij = W_ij.*(W_ij>0);
        W_ij(W_ij>.05) = .05;
    end

%     if l==2000
%         M_ik(60:80,60:80) = 0;
%     end

    del_q_i = (rew_mod-.5)*(eta*500)*(a_i_fixed)*z_i_old'- lambda_q*Q_ij;
    Q_ij = Q_ij + del_q_i;
    Q_ij = Q_ij.*(Q_ij>0);

%     if mod(l,50) == 0 && l>2*num_trials/4 && l<4*num_trials/4
%         i_pick = randi(N);
%         k_pick = randi(N);
%         M_ik(i_pick,:) = M_ik_orig(k_pick,:);
%     end

    %% plotting
    run('plot_dur2.m')
end

%%
run('plot_after.m')

%%
% C1 = ll*ll';
% C2 = rr*rr';
% C3 = lr*lr';
% C4 = rl*rl';
% C_tot_rand = C1+C2+C3+C4;
% C_tot_policy = C1+C2-C3-C4;
% figure;subplot(1,2,1);imagesc(C_tot_rand);subplot(1,2,2);imagesc(C_tot_policy)
init_p = left_fr_full(:,:,1) + 0*randn(N,track_length)/20;
final_p = left_fr_full(:,:,3999)+ 0*randn(N,track_length)/20;

init_p = init_p.*(init_p>0);
final_p = final_p.*(final_p>0);

pause(0.1)
figure;
subplot(1,2,1)
imagesc(init_p)
subplot(1,2,2)
imagesc(final_p)
% [maxi, max_id] = max(init_p);

p1 = reshape(left_fr_full(61,:,:),[100, 4001]); 
p2 = reshape(right_fr_full(61,:,:),[100, 4001]);

I_ind1 = find(p1(50,:));
I_ind2 = find(p2(50,:));

p1_ind = p1(:,I_ind1)+ 0*randn(track_length,2018)/20;
p2_ind = p2(:,I_ind2) + 0*randn(track_length,1983)/20;
% p1_ind = p1_ind(:,1:1983);

p1_ind = p1_ind.*(p1_ind>0);
p2_ind = p2_ind.*(p2_ind>0);

p_full = [p1; p2];
% p_full = p_full + randn(size(p_full))/10;

pause(0.1)
figure;imagesc(p_full)
xlabel('trial #')

pause(0.1)
figure;
stdshade(p1_ind(:,1:10)',.2)