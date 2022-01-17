function [] = imageAbsAndAngel(r,z,E)
%Diese Funktion stellt ein komplexes Bild mit Betrag und Phase dar
%   Dabei ist der Betrag über den Grauwert und die Phase über die Farbe
%   codiert
    absE_max =   max(max(abs(E)));
    absE_norm = abs(E)./ absE_max;
    mask3 = cat(3, absE_norm, absE_norm, absE_norm);

    rgbImage = ind2rgb(round((pi+angle(E))./(2*pi).*255), hsv(256));
    
    imagesc(r,z,rgbImage.*mask3); 
    title(['Maximum des E-Felds = ' num2str(absE_max)]);
end

