clear all
% prompts for signal data
u_basic=input("Signal elements (row complex vector, each element last tb \
sec) = ?");
m_basic=length(u_basic);
fcode=input("Allow frequency coding (yes=1, no=0) = ?");
if fcode==1
f_basic=input("Frequency coding in units of 1/tb (row vector of same \
length) = ?");
end
F=input("Maximal Doppler shift for ambiguity plot [in units of 1/Mtb] \
(e.g., 1)= ?");
K=input("Number of Doppler grid points for calculation (e.g., 100) = ?");
df=F/K/m_basic;
T=input("Maximal Delay for ambiguity plot [in units of Mtb] (e.g., 1)= ?");
N=input("Number of delay grid points on each side (e.g. 100) = ?");
sr=input("Over sampling ratio (>=1) (e.g. 10)= ?");
r=ceil(sr*(N+1)/T/m_basic);
if r==1
dt=1;
m=m_basic;
uamp=abs(u_basic);
phas=uamp*0;
phas=angle(u_basic);
if fcode==1
phas=phas+2*pi*cumsum(f_basic);
end
uexp=exp(j*phas);
u=uamp.*uexp;
else
 % i.e., several samples within a bit
dt=1/r;
 % interval between samples
ud=diag(u_basic);
ao=ones(r,m_basic);
m=m_basic*r;
u_basic=reshape(ao*ud,1,m);
 % u_basic with each element repeated r times
uamp=abs(u_basic);
phas=angle(u_basic);
u=u_basic;
if fcode==1
ff=diag(f_basic);
phas=2*pi*dt*cumsum(reshape(ao*ff,1,m))+phas;
uexp=exp(j*phas);
u=uamp.*uexp;
end
end
t=[0:r*m_basic-1]/r;
tscale1=[0 0:r*m_basic-1 r*m_basic-1]/r;
dphas=[NaN diff(phas)]*r/2/pi;
% plot the signal parameters
figure(1), clf, hold off
subplot(3,1,1)
plot(tscale1,[0 abs(uamp) 0],"linewidth",1.5)
ylabel(" Amplitude ")
axis([-inf inf 0 1.2*max(abs(uamp))])
subplot(3,1,2)
plot(t, phas,"linewidth",1.5)
axis([-inf inf -inf inf])
ylabel(" Phase [rad] ")
subplot(3,1,3)
plot(t,dphas*ceil(max(t)),"linewidth",1.5)
axis([-inf inf -inf inf])
xlabel(" \itt / t_b ")
ylabel(" \itf * Mt_b ")
% calculate a delay vector with N+1 points that spans from zero delay to
%
 ceil(T*t(m))
% notice that the delay vector does not have to be equally spaced but must
%
% have all
% entries as integer multiples of dt
dtau=ceil(T*m)*dt/N;
tau=round([0:1:N]*dtau/dt)*dt;
% calculate K+1 equally spaced grid points of Doppler axis with df spacing
f=[0:1:K]*df;
% duplicate Doppler axis to show also negative Doppler’s (0 Doppler is
% calculated twice)
f=[-fliplr(f) f];


ut=ctranspose(u);
mat1=spdiags(ut,0,m+ceil(T*m),m);

% define a row vector with ceil(T*m)+m+ceil(T*m) places by padding u with zeros
% on both sides
u_padded=[zeros(1,ceil(T*m)),u,zeros(1,ceil(T*m))];
% define column indexing and row indexing vectors
cidx=[1:m+ceil(T*m)];
ridx=round(tau/dt);
% define indexing matrix with Nused+1 rows and m+ceil(T*m) columns
% where each element is the index of the correct place in the padded version
%
% of u
index = cidx(ones(N+1,1),:) + ridx(:,ones(1,m+ceil(T*m)));
% calculate matrix
mat2 = sparse(u_padded(index));
% calculate the ambiguity matrix for positive delays 
%
% where there are m columns and N+1 rows and each element gives an element
% of multiplication between u and a time shifted version of u*. each row gives
% a different time shift of u* and each column gives a different entry in u.
%
uu_pos=mat2*mat1;
clear mat2 mat1
% calculate exponent matrix for full calculation of ambiguity function.
%
% The exponent
% matrix is 2*(K+1) rows by m columns where each row represents a possible
%
% Doppler and
% each column stands for a different place in u.
e=exp(-j*2*pi*f*t);
% calculate ambiguity function for positive delays by calculating the integral
%
% for each
% possible delay and Doppler over all entries in u.
% a_pos has 2*(K+1) rows (Doppler) and N+1 columns (Delay)
a_pos=abs(e*uu_pos);
% normalize ambiguity function to have a maximal value of 1
a_pos=a_pos/max(max(a_pos));
% use the symmetry properties of the ambiguity function to transform the
%
% negative Doppler
% positive delay part to negative delay, positive Doppler
a=[flipud(conj(a_pos(1:K+1,:))) fliplr(a_pos(K+2:2*K+2,:))];
% define new delay and Doppler vectors
delay=[-fliplr(tau) tau];
freq=f(K+2:2*K+2)*ceil(max(t));
% excludes the zero Delay that was taken twice
delay=[delay(1:N) delay(N+2:2*N)];
a=a(:,[1:N,N+2:2*N]);
% plot the ambiguity function and autocorrelation cut
[amf amt]=size(a);
% create an all blue color map
cm=zeros(64,3);
cm(:,3)=ones(64,1);
figure(2), clf, hold off
mesh(delay, [0 freq], [zeros(1,amt);a])
hold on
surface(delay, [0 0], [zeros(1,amt);a(1,:)])
colormap(cm)
view(-40,50)
axis([-inf inf -inf inf 0 1])
xlabel("{\it\tau}/{\itt_b}","Fontsize",12);
ylabel("{\it\nu}*{\itMt_b}","Fontsize",12);
zlabel("|{\it\chi}({\it\tau},{\it\nu})|","Fontsize",12);
hold off
