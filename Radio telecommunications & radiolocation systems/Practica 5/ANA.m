%% Práctica 5 - GNSS 
% José Antonio Font y Ana Urbistondo

%% 
% El objetivo de esta práctia es familiarizarse con los conceptos y
% procedimientos de GNSS. 
  format compact;  clear;  close all;
  
%% 
% Los datos iniciales con los que hemos trabajado en esta práctica son los
% siguientes: 
% ---------------------------------------------------------------------------------
% DATOS INICIALES
%
%  
%  t_relativo de llegada     coordenadas xyz del satélite
%        (ms)                            (km)
%  _____________________________________________________________
%     14.58352             -9390.782    -24847.799     1520.332
%     8.01768             -26214.216     -4291.244     1520.332
%     13.73741              3697.456    -14884.083    21741.762
%     4.52930             -11041.266    -10644.133    21741.762
%     5.57688             -14738.722      4239.950    21741.762
%     9.88064             -26214.216     -4291.244    -1520.332
%     15.57993             -3697.456     14884.083    21741.762


%% 
% Además, las alturas geodésicas utilizadas iniciales (r0_km) son las
% sigueintes:
lat = 40.3; 
long = -3.4; 
altura = 0.667; % km 

c = 3*10^8; 

%% PARTE 1: Coordenadas geodésicas -> Coordenadas cartesiana X, Y , X 
%% 
% En esta primera parte se calcula las coordenadas (x,y,z) del terminal.
% Para ello, se calcula tanto la matriz de gradientes sobre la posición
% inicial (r0_km) como la distancia entre los satélites y el terminal. 

%% 
% El procedimiento seguido para dicho cálculo es el siguiente: 

% sat = [t, x, y, z] 
sat = [4.42856,     -23459.789,         4017.922,       11782.610;
       7.06786,     -8250.272,          22325.734,      11782.610;
       14.01348,    -12805.515,        -14383.910,      18288.171;
       3.23879,     -18859.589,         3897.946,       18288.171;
       5.91472,     -6054.074,          18281.857,      18288.171]
k = size(sat,1); % número de satélites 
t_i_ms = sat(:,1); 
Rsat_km = sat(:, 2:end);
   
% Función r_antenna_km 

% k = 2,3. . . n�m. de sat�lites
%       dk es la distancia del sat�lite k al punto en el que se encuentra el terminal
%       d1 es la distancia del sat�lite 1 al punto en el que se encuentra el terminal
% dk - d1  % Particularizado en el punto r0

R = 6371; % km
R0 = R+ altura; 
% coordenadas
% r0 = deg2rad([lad, long]); % [N, O]
% xyz_r0 = R0*[sin(r0(1)), cos(r0(1))*cos(r0(2)), cos(r0(1)*sin(r0(2)))]
r0_km = r_antena_km(altura, lat, long); 

% dj = d(Rsat_km(:,1), r0_km)  % distancia entre teminarl y el satelite

% Calculamos el gradiente de posiciones ne función de lacoordenada inicial
% r0 

error = 1; 

% Cálculo diferencia de tiempos: 
t_sat = zeros(1,k-1);

for i=2:k
    % diferencia de tiempos son el satélite 1
    t_sat(i-1) = t_i_ms(i)-t_i_ms(1);
end

t_sat = t_sat*1e-3; % en segundos
%% 
while error > 10^-11
    % calculamos las distancias entre los satelites y el terminal:
    d_i_km = zeros(1,k);
    d_i_km(1) = norm(Rsat_km(1,:)-r0_km); % distancia entre satélite 1 y terminal

    mat_d = zeros(1,size(d_i_km,2)-1); 
    
    for i = 2:k
        % distancia entre satélites y terminal
        d_i_km(i) = norm(Rsat_km(i,:)-r0_km);

        % Vector diferencia de distancias con d1 
        mat_d(i-1) = d_i_km(i)-d_i_km(1);
    end
    
    Grad = zeros(k-1,3); % k-1 satélites, con
    d1 = d_i_km(1);

    for j=1:k-1
        dj = d_i_km(j); 

        for m = 1:size(Grad,2)
            Grad(j,m) = -((1/dj)*(Rsat_km(j+1,m)-r0_km(m)) - (1/d1)*(Rsat_km(1,m) - r0_km(m)));
        end
    end
   
    rh0 = (c*t_sat' - mat_d'*10^3)*1e-3; % en km
%% 
% Dado que no se obtiene una matriz cuadrada, se utiliza el métoddo de
% Moose-Penrose para obtener el incremento de r (variación de la posición)
% según la matriz gradiente y el valor de rh0 calculado: 

    % Incremento de distancia
    incr = ((Grad'*Grad)^-1)*Grad'*rh0; 
    
    % Posicion terminal 
    r0_km = r0_km + incr'; 
    error = abs(incr(1));
end

%% 
% Finalmente, la posición del terminal obtenida es la siguiente: 
r_km=r0_km;
disp(['Posición (km): ', num2str(r_km)]);
disp('');

%% PARTE 2: Calcular la posición del terminal en coordenadas geodésicas 
%% 
% En esta segunda parte se calcula las coordenadas geodésicas a partir de
% la posición del terminal obtenida en el apartado anterior, utilizando una
% de las funciones proporcionadas en esta práctica. 
T = 23.9344696 % en horas

[h, lat2, long2] = r_antena_geod(r_km)

%% 
% Además, en el enunciado de la práctica se indica que los resultados
% obtenidos del apartado anterior se corresponden al 3 día a las 10.00GMT
% desde la sincronización (teniendo en cuenta que ésta se realizó en día 1 a 
% las 00.00). Por lo tanto, el tiempo desde la sincronización es el
% siguiente: 
t=round(2*T+10)                              % Tiempo desde la sincronización, en horas

%% 
% Con este resultado se puede obtener el ángulo de rotación en radianes de
% la Tierra que afectará a la longitud calculada anteriormente: 
theta=2*pi*t/T;                     % Ángulo rotación en radianes
inc=theta-round(theta/(2*pi))*2*pi; % Incremento de la longitud

lon=long2-inc;

%% 
% En conclusión, las coordenadas geodésicas obtenidas son: 
coord=[lat2*180/pi lon*180/pi];
disp(['Altura: ', num2str(h), ' km']);
disp(['Latitud: ', num2str(coord(1)), ' º']);
disp(['Longitud: ', num2str(coord(2)), ' º']);
disp('');

%% 
% Si representamos dichas coordenadas en Google Maps, obtenemos que el
% terminal se encuentra en Moncloa-Aravaca, Madrid: 

geoplot([lat coord(1)],[long coord(2)],'g-*');

%%