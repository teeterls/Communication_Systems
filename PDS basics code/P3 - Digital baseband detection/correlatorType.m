
% Funcion que obtiene las salidas de los correladores 
function [r1,r2] = correlatorType(T,Ts, s, phi1, phi2)

% Señales base ortogonales y ortonormales (módulo 1)
% Coeficientes 1/sqrt(T) = 10.
%phi1= 1/sqrt(T)*ones(1, T/Ts);
%phi2= 1/sqrt(T)*[ones(1,T/(2*Ts)), - 1*ones(1,T/(2*Ts))];
% Vectores salida inicialmente a 0.
r1= zeros(1,length(s));
r2=zeros(1,length(s));

%Primer elemento de r
r1(1)=(s(1)*phi1(1))*Ts;
r2(1)=s(1)*phi2(1)*Ts;

%Bucle con resto elementos de r. 
for i=2:length(s)
%multiplica y acumula el valor obtenido con el anterior (integral)
r1(i)=s(i)*phi1(i)*Ts + r1(i-1);
r2(i)=s(i)*phi2(i)*Ts + r2(i-1);   

end
end
