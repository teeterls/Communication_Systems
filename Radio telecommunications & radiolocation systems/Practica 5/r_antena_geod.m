%
function [h lat long] = r_antena_geod(r_km)
%
% C�lculo de las coordenadas geod�sicas de un punto (altura, latitud, longitud), altura en km, 
% latitud y longitud en radianes, en funci�n de sus coordenadas cartesianas (x, y, z) en km
%
% r_km   coordenadas (x, y, z) del punto en km
%
%
  a  = 6378;        % Semiradio mayor del geoide terrestre (km)
  b  = 6356;        % Semiradio menor del geoide terrestre (km)
  e2 = 1 - (b/a)^2; % Excentricidad del geoide
%
% Valores iniciales para el c�lculo iterativo de la soluci�n
%
  h    = norm(r_km) - sqrt(a*b);    % Altura inicial sobre el nivel del mar 
  lat  = asin(r_km(3)/sqrt(a*b));   % Latitud del punto suponiendo Tierra esf�rica
  long = atan2(r_km(2), r_km(1));   % Longitud del punto suponiendo Tierra esf�rica
  if (long<0) 
      long = long + 2*pi;
  end
%
% Iteraciones para la soluci�n, a partir de los valores iniciales. Se quiere resolver el sistema de
% ecuaciones no lineal
%
%    c.cart = funci�n(c.esf)
%
% Se aproxima
%
%    c.cart = funci�n(c.esf inicial) + grad(funci�n en c.esf inicial)�(Incremento c.esf)
%
% A continuaci�n se calcula el incremento
%
%    Incremento c.esf = inv[grad(funci�n en c.esf inicial)]�[c.cart - funci�n(c.esf inicial)]
% 
% Y se calcula el valor de c. esf
%
%    c. esf = c. esf incial + Incremento c. esf
%
% Para la siguiente iteraci�n c.esf pasa a c.esf inicial
%
  for i=1:3
%
%     Radio de curvatura en la vertical principal
      N  = a/sqrt(1 - e2 * (sin(lat) ^ 2)); 
%
%     Gradiente de la funci�n que calcula las coordenadas cartesianas en funci�n de las geod�sicas
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
    % Soluci�n en la iteraci�n como suma del valor al comienzo de la iteraci�n m�s el incremento
    % calculado
      v = [h lat long] + D_geod';
    %
    % Los nuevos valores se convierten en valores iniciales para la siguiente iteraci�n
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

