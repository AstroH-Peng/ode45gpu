function Xdot = HaloOde(f,X,mu,e)
%Xdot = HaloOde(f,X,mu,e)
%   ERTBP ����ѧ����
%   Xdot = HaloOde(f,X,mu)
%   Halo ��� ODE ��Ĭ��e=0
%
%   ע�⣺�������޸ģ�С�ĸĶ��ᵼ��С����ֵ����ǰ����� ME-Halo �����ľ��Ⱦͻ��ܵ�Ӱ��
%
%   ������ 2014-08-12:1246 ��� RTBPOde.m �����޸�
%
% last modified by PH at 2013-10-12:1046
% last modified by PH at 2013-11-18:���������ļ��㣬�������м����r1,r2,kappa
% last modified by PH at 2013-12-06:�޸���ע��
% last modified by PH at 2014-03-05 �ٴμ�����ģ�͡�

%% ������
if nargin < 4
    error('Not enougth input! Provide input as (f,X,mu,e).');
end

%% ��symbolic.m�Ƶ�����ODE
x = X(1);
y = X(2);
z = X(3);
dx = X(4);
dy = X(5);
dz = X(6);

r2cubic = ((mu + x - 1)^2 + y^2 + z^2)^(3/2);
r1cubic = ((mu + x)^2 + y^2 + z^2)^(3/2);
kappa = (e*cos(f) + 1);

Xdot = [dx;
    dy;
    dz;
     2*dy + (x + ((2*mu + 2*x)*(mu - 1))/(2*r1cubic) - (mu*(2*mu + 2*x - 2))/(2*r2cubic))/kappa;
    -2*dx + (y - (mu*y)/r2cubic + (y*(mu - 1))/r1cubic)/kappa;
    -z + (z - (mu*z)/r2cubic + (z*(mu - 1))/r1cubic)/kappa];

end