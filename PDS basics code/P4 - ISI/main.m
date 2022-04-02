clear; close all; format compact
%
%% 1. Respuesta impulsional y en frecuencia de varios filtros
%
%  A continuaci�n se definen varios filtros especificando mediante una funci�n su respuesta
%  impulsional con retardo nulo. Previamente se fijan los par�metros de simulaci�n
%
% Periodo de s�mbolo
  T = 1;    % (s)
%
% Frecuencia y periodo de muestreo
  fs = 10;      % (Hz)
  Ts = 1/fs;    % (s)
%
% N�mero de muestras por s�mbolo
  Nmps = round(T/Ts); 
%
% Vector de tiempo de definici�n de filtros, centrado en t=0
  Tf = 10;                              %(s)
  tdefiltro  = -Tf/2:Ts:Tf/2;
  ltdefiltro = length(tdefiltro);       % Es un n�mero impar
%
% Se definen cuatro filtros, cada uno como un vector temporal de Tf segundos de duraci�n.
% Los cuatro filtros se agrupan en una matriz de cuatro columnas, una columna por filtro
%
  Filtro = zeros(ltdefiltro, 4);
%
  alfa = 1;     Filtro(:,1)   = myRC(alfa,tdefiltro);
  alfa = 0.5;   Filtro(:,2)   = myRC(alfa,tdefiltro);
  alfa = 0;     Filtro(:,3)   = myRC(alfa,tdefiltro);
                Filtro(:,4)   = sinc(tdefiltro*1.5);
