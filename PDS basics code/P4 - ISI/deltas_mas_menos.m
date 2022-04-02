function Su = deltas_mas_menos(N, T, Ts)
%
% Esta función genera una secuencia de símbolos unitarios, deltas digitales, con amplitudes 
% aleatorias dentro del alfabeto {+1, -1}
%
% Su        secuencia de N símbolos unitarios. Es un vector de longitud NxT/Ts
% N         número de símbolos
% T         periodo de símbolo
% Ts        periodo de muestreo
% 
  Nmps = round(T/Ts);
%
  Tx = 2*(rand(1,N)>0.5)-1;  % Símbolos Tx
  Su = [Tx ; zeros(Nmps-1,length(Tx))];        
  Su = Su(:)';
%
% Centrado de la secuencia
  nc = floor(Nmps/2);
  Su =[zeros(1,nc) Su(1:length(Su)-nc)];
%
end

