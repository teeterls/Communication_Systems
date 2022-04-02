function [s_hat] = Detector(r1,r2, c, N)
% c son los coeficientes de cada simbolo con cada base 1 y 2.
% comparamos minima distancia nube de puntos. los r de cada base con los c
% se calcula la minima distancia euclidea
dif=zeros(1, length(c(:,1)));
% alocamos memoria
s_hat=zeros(1, length(r1));
for i=1:length(r1) 
    %iteramos por filas
    for j=1:length(c(:,1))
        %distancia euclidea entre cada coeficiente de los simbolos
        % y las salidas del correlador para cada base. 
    dif(j)=norm([r1(i),r2(i)] - c(j,:));
    end
    % el indice de la minima diferencia corresponde al codigo del simbolo
    % transmitido
    [~, s_hat(i)]=min(dif);
end
end

