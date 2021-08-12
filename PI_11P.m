clear all
close all
clc
tic
input_data

P1 = 15.7940; P2 = 2.7649; P3 = -5.6356; P4 = 15.5400; P5 = 0.8380; P6 = 6.4364;
P7 = -9.9631; P8 = 0.5618; P9 = 10.9590; P10 = 2.5785; P11 = 0.0395;

N = 20;
P = ones(N+1,1);
r = ones(N+1,1);
temp = ones(N+1,1);
Sr = ones(length(v),1);
error = ones(length(v),1);
GamR = ones(length(v), 1);
GamL = ones(length(v), 1);
y_PI = ones(length(v), 1);
figure(1)
plot(0:10:7720, v)
grid on

for i = 0: N
    r(i+1) = P11*i;
    P(i+1) = P9*exp(-P10*r(i+1));
end

SIG=0;
Sig = 0;
for t = 1: length(v)
    
    GamR(t) = Gamma([P1;P2;P3;P4;v(t)]);
    GamL(t) = Gamma([P5;P6;P7;P8;v(t)]);
    
    sig = 0;
    for i = 0: N
        if t == 1
            Sr(t) = GamR(t)+r(i+1);
            temp(i+1) = Sr(t);
        else
            Sr(t) = max((GamL(t)-r(i+1)), min(GamR(t)+r(i+1), temp(i+1)));
            temp(i+1) = Sr(t);
        end
        sig = sig + P(i+1) * Sr(t);
    end
    y_PI(t) = sig + 17.72;
    error(t) = abs(y(t)-y_PI(t));
    Sig = SIG+error(t);
    SIG = SIG+(error(t))^2;
    
end

RMS = sqrt(SIG)/(length(v));
MiAE = Sig/(length(v));
norm = norm(y - y_PI', 2);
figure(2)
plot(0:10:7720,y_PI, 'r', 0:10:7720,y, 'b', 0:10:7720,error, 'k');
grid on
legend('PI', 'Truth', 'Absolute Error')

    for t=1:length(v)-1
        figure(3)
        grid on
        line([v(t),v(t+1)],[y_PI(t),y_PI(t+1)])
        hold on
        plot(v, y , 'k')
    end
MaAE=max(error);
disp('|Mean of Absolute Error ||| Max of Absolute Error |||    RMS    |||    Norm   |')
disp(['|         ',num2str(MiAE),'        |||        ',num2str(MaAE) ,...
    '        |||  ',num2str(RMS), ' |||  ',num2str(norm),'  |'])
fprintf('\n')
toc