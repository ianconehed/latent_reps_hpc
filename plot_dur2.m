if l == 1
    figure('Position', [300 100 1200 800]);
elseif mod(l,200) == 0 %&&l>2000
    subplot(3,3,1)
    imagesc(u_k)
    title('u_{k}')
    ylabel('input neuron #')
    xlabel('time')
    colorbar
    subplot(3,3,2)
%     imagesc(M_ik')
%     title('M_ik')
%     ylabel('presynaptic neuron')
%     xlabel('postsynaptic neuron')
%     colorbar
    imagesc(a_fun)
    title('a_{fun}')
    ylabel('i')
    xlabel('time')
    colorbar
    subplot(3,3,3)
    imagesc(W_ij)
    title('W_{ij}')
    ylabel('presynaptic neuron')
    xlabel('postsynaptic neuron')
    colorbar
    subplot(3,3,4)
    imagesc(s_i)
    title('s_{i}')
    ylabel('conj. neuron #')
    xlabel('time')
    colorbar
    subplot(3,3,5)
    imagesc(a_i)
    title('a_{i}')
    ylabel('i')
    xlabel('time')
    colorbar
    subplot(3,3,6)
    imagesc(beta_list)
    title('beta_i')
    ylabel('i')
    xlabel('time')
    colorbar
    subplot(3,3,7)
    imagesc(Q_li)
    title('Q_li')
    ylabel('presynaptic neuron')
    xlabel('postsynaptic neuron')
    colorbar
    subplot(3,3,8)
    imagesc(v_policy)
    title('v_{policy}')
    ylabel('i')
    xlabel('time')
%     ylim([0 1])
    colorbar
    subplot(3,3,9)
    imagesc(v_l)
    title('v_{l}')
    ylabel('i')
    xlabel('time')
    colorbar
    drawnow
    disp(l)
end