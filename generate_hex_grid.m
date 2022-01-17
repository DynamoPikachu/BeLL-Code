function [cpx cpy] = generate_hex_grid(N,dc)
%generates a hex grid in circular shape with N elements and an element
%spacing of dc
%cpx and cpy are the x and y coordinates of the grid centers
% example input
% N   = 6000;
% dc  = 3;                % distance cores

% generate
ncx = sqrt(2)*ceil(sqrt(N));  % number cores x; ceil = Ganze Zahl
ncy = ncx;              % number cores y
nct = ncx*ncy; % number cores total

core = 1;
for ii = 1:ncx
    for jj = 1:ncy
        if rem(jj,2);   %Rest; gerade/ungerade
            cpx(core) = (ii-1)*dc;
        else
            cpx(core) = (ii-1)*dc+dc/2;
        end
        cpy(core) = (jj-1)*sqrt(3)/2*dc;        % FEHLER dc/2 statt dc
        core = core+1;
    end
end

% fit to circular shape and remove outer cores
cpx = cpx-mean(cpx); % Mittelpunkt zentrieren
cpy = cpy-mean(cpy);

cpx2(2*sqrt(cpx.^2+cpy.^2)>(dc*sqrt(N/0.9)))= NaN; 
% skaliert auf Kreis; außenliegende Punkte werden abgeschnitten 
% NaN =  Not a Number
cpy2(2*sqrt(cpx.^2+cpy.^2)>(dc*sqrt(N/0.9)))= NaN;

cpx(isnan(cpx2))=[]; 
%füge Leerzeilen ein für abgeschnittene Stellen
cpy(isnan(cpy2))=[];


