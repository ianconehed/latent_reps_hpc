pause(0.1)

MM = movmean(correct_mat,400);
% figure;plot(MM)
% ylim([0 1])


pause(0.1)

NN = movmean(choice_mat,400,2);
figure;
subplot(2,2,1)
plot(NN(1,:))
ylim([0 1])
title('correct left goal choice (LL)')
subplot(2,2,4)
plot(NN(2,:))
ylim([0 1])
title('correct right goal choice (RR)')
subplot(2,2,2)
plot(NN(3,:))
ylim([0 1])
title('incorrect left goal choice (RL)')
subplot(2,2,3)
plot(NN(4,:))
ylim([0 1])
title('incorrect right goal choice (LR)')

pause(0.1)
figure('Position', [300 100 1200 800]);
diff_fr = left_fr-right_fr;
[~,ccl] = find(sum(left_fr,1));
[~,ccr] = find(sum(right_fr,1));
left_move = movmean(left_fr,400,2);
right_move = movmean(right_fr,400,2);
% left_move = movmean(left_fr(:,ccl),400,2);
% right_move = movmean(right_fr(:,ccr),400,2);
% left_move = interp1(1:length(left_move),left_move',1:(length(left_move)/num_trials):length(left_move))';
% right_move = interp1(1:length(right_move),right_move',1:(length(right_move)/num_trials):length(right_move))';
% len_move = min([length(left_move), length(right_move)]);
% diff_move = left_move(:,1:len_move)-right_move(:,1:len_move);
diff_move = left_move-right_move;
subplot(2,1,1)
title('representation')
scatter(1:num_trials,diff_move(41,:))
hold on
scatter(1:num_trials,diff_move(42,:))
hold off
ylabel('splitness (fr_{L} - fr_{R})')
xlabel('trial #')
% ylim([-1 1])
xlim([0 num_trials])
subplot(2,1,2)
title('behavior')
plot(MM)
ylim([0 1])
xlim([0 num_trials])
ylabel('fraction correct turns')
xlabel('trial #')