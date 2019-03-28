function [vx,vy,vz,dvx,dvy,dvz] = HaloOdeGPU(f,x,y,z,vx,vy,vz,mu,e)
%   ���� HaloOde.m �޸�ʹ������� GPU �ϻ���
%
%   created by PH at 2016-03-06:2047
%

%%
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


%% ��symbolic.m�Ƶ�����ODE

r2cubic = ((mu + x - 1)^2 + y^2 + z^2)^(3/2);
r1cubic = ((mu + x)^2 + y^2 + z^2)^(3/2);
kappa = (e*cos(f) + 1);

dvx =  2*vy + ( x + ((2*mu + 2*x)*(mu - 1))/(2*r1cubic) - (mu*(2*mu + 2*x - 2))/(2*r2cubic) ) / kappa;
dvy = -2*vx + ( y - (mu*y)/r2cubic + (y*(mu - 1))/r1cubic ) / kappa;
dvz = -   z + ( z - (mu*z)/r2cubic + (z*(mu - 1))/r1cubic ) / kappa;

end