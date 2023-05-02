if l == 1
    figure('Position', [300 100 1200 800]);
elseif mod(l,20) == 0
    subplot(3,3,1)
    imagesc(pos_map)
    title('x_{l}')
    ylabel('input neuron #')
    xlabel('time')
    colorbar
    subplot(3,3,2)
    imagesc(a_policy)
    title('a_{policy}')
    ylabel('presynaptic neuron')
    xlabel('time')
    colorbar
    subplot(3,3,3)
    imagesc(W_ij)
    title('W_{ij}')
    ylabel('presynaptic neuron')
    xlabel('postsynaptic neuron')
    colorbar
    subplot(3,3,4)
    imagesc(z_i)
    title('z_{i}')
    ylabel('conj. neuron #')
    xlabel('time')
    colorbar
    subplot(3,3,5)
    imagesc(y_i)
    title('y_{i}')
    ylabel('i')
    xlabel('time')
    colorbar
    subplot(3,3,6)
    imagesc(a_i_fixed)
    title('a_i_fixed')
    ylabel('i')
    xlabel('time')
    colorbar
    subplot(3,3,7)
    imagesc(Q_ij)
    title('Q_ij')
    ylabel('presynaptic neuron')
    xlabel('postsynaptic neuron')
    colorbar
    subplot(3,3,8)
    imagesc(e_i)
    title('e_{i}')
    ylabel('i')
    xlabel('time')
    colorbar
    subplot(3,3,9)
    imagesc(a_i)
    title('a_{i}')
    ylabel('i')
    xlabel('time')
    colorbar
    drawnow
end