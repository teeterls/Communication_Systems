function [s_filtrada] = salida_filtro(Su, T, Ts, Filtro, SNRdB)
%
% Esta funci�n recibe una secuencia de s�mbolos unitarios, deltas digitales, con amplitudes 
% aleatorias dentro del alfabeto {+1, -1}, a�ade ruido blanco gausiano a la secuencia y
% la introduce en un banco de filtros definidos por su respuesta impulsional. Para un correcto
% funcionamiento de la funci�n el tiempo de muestreo de la funci�n tiene que ser el mismo que el
% empleado para generar la respuesta impulsional de los filtros
%
% s_filtrada    Matriz con tantas columnas como filtros. Cada columna es la se�al de salida del
%               filtro. El n�mero de filas es NxT/Ts
%
% Su            secuencia aleatoria de s�mbolos unitarios
% Ts            Periodo de muestreo (s)
% T             Periodo de s�mbolos (s)
% Filtro        Matriz cuyas columnas son las respuestas impulsionales de un banco de filtros a una 
%               secuencia de N s�mbolos unitarios aleatorios con amplitudes del alfabeto {+1, -1} 
% SNRdB         relaci�n se�al ruido, en dB, de la se�al a la entrada del banco de filtros
%
%
% N�mero de muestras por s�mbolo
  Nmps = round(T/Ts);
%
% N�mero de s�mbolos
  N = length(Su)/Nmps;
%
  t  = -N/2*T:Ts:N/2*T-Ts;
%
% Se a�ade ruido a la secuencia aleatoria de s�mbolos unitarios
  Su_con_ruido = awgn(Su, SNRdB, 'measured');
%
% Filtrado de la se�al Su por el banco de los cuatro filtros
  ltdefiltro = size(Filtro,1);                      % Es un n�mero impar
  s_filtrada = zeros(length(Su)+ltdefiltro-1, 4);
  for ip=1:size(Filtro,2)
      s_filtrada(:,ip) = conv(Su_con_ruido, Filtro(:,ip));
  end
%
% Recorte en ambos extremos de las series temporales para que su longitud sea igual a la de la 
% secuencia de s�mbolos unitarios
  s_filtrada = s_filtrada((ltdefiltro-1)/2 +1 : end-(ltdefiltro-1)/2 ,:);

end

