function y = phi2(x,center,squish,amp)
y = amp*.5*(tanh(squish*(x-center)));
end