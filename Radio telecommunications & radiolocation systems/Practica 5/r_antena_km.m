function [r] = r_antena_km(altura, latitud, longitud)
%
% Cálculo de las coordenadas (x,y,z) de un punto sobre el geoide terrestre en función de la latitud,
% longitud y altura sobre el nivel del mar del punto. 
% en función de los vectores de posición de la antena terrestre y el satélite
%
%  r          vector de coordenadas (x,y,z) del punto, en km
%  altura     altura del punto sobre el nivel del mar, en km
%  latitud    latitud geodésica del punto, en radianes
%  longitud   longitud geodésica del punto, en radianes
%
   a  = 6378;        % Semiradio mayor del geoide terrestre (km)
   b  = 6356;        % Semiradio mayor del geoide terrestre (km)
   e2 = 1 - (b/a)^2; % Excentricidad del geoide
%
%  Radio de curvatura en la vertical principal
   N = a/sqrt(1 - e2 * (sin(latitud) ^ 2)); 
%
%  Coordenadas cartesianas
   r(1) = (N + altura) * cos(latitud) * cos(longitud);
   r(2) = (N + altura) * cos(latitud) * sin(longitud);
   r(3) = ((1 - e2) * N + altura) * sin(latitud);
%  
end

