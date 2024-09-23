function data = crossset(originalImage)

%  Thare are 7 columns in data variable.
%  1'st is a column of cross cell.
%  2'nd is a row of cross cell.
%  3'rd is a prediction errors (d).
%  4'th is a local varience .
%  5'th is a prediction values.
%  6'th is an original values.
%  7'th is waiting for putting embeded values.

[N,M] = size(originalImage);
A1=originalImage(1:2:N-3,2:2:M-2);
A2=originalImage(2:2:N-2,3:2:M-1);
B1=originalImage(3:2:N-1,2:2:M-2);
B2=originalImage(4:2:N,3:2:M-1);
C1=originalImage(2:2:N-2,1:2:M-3);
C2=originalImage(3:2:N-1,2:2:M-2);
D1=originalImage(2:2:N-2,3:2:M-1);
D2=originalImage(3:2:N-1,4:2:M);

A=[A1(:);A2(:)];
B=[B1(:);B2(:)];
C=[C1(:);C2(:)];
D=[D1(:);D2(:)];
uh=round((A+B+C+D)/4);
mu=var([abs(A-C) abs(A-D) abs(B-D) abs(B-C)], 0, 2);

u1=originalImage(2:2:N-2,2:2:M-2);
u2=originalImage(3:2:N-1,3:2:M-1);
u=[u1(:);u2(:)];
d=u-uh;

[c1,r1]=meshgrid(2:2:N-2,2:2:M-2);
[c2,r2]=meshgrid(3:2:N-1,3:2:M-1);
c=[c1(:);c2(:)];
r=[r1(:);r2(:)];

data=[c r d mu uh u u];

% figure(4)
% plot(data(:,3)),axis([0 length(data(:,3)) -100 100]) 
% xlabel('Sequence of pixels')
% ylabel('Prediction error (d)')
% title('Cross data of Couple') 

% x=-250:1:250;
% figure(28)
% hist(data(:,3),x) 
% 
% x=0:4:9000;
% figure(22)
% hist(data(:,4),x) 

[~,IX]=sort(data(:,4));
data=data(IX,:);
end
