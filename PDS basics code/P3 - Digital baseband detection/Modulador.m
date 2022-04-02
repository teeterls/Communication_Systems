%vec
function [s_t] = Modulador(T,Ts,N,phi1,phi2, c, s)
M=T/Ts;
s_t=zeros(N,M);

for i=1:N
   s_t(i, :)= c(s(i),1)*phi1 + c(s(i), 2)*phi2;
%   if s(i) == 1
%         s_t(i, :) = c(s(i),1)*phi1 + c(s(i), 2)*phi2;
%   elseif s(i)==2
%       s_t(i,:) = c(s(i),1)*phi1 + c(s(i), 2)*phi2;
%   elseif s(i)==3
%       s_t(i,:) = c(s(i),1)*phi1 + c(s(i), 2)*phi2;
%   else
%         s_t(i,:) = c(s(i))*phi2;
%   end
end
end