%
% Representaci�n de la respuesta impulsional de los cuatro filtros
  figure
  for ip =1:4
      plot(tdefiltro, (Filtro(1:ltdefiltro, ip))'); hold on;
      xlabel('t(s)');  ylabel('Respuesta impulsional');
  end
  grid on;
  legend('\alpha = 1', '\alpha = 0.5', '\alpha = 0', 'Filtro con ISI');
%
% Funci�n de transferencia de los cuatro filtros  
  Hfiltro = abs(fft(Filtro, ltdefiltro))/ltdefiltro;
  df      = fs/ltdefiltro;
%
% Ancho de banda equivalente de ruido de los cuatro filtros
  Hfiltro2 = Hfiltro.^2;
  Beq = (1/2)*sum(Hfiltro2,1)./Hfiltro2(1,1:4)*df;
  Beq = round(Beq,2);
%
% Representaci�n gr�fica espectral
  frec    = 0:df:2;
  figure
  for ip =1:4
      plot(frec, (Hfiltro(1:length(frec), ip))'); hold on;
      xlabel('f(Hz)');  ylabel('Respuesta en frecuencia');
  end
  grid on;
  legend(['\alpha = 1  '   '  Beq=' num2str(Beq(1)) ' (Hz)'], ...
         ['\alpha = 0.5'   '  Beq=' num2str(Beq(2)) ' (Hz)'], ...
         ['\alpha = 0  '   '  Beq=' num2str(Beq(3)) ' (Hz)'], ...
         ['Filtro con ISI' '  Beq=' num2str(Beq(4)) ' (Hz)']);
%
%% 2. Estudio del ISI sin ruido por medio de diagramas de ojo
%  
% N�mero de s�mbolos y vector asociado de tiempos centrado en t=0
  N  = 40;  
  t  = -N/2*T:Ts:N/2*T-Ts;
  Su = deltas_mas_menos(N, T, Ts);
  figure
  stem(t,Su);                % La longitud de Su es un n�mero par
%
% Filtrado de la se�al Su por el banco de los cuatro filtros
  s_filtrada = zeros(length(Su)+ltdefiltro-1, 4);
  figure;
  for ip=1:size(Filtro,2)
      s_filtrada(:,ip) = conv(Su, Filtro(:,ip));
      plot( (s_filtrada(:,ip))' );  hold on;    grid on;
  end
  xlabel('Muestras');  ylabel('Se�ales filtradas');
  legend('\alpha = 1', '\alpha = 0.5', '\alpha = 0', 'Filtro con ISI');
%
% Recorte en ambos extremos de las series temporales para que su longitud sea igual a la de la 
% secuencia de s�mbolos unitarios. En cada extremo se recorta la mitad de la duraci�n de la 
% respuesta impulsiva de los filtros.
  s_filtrada = s_filtrada((ltdefiltro-1)/2 +1 : end-(ltdefiltro-1)/2,:);
  figure
  plot(t,Su);  hold on; 
  for ip=1:size(Filtro,2)
      plot( t, (s_filtrada(:,ip))' );  hold on; grid on;
  end
  xlabel('t(s)');  ylabel('Se�ales filtradas');
  legend('Se�al de entrada, s�mbolos unitarios', '\alpha = 1', '\alpha = 0.5', '\alpha = 0', 'Filtro con ISI');
  title({'Los instantes de muestreo para detecci�n coinciden '  'con los picos de los s�mbolos unitarios'});
%
%  Diagramas de ojo
%
   Vmax = 2.1;
   dummmy = diagrama_ojo(Su, (s_filtrada(:,1))', N, T, Ts, ['Diagrama de ojo con \alpha = 1 '], Vmax);
   dummmy = diagrama_ojo(Su, (s_filtrada(:,2))', N, T, Ts, ['Diagrama de ojo con \alpha = 0.5 '], Vmax);
   dummmy = diagrama_ojo(Su, (s_filtrada(:,3))', N, T, Ts, ['Diagrama de ojo con \alpha = 0 '], Vmax  );
   dummmy = diagrama_ojo(Su, (s_filtrada(:,4))', N, T, Ts, ['Diagrama de ojo en filtro con ISI'], Vmax);
%
%% 3. Efecto del ruido en el diagrama de ojo
%
%  Se vuelve a generar una secuencia aleatoria y se a�ade ruido blanco y
%  gausiano con relaci�n se�al-ruido antes del filtrado de SNRdB
   N = 1000; 
   Su    = deltas_mas_menos(N, T, Ts);
   SNRdB = 8;
   [s_filtrada] = salida_filtro(Su, T, Ts, Filtro, SNRdB);
%
   dummmy = diagrama_ojo(Su, (s_filtrada(:,1))', N, T, Ts, ['Diagrama de ojo con \alpha = 1  SNR(dB) =' num2str(SNRdB)   ], Vmax);
   dummmy = diagrama_ojo(Su, (s_filtrada(:,2))', N, T, Ts, ['Diagrama de ojo con \alpha = 0.5  SNR(dB) =' num2str(SNRdB) ], Vmax);
   dummmy = diagrama_ojo(Su, (s_filtrada(:,3))', N, T, Ts, ['Diagrama de ojo con \alpha = 0  SNR(dB) =' num2str(SNRdB)   ], Vmax);
   dummmy = diagrama_ojo(Su, (s_filtrada(:,4))', N, T, Ts, ['Diagrama de ojo en filtro con ISI  SNR(dB) =' num2str(SNRdB)], Vmax);  

%
%% 4.Efecto del ISI en la tasa de error
%
%  Para calcular la tasa de error se define un vector de relaciones se�al-ruido. Ahora SNRdB es un 
%  vector. N se aumenta para calcular BER con fiabilidad
   N = 10000;
   SNRdB = 4:20;
   BER   = zeros(length(SNRdB),size(Filtro,2));
   Su    = deltas_mas_menos(N, T, Ts);
%
%  Un s�mbolo detectado es un "1" cuando el valor de la se�al en el instante de muestreo es mayor 
%  que 0, y "-1" en caso contrario. Como se aprecia en las figura 5, los instantes de muestreo son los 
%  comienzos de los s�mbolos unitarios, los instantes en que su valor es +1 o -1.
%
%  Vector de instantes de muestreo, es decir, �ndices en el vector t de los instantes de muestreo
   ind = find(Su~=0); 
%
%  Extracci�n de los picos {+1,-1] del vector de s�mbolos unitarios
   Su_muestreo = Su(ind);
%
   for ip = 1:length(SNRdB)
%
%       Se filtra la se�al de s�mbolos unitarios
        [s_filtrada] = salida_filtro(Su, T, Ts, Filtro, SNRdB(ip));
%       
%       Valores de las se�ales filtradas en los instantes de muestreo
        yM = zeros(N, size(s_filtrada,2));
        yM(1:N,:) = s_filtrada(ind,:);
%
%       Si el valor en los instantes de muestreo es mayor que 0 se asigna a +1, en caso contrario
%       a -1
        ind1 = find(yM>=0);
        ind2 = find(yM<0);
        yM(ind1) = 1;
        yM(ind2) = -1;
%
%       C�lculo de BER
        Su2 = repmat(Su_muestreo', 1, size(Filtro,2));
        Su2 = yM~=Su2;
        BER(ip,:) = sum(Su2,1)/N;
   end
   BER(find(BER<1e-5)) = NaN; 
   figure;
   for ip =1:size(Filtro,2);
        semilogy(SNRdB,BER(:,ip)); hold on
   end
   grid on;
   xlabel('SNR(dB)');   ylabel('BER')
   legend('\alpha = 1', '\alpha = 0.5', '\alpha = 0', 'Filtro con ISI');
  % nueva cambiando ind
  %  Para calcular la tasa de error se define un vector de relaciones se�al-ruido. Ahora SNRdB es un 
%  vector. N se aumenta para calcular BER con fiabilidad
   N = 10000;
   SNRdB = 4:20;
   BER   = zeros(length(SNRdB),size(Filtro,2));
   Su    = deltas_mas_menos(N, T, Ts);
%
%  Un s�mbolo detectado es un "1" cuando el valor de la se�al en el instante de muestreo es mayor 
%  que 0, y "-1" en caso contrario. Como se aprecia en las figura 5, los instantes de muestreo son los 
%  comienzos de los s�mbolos unitarios, los instantes en que su valor es +1 o -1.
%
%  Vector de instantes de muestreo, es decir, �ndices en el vector t de los instantes de muestreo
   ind = find(Su~=0); 
%
%  Extracci�n de los picos {+1,-1] del vector de s�mbolos unitarios
   Su_muestreo = Su(ind);
%
   for ip = 1:length(SNRdB)
%
%       Se filtra la se�al de s�mbolos unitarios
        [s_filtrada] = salida_filtro(Su, T, Ts, Filtro, SNRdB(ip));
%       
%       Valores de las se�ales filtradas en los instantes de muestreo
        yM = zeros(N, size(s_filtrada,2));
        yM(1:N,:) = s_filtrada(ind+3,:);
%
%       Si el valor en los instantes de muestreo es mayor que 0 se asigna a +1, en caso contrario
%       a -1
        ind1 = find(yM>=0);
        ind2 = find(yM<0);
        yM(ind1) = 1;
        yM(ind2) = -1;
%
%       C�lculo de BER
        Su2 = repmat(Su_muestreo', 1, size(Filtro,2));
        Su2 = yM~=Su2;
        BER(ip,:) = sum(Su2,1)/N;
   end
   BER(find(BER<1e-5)) = NaN; 
   figure;
   for ip =1:size(Filtro,2);
        semilogy(SNRdB,BER(:,ip)); hold on
   end
   grid on;
   xlabel('SNR(dB)con retardo 3 muestras');   ylabel('BER')
   legend('\alpha = 1', '\alpha = 0.5', '\alpha = 0', 'Filtro con ISI');
   

%
%% 5.Efecto del ISI en la tasa de error cuando adem�s de ruido blanco hay error en la elecci�n de
%  los instantes de muestreo
%

%
  function [ dummy ] = diagrama_ojo( Su, yt, N, T, Ts,  titulo, Vmax)
%
% Esta funci�n dibuja un diagrama de ojo espec�fico de la pr�ctica de ISI
%
% Su        Se�al de s�mbolos unitarios que se emplea para extraer el reloj de sincronismo
% yt        vector de se�al temporal. Su longitud es N*Nbit
% N         n�mero de bits, tiene que ser par
% T         periodo de s�mbolo
% Ts        periodo de muestreo
% titulo    t�tulo del diagrama
% Vmax      valor del m�ximo del eje vertical 
%
  Nbit  = round(T/Ts);
  reloj = Su.^2;
%
% Se buscan los instantes de los impulsos de reloj
  ind = find(reloj>0.5);
%
% Se toma como comienzo de tiempos el primer impulso de reloj, y como final de tiempos N-2 s�mbolos 
% despu�s
%
  ip_in  = ind(1)  ;  
  ip_fin = ip_in + (N-2)*Nbit -1;
  yt2    = yt(ip_in:ip_fin);
%
% Se descompone el vector yt en una matriz. Cada columna guarda las muestras de dos periodos de bit
  lg = length(yt2);
  t  = (0:1:2*Nbit-1)*Ts;
  yt_reshape = reshape(yt2,Nbit*2,lg/(2*Nbit));
  
  figure;
  plot(t,yt_reshape, '- .b');   
  title(titulo);
  xlabel('time');   ylabel('Amplitud'); 
  axis([0 (2*Nbit-1)*Ts -abs(Vmax) abs(Vmax)])
  grid on
  dummy = false; 

  end     




