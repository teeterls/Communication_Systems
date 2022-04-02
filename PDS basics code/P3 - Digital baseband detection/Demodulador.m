function [out1,out2] = Demodulador(T,Ts,N,phi1,phi2, s_t)


for i=1:N
    [r1, r2]= correlatorType(T, Ts, s_t(i,:), phi1, phi2);
    %[r1_S2, r2_S2]= correlatorType(T, Ts, S2(i,:));
    %sacamos los valores end como salida, una vez entra la señal entera es el
    %punto optimo de forma teorica.
    out1(i) = r1(end);
    out2(i) = r2(end);
%     out2(i, 1) = r1_S2(end);
%     out2(i, 2) = r2_S2(end);
end
end


