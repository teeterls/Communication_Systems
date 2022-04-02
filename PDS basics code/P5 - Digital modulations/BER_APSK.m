function [ BER ] = BER_APSK( M, R, Eb_N0_dB )
%
%  Esta funci�n entrega los vectores BER de una modulación m_ary_APSK
%  
%  BER      BER resultante de una simulaci�n de transmisión. Es un vector cuya longitud es la misma
%           que la del vector de entrada Eb_N0_dB
%
%  M        vector cuya longitud es el número de círculos de la modulación, y el valor de
%           cada elemento el número de puntos de la constelación en cada círculo
%  R        vector cuya longitud es el número de círculos de la modulación, y el valor de
%           cada elemento la longitud del radio de cada córculo
%  EbNo_dB  vector de entrada que contiene los valores de relación EbNo, en dB, para los que se
%           mide BER
%
%  Número de bits de la simulación

   m_ary = sum(M);
   Nbits = 10000*log2(m_ary);
% 
   SNR_dB  = zeros(1, length(Eb_N0_dB));
   BER     = zeros(1, length(Eb_N0_dB));
   SNR_dB  = Eb_N0_dB + 10*log10(log2(m_ary));
%   
   for i = 1:length(SNR_dB)
        iBit   = round(rand(Nbits,1));                      % Genero el vector de bits a transmitir
        xmod   = apskmod(iBit, M, R,'InputType','bit');     % Señal modulada
        ymod   = awgn(xmod, SNR_dB(i), 'measured');         % Añado ruido
        ydemod = apskdemod(ymod, M, R, 'OutputType' , 'bit');   % Señal demodulada
        BER(i) = sum(abs(ydemod-iBit))/length(iBit);        % Calculo el BER
   end
%    figure
%    scatterplot(ymod)
%    title(['Constelación APSK - ' num2str(uint64(m_ary))])
% 
end

