clear all
close all

rng(6)

%% initialization of parameters/matrices
run('param_init2.m')

%% creation of presynaptic inputs
run('input_init.m')

%% trial loop
for l = 1:num_trials
    %choose a cue
    cue_given = cues{l};
    u_k = PF_map; 
    [~,ind_t] = max(u_k,[],2,'linear');
    [row,col] = ind2sub([N track_length],ind_t);
    plat_mat = zeros(N,track_length);
    for p = 1:N
        plat_mat(row(p),col(p)) = 1;
    end
    plat_mat(:,1) = 0;    
    
    %induction protocol
    if cue_given == 'L'
        u_k(11:20,:) = 0;
        plat_mat(11:20,:) = 0;
        plat_mat(31:2:90,:) = 0; %plateaus only after left cue
    elseif cue_given == 'R'
        u_k(1:10,:) = 0;
        plat_mat(1:10,:) = 0;
        plat_mat(32:2:90,:) = 0; %plateaus only after right cue
    end
    
    s_i(:,1) = M_ik*u_k(:,1);
    for x_pos = 1:100
        %% neural dynamics
        if x_pos>1
            da = -a_i(:,x_pos-1)/tau_a + W_ij'*s_i(:,x_pos-1);
            a_i(:,x_pos) = a_i(:,x_pos-1) + da;
        else
            a_i(:,x_pos) = W_ij'*s_i(:,1);
        end
        a_fun(:,x_pos) = phi(a_i(:,x_pos),5,1,1);
        a_loc = a_fun(:,x_pos);
        beta = phi(sum(W_ij,1)',1.4,5,1);
        alpha = 1-beta;
        beta_l(:,l) = beta;
        beta_list(:,x_pos) = beta.*a_loc;
        s_i(:,x_pos) = M_ik*u_k(:,x_pos).*(beta.*a_loc + alpha);
        s_burst(:,x_pos) = s_i(:,x_pos);
        sum_temp = sum(plat_mat,2);
        s_burst(sum_temp==0,x_pos) = 0;

        if x_pos>1
            de = -e_i(:,x_pos-1)/tau_e + s_i(:,x_pos);
            e_i(:,x_pos) = e_i(:,x_pos-1) + de;
            dea = -e_ia(:,x_pos-1)/tau_ea + s_i(:,x_pos);
            e_ia(:,x_pos) = e_ia(:,x_pos-1) + dea;
        else
            e_ia(:,x_pos) = s_i(:,1);
        end

        %% choice point
        if x_pos == 60
            if l>0 && rand <.9
                if (sum(v_policy(1,41:60)) + 5*randn) > (sum(v_policy(2,41:60)) + 5*randn)
                    goal_choice = 'L';
                else
                    goal_choice = 'R';
                end
            else
                goal_choice = rand_goals{l};
            end
            

            if goal_choice == cue_given
                rew_mod = 1;
%                 rew_mod = randi([0,1]); %uncomment for random reward
                correct_mat(l) = 1;
                if goal_choice == 'L'
                    choice_mat(1,l) = 1;
                    u_k(111:120,:) = 0;
                    plat_mat(111:120,:) = 0;
                else
                    choice_mat(2,l) = 1;
                    u_k(101:110,:) = 0;
                    plat_mat(101:110,:) = 0;
                end
            else
                rew_mod = 0;
%                 rew_mod = randi([0,1]); %uncomment for random reward
                correct_mat(l) = 0;
                if goal_choice == 'L'
                    choice_mat(3,l) = 1;
                    u_k(111:120,:) = 0;
                    plat_mat(111:120,:) = 0;
                else
                    choice_mat(4,l) = 1;
                    u_k(101:110,:) = 0;
                    plat_mat(101:110,:) = 0;
                end
            end
        end

        %% action selection
        if x_pos > 20 && x_pos<71
            del_v_l = (-v_l(:,x_pos-1) + 1*Q_li*s_i(:,x_pos) + .5*I_ij*v_l(:,x_pos-1) + .75*randn(2,1))*(dt/tau_v);
            %% works if e_i_learning = e_i
            v_l(:,x_pos) = v_l(:,x_pos-1) + del_v_l;
            v_l(v_l>1) = 1;
            if x_pos>60
                if goal_choice == 'L'
                    v_l_fixed(:,61:70) = repmat([1 0],10,1)';
                elseif goal_choice == 'R'
                    v_l_fixed(:,61:70) = repmat([0 1],10,1)';
                end
            end
            [maxai, maxaidx] = max(v_l(:,x_pos) + .2*randn(2,1));
            v_policy(:,x_pos) = zeros(2,1);
            v_policy(maxaidx,x_pos) = 1;
        end
    end

    for i = 1:N
        if cue_given == 'L'
            left_fr(i,l) = max(s_i(i,:));
            left_fr_full(i,:,l) = s_i(i,:);
        elseif cue_given == 'R'
            right_fr(i,l) = max(s_i(i,:));
            right_fr_full(i,:,l) = s_i(i,:);
        end
    end
    %% learning
    W_ijl(:,:,l) = W_ij;
    M_ikl(:,:,l) = M_ik;
    Q_lil(:,:,l) = Q_li;
    
    e_i_learning = e_ia;
    e_i_learning(1:30,:) = e_ia(1:30,:)/10;

    if l>0*num_trials/8
        %plateaus induced
        del_w_i = (rew_mod-r_0)*eta_w*s_burst*e_i' - lambda_w*W_ij';
        del_m_i = eta_m*((plat_mat)*(u_k)');
        del_q_i = (rew_mod-r_q)*(eta_q*v_l_fixed*e_i_learning');
    else
        %no learning
        del_w_i = 0*(rew_mod-r_0)*(eta_w*s_burst*e_i' - lambda_w*W_ij');
        del_m_i = 0*((plat_mat)*(u_k)');
        del_q_i = 0*(rew_mod-r_q)*(eta_q*v_l_fixed*e_i_learning');
    end
    
    
    M_ik = M_ik + del_m_i';
    M_ik = M_ik.*(M_ik>0);
    M_ik(M_ik>.75) = .75;
    M_ik = eye(N,N_inp); %comment out for input learning
    
    
%     if l<4*num_trials/8 %uncomment for hold-out neurons
%         del_w_i(80,:) =  0;
%         M_ik(:,80) =  0;
%         del_w_i(81,:) =  0;
%         M_ik(:,81) =  0;
%     end
    
    W_ij = W_ij + del_w_i';
    W_ij = W_ij.*(W_ij>0);
    W_ij(W_ij>.15) = .15;

    Q_li = Q_li + del_q_i;
    Q_li(Q_li>.15) = .15;
    Q_li(Q_li<-.15) = -.15;

    
    %% plotting
    run('plot_dur2.m')
end

%%
run('plot_after.m')