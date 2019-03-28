%% �������дode45�Ĳ��ԣ���RTBP����Ϊ��
% RTBP�μ���
%   https://www.researchgate.net/profile/Hao_Peng9
%   https://www.researchgate.net/project/Orbit-Trajectory-Research-in-Elliptic-Restricted-Three-Body-Problem-Model
%   ����ӭ���ã�
%
%   created by PH
%   updated by PH at 2019/03/27 22:39:00

%%
clear all;
close all;

% mu = 0.1;
% e = 0.1;

%% �����ʼ�� Halo ���
load('HaloElliptic_EarthMoon_L1_N2M5_F0_E0.20022_2.mat','mu','e','tempHalo')

y0 = tempHalo(1:6);

AbsTol = 1e-6;
RelTol = 1e-6;
odeOptions = odeset('AbsTol',AbsTol,'RelTol',RelTol,'MaxStep',0.001);

%% %% �ԱȻ���ĩ״̬���

% �ڳ�ʼ Halo ����������� x0 ������Ŷ�
mm = 10;
y0matrix = repmat(y0, mm+1, 1) + [1e-2*(-mm/2:1:mm/2).'/mm, zeros(mm+1,5)];

%%% GPU ����������״̬
tspan = [0,pi*4];
tic;
y0GPU = gpuArray(y0matrix);
[TGPU,YGPU1,YGPU2,YGPU3,YGPU4,YGPU5,YGPU6,FLAG] = arrayfun(@ode45GPU_simple,tspan(1),tspan(end),y0GPU(:,1),y0GPU(:,2),y0GPU(:,3),y0GPU(:,4),y0GPU(:,5),y0GPU(:,6),AbsTol,RelTol,0.001,mu,e);
tGPU = toc; % ���������ֻ��ĩ״̬����һά���൱����GPU�������˼���

%%% ode45 �Աȼ���
tic;
for ii = 1:mm+1
    [T,Y] = ode45(@(t,X)HaloOde(t,X,mu,e),tspan,y0matrix(ii,:),odeOptions);
    YCUP(ii,:) = Y(end,:);
%     disp(ii);
end
tCPU = toc;

% %% ��ͼ 
linewidth = 2;
Markersize = 10;
figure(333); clf;
subplot(1,2,1)
title('�����ĩ״̬')
hold on;
plot(y0matrix(:,1)-tempHalo(1), YCUP(:,1),'xr','Markersize',Markersize,'linewidth',linewidth)
plot(y0matrix(:,1)-tempHalo(1), YCUP(:,2),'xg','Markersize',Markersize,'linewidth',linewidth)
plot(y0matrix(:,1)-tempHalo(1), YCUP(:,3),'xb','Markersize',Markersize,'linewidth',linewidth)
% plot(y0matrix(:,1)-tempHalo(1), YCUP(:,4),'x','Markersize',Markersize,'linewidth',linewidth*0.8)
% plot(y0matrix(:,1)-tempHalo(1), YCUP(:,5),'x','Markersize',Markersize,'linewidth',linewidth*0.8)
% plot(y0matrix(:,1)-tempHalo(1), YCUP(:,6),'x','Markersize',Markersize,'linewidth',linewidth*0.8)
plot(y0matrix(:,1)-tempHalo(1), YGPU1,'ro','Markersize',Markersize,'linewidth',linewidth)
plot(y0matrix(:,1)-tempHalo(1), YGPU2,'go','Markersize',Markersize,'linewidth',linewidth)
plot(y0matrix(:,1)-tempHalo(1), YGPU3,'bo','Markersize',Markersize,'linewidth',linewidth)
% plot(y0matrix(:,1)-tempHalo(1), YGPU4,'ro','Markersize',Markersize,'linewidth',linewidth)
% plot(y0matrix(:,1)-tempHalo(1), YGPU5,'ro','Markersize',Markersize,'linewidth',linewidth)
% plot(y0matrix(:,1)-tempHalo(1), YGPU6,'ro','Markersize',Markersize,'linewidth',linewidth)
hold off;
axis auto;
axis tight;
grid on;
l1 = legend('CPU: x','CPU: y','CPU: z','GPU: x','GPU: y','GPU: z');
l1.FontSize = 14;
set(gca,'fontsize',12,'XTick',-5e-3:1e-3:5e-3)
xlabel('����� x0 ����� [LU]')
ylabel('ĩ״ֵ̬ [LU]')

subplot(1,2,2)
title('ĩ״̬���')
hold on;
plot(y0matrix(:,1)-tempHalo(1), YCUP(:,1)-YGPU1,'r.-','Markersize',Markersize*2,'linewidth',linewidth)
plot(y0matrix(:,1)-tempHalo(1), YCUP(:,2)-YGPU2,'g.-','Markersize',Markersize*2,'linewidth',linewidth)
plot(y0matrix(:,1)-tempHalo(1), YCUP(:,3)-YGPU3,'b.-','Markersize',Markersize*2,'linewidth',linewidth)
% plot(YCUP(:,4)-YGPU4,'x-','Markersize',Markersize,'linewidth',linewidth*0.8)
% plot(YCUP(:,5)-YGPU5,'x-','Markersize',Markersize,'linewidth',linewidth*0.8)
% plot(YCUP(:,6)-YGPU6,'x-','Markersize',Markersize,'linewidth',linewidth*0.8)
hold off;
axis tight;
grid on;
l2 = legend('x','y','z');
l2.FontSize = 14;
set(gca,'fontsize',12,'XTick',-5e-3:1e-3:5e-3)
xlabel('����� x0 ����� [LU]')
ylabel('ĩ״ֵ̬��� [LU]')

set(gcf,'PaperPositionMode','auto','Position',[200,100,1200,500])
print -dpng Test_02.png -r200

%% �Ա�������������
ii = 6;
y0GPU = gpuArray(y0matrix(ii,:));
tspanvector = linspace(tspan(1),tspan(end),300);
tspanGPU = gpuArray(tspanvector);
%%% GPU
tic;
[TGPU,YGPU1,YGPU2,YGPU3,YGPU4,YGPU5,YGPU6,FLAG] = arrayfun(@ode45GPU_simple,tspan(1),tspanGPU,y0GPU(1),y0GPU(2),y0GPU(3),y0GPU(4),y0GPU(5),y0GPU(6),AbsTol,RelTol,0.001,mu,e);
toc; % �൱��ÿ��GPU�˻��ֵ���ͬt_end
%%% CPU
[~,YY] = ode45(@(t,X)HaloOde(t,X,mu,e),tspan,y0matrix(ii,:),odeOptions);

% %%
figure(3); clf
set(gcf, 'Position', [50,50,600,460]);
plot3(YY(:,1),YY(:,2),YY(:,3));
axis equal;
hold on;
grid on;
plot3(YGPU1,YGPU2,YGPU3,'r.');
legend('ode45������','gpu������','location','northeast')

axes('Position',[0.16,0.34,0.3,0.55]);
plot3(YY(:,1),YY(:,2),YY(:,3));
axis equal;
hold on;
box on;
grid on;
tempID = 1:85;
plot3(YGPU1(tempID),YGPU2(tempID),YGPU3(tempID),'r.');
axis(gather([min(YGPU1(tempID)),max(YGPU1(tempID))+0.02,min(YGPU2(tempID))-0.01,max(YGPU2(tempID)),min(YGPU3(tempID))-0.04,max(YGPU3(tempID))]));
a = gca;
a.XTickLabel = []; a.YTickLabel = []; a.ZTickLabel = [];

set(gcf,'PaperPositionMode','auto')
print -dpng Test_02_2.png -r300

% %% difference
figure(4); clf
set(gcf, 'Position', [660,100,600,300]);
tic;
[T,Y] = ode45(@(t,X)HaloOde(t,X,mu,e),tspanvector,y0matrix(ii,:),odeOptions);
toc;
plot(T, Y(:,1) - YGPU1.', 'r.-');
hold on;
plot(T, Y(:,2) - YGPU2.', 'g.-');
plot(T, Y(:,3) - YGPU3.', 'b.-');
grid on;
% axis tight;
legend('\deltax','\deltay','\deltaz','location','southwest')
title('differences')
set(gcf,'PaperPositionMode','auto')
print -dpng Test_02_3.png -r300