function data = dotset(av_cross_image)

%  Thare are 7 columns in data variable.
%  1'st is a column of dot cell.
%  2'nd is a row of dot cell.
%  3'rd is a prediction errors (d).
%  4'th is a local varience .
%  5'th is a prediction values.
%  6'th is original values.
%  7'th is wating for putting embeded values.

[N,M] = size(av_cross_image);
A1=av_cross_image(1:2:N-3,3:2:M-1);
A2=av_cross_image(2:2:N-2,2:2:M-2);
B1=av_cross_image(3:2:N-1,3:2:M-1);
B2=av_cross_image(4:2:N,2:2:M-2);
C1=av_cross_image(2:2:N-2,2:2:M-2);
C2=av_cross_image(3:2:N-1,1:2:M-3);
D1=av_cross_image(2:2:N-2,4:2:M);
D2=av_cross_image(3:2:N-1,3:2:M-1);

A=[A1(:);A2(:)];
B=[B1(:);B2(:)];
C=[C1(:);C2(:)];
D=[D1(:);D2(:)];
uh=round((A+B+C+D)/4);
mu=var([abs(A-C) abs(A-D) abs(B-D) abs(B-C)], 0, 2);

u1=av_cross_image(2:2:N-2,3:2:M-1);
u2=av_cross_image(3:2:N-1,2:2:M-2);
u=[u1(:);u2(:)];
d=u-uh;

[c1,r1]=meshgrid(3:2:M-1,2:2:N-2);
[c2,r2]=meshgrid(2:2:M-2,3:2:N-1);
c=[c1(:);c2(:)];
r=[r1(:);r2(:)];

data=[c r d mu uh u u];

% figure(5)
% plot(data(:,3)),axis([0 length(data(:,3)) -100 100]) 
% xlabel('Sequence of pixels')
% ylabel('Prediction error (d)')
% title('Dot data of Couple')    

% x=-250:1:250;
% figure(38)
% hist(data(:,3),x) 
        
[nn,IX]=sort(data(:,5));
data=data(IX,:);
end
