%
function [h lat long] = r_antena_geod(r_km)
%
% Cálculo de las coordenadas geodésicas de un punto (altura, latitud, longitud), altura en km, 
% latitud y longitud en radianes, en función de sus coordenadas cartesianas (x, y, z) en km
%
% r_km   coordenadas (x, y, z) del punto en km
%
%
  a  = 6378;        % Semiradio mayor del geoide terrestre (km)
  b  = 6356;        % Semiradio menor del geoide terrestre (km)
  e2 = 1 - (b/a)^2; % Excentricidad del geoide
%
% Valores iniciales para el cálculo iterativo de la solución
%
  h    = norm(r_km) - sqrt(a*b);    % Altura inicial sobre el nivel del mar 
  lat  = asin(r_km(3)/sqrt(a*b));   % Latitud del punto suponiendo Tierra esférica
  long = atan2(r_km(2), r_km(1));   % Longitud del punto suponiendo Tierra esférica
  if (long<0) 
      long = long + 2*pi;
  end
%
% Iteraciones para la solución, a partir de los valores iniciales. Se quiere resolver el sistema de
% ecuaciones no lineal
%
%    c.cart = función(c.esf)
%
% Se aproxima
%
%    c.cart = función(c.esf inicial) + grad(función en c.esf inicial)·(Incremento c.esf)
%
% A continuación se calcula el incremento
%
%    Incremento c.esf = inv[grad(función en c.esf inicial)]·[c.cart - función(c.esf inicial)]
% 
% Y se calcula el valor de c. esf
%
%    c. esf = c. esf incial + Incremento c. esf
%
% Para la siguiente iteración c.esf pasa a c.esf inicial
%
  for i=1:3
%
%     Radio de curvatura en la vertical principal
      N  = a/sqrt(1 - e2 * (sin(lat) ^ 2)); 
%
%     Gradiente de la función que calcula las coordenadas cartesianas en función de las geodésicas
      grad = zeros(3,3);
      grad(1,1) =        cos(lat)*cos(long);
      grad(1,2) = -(N+h)*sin(lat)*cos(long);
      grad(1,3) = -(N+h)*cos(lat)*sin(long);
      grad(2,1) =        cos(lat)*sin(long);
      grad(2,2) = -(N+h)*sin(lat)*sin(long);
      grad(2,3) =  (N+h)*cos(lat)*cos(long);
      grad(3,1) =        sin(lat);
      grad(3,2) =  ((1-e2)*N + h)*cos(lat);
%
%     Incremento de valores
      D_geod = grad\(r_km - r_antena_km(h, lat, long))';
    %
    % Solución en la iteración como suma del valor al comienzo de la iteración más el incremento
    % calculado
      v = [h lat long] + D_geod';
    %
    % Los nuevos valores se convierten en valores iniciales para la siguiente iteración
      h    = v(1);
      lat  = v(2);
      long = v(3);
      if long<0 
          long = long + 2*pi;
      end  
      long = mod(long,2*pi);
  end
% 
end

