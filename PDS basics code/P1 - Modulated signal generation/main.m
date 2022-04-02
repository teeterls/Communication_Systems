[s1,s2] = vectores();
T=10;
Ts=T/20;
%numero bits
N=10;
M = 20;
x=round(rand(1,N))*2 -1;
m= zeros(N, M);
for i=1:N
  if x(i) == 1
%       for j=1:M
%       v(j)=s1(j)
%       end
        m(i, :) = s1
  else 
   
      m(i, :) = s2
  end
end
  % 200 posiciones 10*20
v= reshape(m',1,[])
t=0:Ts:200*Ts - Ts;
figure()
%stem(t,v)
plot(t,v)
xlabel("Tiempo (ms)")
ylabel("Señal")

