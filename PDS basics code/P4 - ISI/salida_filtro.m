function [s_filtrada] = salida_filtro(Su, T, Ts, Filtro, SNRdB)
%
% Esta función recibe una secuencia de símbolos unitarios, deltas digitales, con amplitudes 
% aleatorias dentro del alfabeto {+1, -1}, añade ruido blanco gausiano a la secuencia y
% la introduce en un banco de filtros definidos por su respuesta impulsional. Para un correcto
% funcionamiento de la función el tiempo de muestreo de la función tiene que ser el mismo que el
% empleado para generar la respuesta impulsional de los filtros
%
% s_filtrada    Matriz con tantas columnas como filtros. Cada columna es la señal de salida del
%               filtro. El número de filas es NxT/Ts
%
% Su            secuencia aleatoria de símbolos unitarios
% Ts            Periodo de muestreo (s)
% T             Periodo de símbolos (s)
% Filtro        Matriz cuyas columnas son las respuestas impulsionales de un banco de filtros a una 
%               secuencia de N símbolos unitarios aleatorios con amplitudes del alfabeto {+1, -1} 
% SNRdB         relación señal ruido, en dB, de la señal a la entrada del banco de filtros
%
%
% Número de muestras por símbolo
  Nmps = round(T/Ts);
%
% Número de símbolos
  N = length(Su)/Nmps;
%
  t  = -N/2*T:Ts:N/2*T-Ts;
%
% Se añade ruido a la secuencia aleatoria de símbolos unitarios
  Su_con_ruido = awgn(Su, SNRdB, 'measured');
%
% Filtrado de la señal Su por el banco de los cuatro filtros
  ltdefiltro = size(Filtro,1);                      % Es un número impar
  s_filtrada = zeros(length(Su)+ltdefiltro-1, 4);
  for ip=1:size(Filtro,2)
      s_filtrada(:,ip) = conv(Su_con_ruido, Filtro(:,ip));
  end
%
% Recorte en ambos extremos de las series temporales para que su longitud sea igual a la de la 
% secuencia de símbolos unitarios
  s_filtrada = s_filtrada((ltdefiltro-1)/2 +1 : end-(ltdefiltro-1)/2 ,:);

end

