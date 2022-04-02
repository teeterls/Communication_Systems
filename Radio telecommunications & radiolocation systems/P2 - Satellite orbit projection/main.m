%% PRACTICA 4 - PROYECCIÓN ÓRBITA DE UN SATÉLITE DE COMUNICACIONES
% Maria José Medina y Teresa González
close all; 
clear all; 

%% Parámetros a utilizar
% N grupo
i = 8; 

% Cte gravitación universal
G = 6.674e-11; 
% Masa de la Tierra (kg)
M = 5.97e24; % masa de la Tierra (kg)
% T órbita (en horas)
T = 10 + i/2;

% Fase inicial en el ecuador (en radianes)
fase_in = (i*10)*pi/180;
% Grados de inclinación de la órbita (en radianes)
roty = (49 + i)*pi/180;  
rotz = (i*10)*pi/180;

% Formula del radio en unidades del SI
R=((T*3600)^2*(G*M)/(2*pi)^2)^(1/3); 
    

% Matrices de rotación
Ry = [ cos(roty) 0 -sin(roty) ; ... 
       0 1 0 ; ...
       sin(roty) 0 cos(roty) ];
   
Rz = [ cos(rotz) sin(rotz) 0 ; ...
       -sin(rotz) cos(rotz) 0; ...
       0 0 1 ];
   
 %% Cálculo de la proyección
 
% Vector de tiempo 24 horas
  t = [0:23];
  
  % Vector fase en radianes en función de T y t
  fase_t = fase_in+(2*pi/T).*t; 
  
  % Coordenadas ecuador
  x0 = R*cos(fase_t); 
  y0 = R*sin(fase_t);
  % En el ecuador z es 0
  z0 = zeros(1,length(x0)); 

  coord_ec = [x0;y0;z0];
  
  % Coordenadas proyeccion x y z
 coord_proyec = Rz*Ry*coord_ec; 
  x = coord_proyec(1,:); 
  y = coord_proyec(2,:); 
  z = coord_proyec(3,:);
  
  % Cálculo coordenadas esféricas
  % ρ = ( x^2 + y^2 + z^2 )^1/2
  ro = ( x.^2 + y.^2 + z.^2 ).^(1/2); 
  
  % lat= arcsen(z/ρ) en grados	 
  lat = asin(z./ro).*(180/pi);

  % long = arctan(y,x) en grados (tangente 4 cuadrantes)
  % long = Meridiano de Greenwich
  % Este: + 
  % Oeste: - 
  long = (atan2(y,x)-(2*pi/(24)).*t).*(180/pi);
  % Se ajusta la longitud entre +-180º
  long = wrapTo180(long);
  
  %Tabla 
  hora=t';
  longitud=long';
  latitud=lat';
  tabla = table(hora,longitud, latitud)
  
 
  %% Representación geoplot 
  figure; 
  geoplot(lat,long,'-x')
  title("Proyección de la órbita del satélite con i="+i);