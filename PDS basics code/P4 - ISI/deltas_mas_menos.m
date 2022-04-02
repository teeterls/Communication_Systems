function Su = deltas_mas_menos(N, T, Ts)
%
% Esta funci�n genera una secuencia de s�mbolos unitarios, deltas digitales, con amplitudes 
% aleatorias dentro del alfabeto {+1, -1}
%
% Su        secuencia de N s�mbolos unitarios. Es un vector de longitud NxT/Ts
% N         n�mero de s�mbolos
% T         periodo de s�mbolo
% Ts        periodo de muestreo
% 
  Nmps = round(T/Ts);
%
  Tx = 2*(rand(1,N)>0.5)-1;  % S�mbolos Tx
  Su = [Tx ; zeros(Nmps-1,length(Tx))];        
  Su = Su(:)';
%
% Centrado de la secuencia
  nc = floor(Nmps/2);
  Su =[zeros(1,nc) Su(1:length(Su)-nc)];
%
end

