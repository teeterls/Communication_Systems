%%  Práctica 1 (I): Demodulación Digital en Banda Base
%% 
% Maria José Medina y Teresa González
%%
%% 3. Demodulador de un símbolo
clear all;
close all; 
%% Ejercicio 2.1
%%
% Las señales recibidas en el demodulador coinciden con las señales
% moduladas (s1) y s(2) debido a la ausencia de ruido. Para representarlas
% definimos el periodo T(s), periodo de muestreo T (s/muestras) y el
% vector tiempo (s).
T=10*10^-3;
Ts=T/20;
t=0:Ts:T-Ts;

%%
% Símbolos utilizados
s1 = ones(1, T/Ts);
s2 = [ones(1,T/(2*Ts)), - 1*ones(1,T/(2*Ts))];

%%
% Salida de los dos correladores para s1 mediante la funcion correlatorType.
[r1,r2]= correlatorType(T,Ts,s1);

%%
% Representacion salida correladores para s1 en función de t.
figure
plot(t, r1)
hold on
plot(t, r2, 'r')
title('Salida correladores de s1')
xlabel('tiempo(s)')
ylabel('valor correlacion')
legend('r1', 'r2')
%% 
% Como se puede observar, la correlación de s1 con la base1 y con la base2 
% coincide hasta la mitad del periodo de símbolo (t=0.005 s). 
% Esto se debe a que ambas señales base son iguales.
% Sin embargo, tras ese instante, las señales base son distintas, aumentando la correlación de s1
% con la base1 (por ser s1 proporcional a esta) y disminuyendo con la base 2. 
% De hecho, ya que las bases son ortogonales, la correlación de s1 con la base2
% disminuye hasta 0 al final del periodo. Por otro lado, la correlacion entre s1 y la
% base1 alcanza su máximo al final del periodo con un valor de 0.01.

%% 
% Representacion salida correladores para s2 en función de t.
[r1,r2] = correlatorType(T,Ts,s2);

figure
plot(t, r1)
hold on
plot(t, r2, 'r')
title('Salida correladores de s2')
xlabel('tiempo(s)')
ylabel('valor correlacion')
legend('r1', 'r2')
%%
% En este caso, observamos el efecto opuesto al caso anterior, ya que s2 es
% proporcional a la base2, por lo que a partir de la mitad del periodo
% hasta el final, la correlacion entre s2 y la base1 disminuye a 0, y con
% la base2 alcanza su máximo con un valor de 0.01.
%%

%% Ejercicio 2.2
%%
% Se genera ruido blanco gaussiano con media 0 y desv típica 0.5,
% utilizando la función randn. Se utilizan 10000 puntos.
mu=0;
sigma=0.5;
noise=sigma*randn(1,10000)+mu;
figure
histogram(noise)
xlabel('valor')
ylabel('frecuencia absoluta')
title('histograma ruido blanco gaussiano')
%figure
%plot(noise);
%%
% A continuación, se genera ruido blanco gaussiano con 20 muestras y se
% añade a las señales recibidas, para simular un canal no ideal.
N=20;
noise=sigma*randn(1,N)+mu;
s1_n=s1+noise;
s2_n=s2+noise;
%%
% Representación señales recibidas + ruido.
figure
plot(t,s1_n)
hold on
plot(t,s2_n)
xlabel('tiempo(s)')
ylabel('amplitud')
title('señal recibida + ruido')
legend('s1_n', 's2_n')

%%
% Representacion salida correladores para s1 + ruido en función de t.
[r1n, r2n]= correlatorType(T,Ts,s1_n);
figure
plot(t,r1n)
hold on
plot(t,r2n)
xlabel('tiempo(s)')
ylabel('amplitud')
title('señal recibida + ruido')
legend('r1n', 'r2n')
%%
% Como se puede observar, la presencia de AWGN afecta a la correlación con ambas bases.
% Sin embargo, la SNR es suficientemente alta para que el maximo de
% correlación se siga dando entre s1 y la base1 en torno al final del periodo, que es el valor optimo teorico.

