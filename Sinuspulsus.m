function  [t,s,ft,fs,f_achse,Bandbreite,f,N,L_puls,Kohaerenzlaenge] = Sinuspulsus(typP,kvar)
%U Summary of this function goes here
%   L...    Länge des Vektors in Periodenlängen
%   N...    Anzahl der Einzelpulse
%   L_puls...Länge des Einzelpulses (in Periodenlängen)
%   f...    Ur-Frequenz
%   df...   Bandbreite Frequenz (evtl. Quadratische Verteilung zur besseren
%           Verteilung
%   fs...   Abtastfrequenz

% Einstellungen der Signaleigenschaften
c = 299792458;      % Lichtgeschwindigkeit
lambda = 666E-9;    % Wellenlänge
f = c/lambda;       % Frequenz

L = 10000;      %10000
N = 10000;     %100000
L_puls = kvar;  %1000
df = 0;         %0
fs = 10*f;      %10*f
[t,s]=Sinuspuls(L,N,L_puls,f,df,fs,typP);
%s = s./sum(s.^2); %Leistung (gemittelt);
%% Mittenfrequenz und Bandbreite
% Kompletter Plot
    f_achse = 0:fs/length(s):fs-fs/length(s);   % Frequenzachse
    ft = fft(s);                                % Fouriertransformierte (FT)
    plot(f_achse,abs(ft));                  % FT Plotten

% Frequenzbereich auswählen
index = find(and(f_achse > 3E14, f_achse < 6E14));
f_achse_klein = f_achse(index);
ft_klein = abs(ft(index));
%ft_klein = ft_klein./max(ft_klein);

%% Gausssche Fitfunktion bzw. quadratische Fitfunktion
expo = @(A,X) A(1)*exp(A(2)*X); % Exponentialfunktion
g = @(A,X) A(1)*exp(-(X-A(2)).^2/(2*A(3)^2)); % Gauss
h = @(A,X) A(1)*(X-A(2)).^2+A(3); % Parabel

% Startparameter Amplitude, Verschiebung, Breite
A0 = [max(ft_klein),f,6E12];

% Set Options
options = optimoptions(@fmincon,'Algorithm','interior-point','FunctionTolerance',1E-20,'MaxFunctionEvaluations', 900000);
[A1,resnorm,residual,exitflag,output] = lsqcurvefit(g,A0,f_achse_klein,ft_klein,[1E3,4.4E14,1E11],[1E7,4.6E14,1E14],options);
% Fit using Matlab's Least Squares function
A1;
figure(3); clf;
plot(f_achse_klein,ft_klein); hold on; % FT Plotten
plot(f_achse_klein,g(A1,f_achse_klein),'r-');

% figure(4); clf;
% subplot(2,1,1);
% plot(t,s./max(s));
% hold on;
% plot(t,0.07*sin(2*pi*f.*t),'r-');
% axis([0,2.22E-11,-1,1]);
% subplot(2,1,2);
% plot(f_achse_klein,ft_klein); hold on; % FT Plotten
% plot(f_achse_klein,g(A1,f_achse_klein),'r-');
% axis([4.4E14,4.6E14,0,13E5]);
Bandbreite = A1(3);
if typP == "h"
    Kohaerenzlaenge = "unendlich"
else
    Kohaerenzlaenge = c/Bandbreite
end
end
