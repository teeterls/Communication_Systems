function xMod = moduladorDQPSK(txBits)
%%
%  Esta función genera una señal modulada en DQPSK en función de un vector de parejas de bits
%
% txBits    vector fila de bits de entrada. Su longitud debe ser par
% xMod      vector fila de símbolos modulados en DQPSK en banda base. 
%           Sus elementos son números complejos y su longitud la mitad de la de txbits
%
% Cálculo de la señal modulada en QPSK, no diferencial
  xMod = moduladorQPSK(txBits);
%
% Conversión a modulación diferencial. Para el primer símbolo se supone que la fase del símbolo 
% anterior es cero
  n = length(xMod);
  for i=2:n;
        xMod(i) = xMod(i)*exp(j*angle(xMod(i-1)));
  end
%
  end