%%
% Representacion salida correladores para s2 + ruido en función de t.
[r1n,r2n] = correlatorType(T,Ts,s2_n);
figure
plot(t,r1n)
hold on
plot(t,r2n)
xlabel('tiempo(s)')
ylabel('amplitud')
title('señal recibida + ruido')
legend('r1n', 'r2n')
%%
% De nuevo, pese a la presencia de AWGN, ocurre el caso contrario al
% anterior, dandose el maximo de correlacion entre s2 y la base2 en torno
% al final del periodo.
%%

%% 4. Salida del demodulador
%
%%
% Se crean 2 matrices de Nsymb repeticiones de los símbolos de s1 y s2 respectivamente.
Nsymb=1000;

S1=zeros(Nsymb, length(s1));
S2=zeros(Nsymb, length(s2));

S1 = repmat(s1,Nsymb,1);
S2= repmat(s2, Nsymb,1);
%%
% A continuación, se genera un AWGN con la media y desviación
% típica anterior. 
Noise=sigma*randn(Nsymb,length(s1))+mu;
figure
histogram(Noise)
xlabel('valor')
ylabel('frecuencia absoluta')
title('histograma ruido blanco gaussiano')
%%
% Se suman las matrices con el ruido para generar las señales recibidas por
% el demodulador, simulando así un canal no ideal.
S1= S1+ Noise;
S2= S2 + Noise;

%%
% Vectores de salida del demodulador de tamaño Nsymb. 
% out1=zeros(Nsymb, 1);
% out2=zeros(Nsymb, 1);
% 
% %%
% %iteramos el correlador por filas
% for i=1:Nsymb
%     [r1_S1, r2_S1]= correlatorType(T, Ts, S1(i,:));
%     [r1_S2, r2_S2]= correlatorType(T, Ts, S2(i,:));
%     %cogemos la resta de los 2 valores al final del periodo, porque sabemos que es
%     %donde ocurre la maxima diferencia, pero no tendria por que. habria que
%     %calcular el max dentro de todo el periodo
%     out1(i)=abs(r1_S1(end)- r2_S1(end))/T;
%     out2(i)=abs(r1_S2(end)- r2_S2(end))/T;
% end

% figure
% histogram(
% %histogram(out1)
% figure
% %histogram(out2)
% xlabel('valor')
% ylabel('frecuencia absoluta')
% title('histograma ruido blanco gaussiano')

out1=zeros(Nsymb, 2);
out2=zeros(Nsymb, 2);

%%
%Iteramos el correlador por filas y noss quedamos con el ultimo valor para
%las señales de salida
for i=1:Nsymb
    [r1_S1, r2_S1]= correlatorType(T, Ts, S1(i,:));
    [r1_S2, r2_S2]= correlatorType(T, Ts, S2(i,:));
  
    out1(i, 1) = r1_S1(end);
    out1(i, 2) = r2_S1(end);
    out2(i, 1) = r1_S2(end);
    out2(i, 2) = r2_S2(end);
end


figure
subplot(2, 1, 1)
histogram(out1(:,1))
xlabel('valor')
ylabel('frecuencia absoluta')
title('histograma ruido blanco gaussiano r1')
subplot(2, 1, 2)
histogram(out1(:,2))
xlabel('valor')
ylabel('frecuencia absoluta')
title('histograma ruido blanco gaussiano r2')

figure
subplot(2, 1, 1)
histogram(out2(:,1))
xlabel('valor')
ylabel('frecuencia absoluta')
title('histograma ruido blanco gaussiano r1')
subplot(2, 1, 2)
histogram(out2(:,2))
xlabel('valor')
ylabel('frecuencia absoluta')
title('histograma ruido blanco gaussiano r2')

%%
% Como se puede observar, cuando la señal coincide con la base, la
% media/moda de correlacion está en torno a 0.1, en presencia de ruido, coincidiendo con el valor obtenido sin ruido.
% Si por el contrario la señal no coincide con la base, la media/moda de correlacion esta en torno a
% 0, coincidiendo con el valor obtenido sin ruido.
% Todos estos valores estan normalizados. 


