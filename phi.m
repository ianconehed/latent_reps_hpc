function y = phi(x,center,squish,amp)
y = amp*.5*(tanh(squish*(x-center))+1);
end