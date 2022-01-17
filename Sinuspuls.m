function  [t,s] = Sinuspuls(L,N,L_puls,f,df,fs,typP)
%U Summary of this function goes here
%   L...    Länge des Vektors in Periodenlängen
%   N...    Anzahl der Einzelpulse in Periodenlängen
%   L_puls...Länge des Einzelpulses (in Periodenlängen)
%   f...    Ur-Frequenz
%   df...   Bandbreite Frequenz (evtl. Quadratische Verteilung zur besseren
%           Verteilung
%   fs...   Abtastfrequenz
if typP == "t"
    t_puls = 0:1/fs:L_puls/f-1/fs;                      %Zeitvektor für einzelnen Puls
    s = zeros(1,ceil(L*(fs/f)));
    for i=1:N
        L_min = 1;                                      %frühester Start
        L_max = floor((L-L_puls)*(fs/f));               %spätester Start
        L_start = round(L_min+rand()*(L_max-L_min));    %Start
        f_ran = f+df*2*rand()-df;
        add = sin(2*pi*f_ran*t_puls).*hann(length(t_puls)).';
        s(L_start:L_start+length(t_puls)-1) = s(L_start:L_start+length(t_puls)-1)+add;
    end
    %figure(1);
    t = 0:1/fs:(length(s)-1)/fs;
    %plot(t,s,'b');
    %figure(2); clf;
    f_achse = 0:fs/length(s):fs-fs/length(s);
    %plot(f_achse,abs(fft(s)));
    s = s./(N*L_puls/(100*100000));
elseif typP =="h"
    L_puls = L;
    t_puls = 0:1/fs:L_puls/f-1/fs;                      %Zeitvektor für einzelnen Puls
    s = zeros(1,ceil(L*(fs/f)));
        L_start = 1;    %Start
        add = sin(2*pi*f*t_puls);
        s(L_start:L_start+length(t_puls)-1) = s(L_start:L_start+length(t_puls)-1)+add;
    %figure(1);
    t = 0:1/fs:(length(s)-1)/fs;
    %plot(t,s,'b');
    %figure(2); clf;
    f_achse = 0:fs/length(s):fs-fs/length(s);
    %plot(f_achse,abs(fft(s)));
end
end