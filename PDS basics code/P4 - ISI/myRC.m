function h_t_RC = myRC(alpha,t)

Num = cos(alpha*pi*t);
Den = (1-(2*alpha*t).^2);
cosDenZero = find(abs(Den)<10^-10);
cosOp = Num./Den;
cosOp(cosDenZero) = pi/4;

h_t_RC = sinc(t).*cosOp;

