pause(0.1)

[~,ccl] = find(sum(left_fr,1));
[~,ccr] = find(sum(right_fr,1));

len_cc = min([length(ccl) length(ccr)]);

MM = movmean(correct_mat,[100 1]);
% figure;plot(MM)
% ylim([0 1])


pause(0.1)

NNL = movmean(choice_mat(:,ccl),[100 1],2);
NNR = movmean(choice_mat(:,ccr),[100 1],2);
figure;
subplot(2,2,1)
plot(NNL(1,:)./(NNL(1,:)+NNL(4,:)))
ylim([0 1])
title('correct left goal choice (LL)')
subplot(2,2,4)
plot(NNR(2,:)./(NNR(2,:)+NNR(3,:)))
ylim([0 1])
title('correct right goal choice (RR)')
subplot(2,2,2)
plot(NNR(3,:)./(NNR(2,:)+NNR(3,:)))
ylim([0 1])
title('incorrect left goal choice (RL)')
subplot(2,2,3)
plot(NNL(4,:)./(NNL(1,:)+NNL(4,:)))
ylim([0 1])
title('incorrect right goal choice (LR)')

pause(0.1)
figure('Position', [300 100 1200 800]);
diff_fr = left_fr-right_fr;
left_fr_only = left_fr(:,ccl(1:len_cc));
right_fr_only = right_fr(:,ccr(1:len_cc));
diff_fr_only = left_fr_only(31:90,:)-right_fr_only(31:90,:);
split_crit = abs(diff_fr_only)>0.8;
[~,ind_split_left] = max(split_crit(2:2:60,2:len_cc),[],2);
[~,ind_split_right] = max(split_crit(1:2:60,2:len_cc),[],2);
left_move = movmean(left_fr_only,1,2);
right_move = movmean(right_fr_only,1,2);
left_fr_only_full1 = reshape(left_fr_full(81,:,ccl),100,[]);
right_fr_only_full1 = reshape(right_fr_full(81,:,ccr),100,[]);
left_fr_only_full2 = reshape(left_fr_full(80,:,ccl),100,[]);
right_fr_only_full2 = reshape(right_fr_full(80,:,ccr),100,[]);

% left_move = movmean(left_fr(:,ccl),400,2);
% right_move = movmean(right_fr(:,ccr),400,2);
% left_move = interp1(1:length(left_move),left_move',1:(length(left_move)/num_trials):length(left_move))';
% right_move = interp1(1:length(right_move),right_move',1:(length(right_move)/num_trials):length(right_move))';
% len_move = min([length(left_move), length(right_move)]);
% diff_move = left_move(:,1:len_move)-right_move(:,1:len_move);
diff_move = left_move(:,1:len_cc)-right_move(:,1:len_cc);
% diff_move = left_move(:,1:1996)-right_move(:,1:1996);
subplot(2,1,1)
title('representation')
scatter(ccl(1:len_cc),mean(diff_move(31:2:90,:),1),'ko')
hold on
scatter(ccr(1:len_cc),mean(diff_move(32:2:90,:),1),'ro')
hold off
% scatter(ccl(1:1000),diff_move(88,:))
% hold on
% scatter(ccr(1:1000),diff_move(89,:))
% hold off
ylabel('splitness (fr_{L} - fr_{R})')
xlabel('trial #')
% xlim([0 1000])
% ylim([-1 1])
% xlim([0 num_trials])
subplot(2,1,2)
title('behavior')
plot(MM)
ylim([0 1])
% xlim([0 num_trials])
% xlim([0 1000])
ylabel('fraction correct turns')
xlabel('trial #')

figure;
subplot(2,2,1)
imagesc(right_fr_only_full1)
xlabel('trial #')
ylabel('position on track')
title('neuron 81 on right trials')
xlim([900 1100])
subplot(2,2,2)
imagesc(left_fr_only_full1)
xlabel('trial #')
ylabel('position on track')
title('neuron 81 on left trials')
xlim([900 1100])
subplot(2,2,3)
imagesc(right_fr_only_full2)
xlabel('trial #')
ylabel('position on track')
title('neuron 80 on right trials')
xlim([900 1100])
subplot(2,2,4)
imagesc(left_fr_only_full2)
xlabel('trial #')
ylabel('position on track')
title('neuron 80 on left trials')
xlim([900 1100])
% 
figure;
subplot(1,2,1)
imagesc(left_fr_only(31:90,:))
xlabel('trial #')
ylabel('neuron number')
title('max fr on left trials')
% xlim([1 300])
colorbar
subplot(1,2,2)
imagesc(right_fr_only(31:90,:))
xlabel('trial #')
ylabel('neuron number')
colorbar
title('max fr on right trials')
% xlim([1 300])
% 
% 
figure;
% ind_split_right(26) = ind_split_right(26)-250;
% temp_split = ind_split_right(26);
histogram((ind_split_left),'BinWidth',20);
% xticks(0:10:200)
% hold on
% histogram((ind_split_right),'BinWidth',6);
% hold on
% histogram((temp_split-62.5),'BinWidth',6);
% hold off
% xlim([0 200])
% 
% figure;
% subplot(2,1,1)
% imagesc(reshape(W_ijl(:,81,ccr(1:500)),N,500))
% xlabel('trial #')
% ylabel('presynaptic neuron #')
% title('Weights onto neuron 81')
% xlim([1 250])
% subplot(2,1,2)
% imagesc(left_fr_only_full1)
% xlabel('trial #')
% ylabel('position on track')
% title('neuron 81 on right trials')
% xlim([1 250])
% 
% figure;
% subplot(2,1,1)
% imagesc(reshape(M_ikl(80,:,ccr(1:500)),N,500))
% xlabel('trial #')
% ylabel('presynaptic neuron #')
% title('Input weights onto neuron 80')
% xlim([1 25])
% subplot(2,1,2)
% imagesc(right_fr_only_full2)
% xlabel('trial #')
% ylabel('position on track')
% title('neuron 80 on right trials')
% xlim([1 25])
% 
% figure;
% plot(e_i(31,:))
% hold on
% plot(z_i(81,:))
% hold off
%%
figure;
for i = 1740:1:1750
    plot3(56:85,i*ones(1,30),right_fr_only_full1(56:85,i),'k-')
    hold on
    plot3(56:85,i*ones(1,30),left_fr_only_full1(56:85,i),'r--')
end

hold off
xlabel('position on track')
ylabel('trial number')
zlabel('firing rate')
view(225,45)


figure;
for i = 1:1:10
    plot3(56:85,i*ones(1,30),right_fr_only_full2(56:85,1025+i),'k-')
    hold on
    plot3(56:85,i*ones(1,30),left_fr_only_full2(56:85,974+i),'r--')
end

hold off
xlabel('position on track')
ylabel('trial number')
zlabel('firing rate')
view(225,45)
