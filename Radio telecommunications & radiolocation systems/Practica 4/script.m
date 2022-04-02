%% PRACTICA 4 - PROYECCIÓN ÓRBITA DE UN SATÉLITE DE COMUNICACIONES
% Maria José Medina y Teresa González

i=8; 
g=6.674e-11;
m= 5.97e24;
T= 10+i/2; 
%en radianes
fase_in=deg2rad(i*10);
roty=deg2rad(49 + i);
rotz=deg2rad(i*10);

%radio orbita km
%R=(T^2*(g*m)/(2pi)^2)^1/3; 
R=((T*3600)^2*(g*m)/(2*pi)^2)^(1/3); %formula del radio en unidades del SI

%posicion satelite periodo 24h

%vector horas
t=0:23;

%fase_t
fase_t=fase_in + (2*pi/T)*t; %vector

%coord ecuador matriz 3*24
coord_ec(1,:)=R*cos(fase_t); %x0
coord_ec(2,:)=R*sin(fase_t); %y0
coord_ec(3,:)=0; %z0

%matrices rotacion
Ry = [ cos(roty) 0 -sin(roty) ; ... 
       0 1 0 ; ...
       sin(roty) 0 cos(roty) ];
   
Rz = [ cos(rotz) sin(rotz) 0 ; ...
       -sin(rotz) cos(rotz) 0; ...
       0 0 1 ];
 
   coord_proyec=zeros(3,24);
   coord_esf=zeros(3,24);
   
for t_iter=t+1
  coord_proyec(:,t_iter)=Rz*Ry*coord_ec(:,t_iter);  
  coord_esf(1,t_iter)= sqrt(coord_proyec(1,t_iter)^2 + coord_proyec(2,t_iter)^2 + coord_proyec(3,t_iter)^2); %ρ = (x^2 + y^2 + z^2)^1/2. radio
  coord_esf(2,t_iter) = rad2deg(asin(coord_proyec(3,t_iter)/coord_esf(1,t_iter))); %Ψ =arcsen(z/ρ) en grados
  coord_esf(3,t_iter)= atand(coord_proyec(2,t_iter),coord_proyec(1,t_iter)); %θ = arctan(y,x) en grados (4 cuadrantes)
 
   %correccion si es negativo, para pasar de -180, +180 a 0 360.
%    if coord_esf(3,t_iter) <0 
%        coord_esf(3,t_iter) = 360 + coord_esf(3,t_iter);
%    end
   coord_esf(3,t_iter) = wrapTo360(coord_esf(3,t_iter));
end

%ajustar longitud teniendo en cuenta que la tierra gira, y se resta lo que
%se ha movido la tierra en ese periodo de tiempo.
%el satelite gira mas rapido que la tierra, porque el periodo es menor
%T=18h. Entonces la tierra siempre va a ver que el satélite va adelantado.

%Esta formula funciona ya que el periodo del satélite es menor que el de la
%tierra, si no habría que tener en cuenta el límite de 360º.
coord_esf(3,:) = coord_esf(3,:) - (360/24*t);

figure
plot(t, [coord_esf(2, :);coord_esf(3, :)]);
legend("Ψ=latitud","θ=longitud");

%Representacion geoplot
figure
geoplot(coord_esf(2, :),coord_esf(3, :));

latitud=coord_esf(2, :)';
longitud=coord_esf(3, :)';
hora=t';

%Tabla
tabla = table(hora,longitud,latitud)
