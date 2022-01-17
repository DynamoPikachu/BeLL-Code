function [xe,ye,ze,Ae] = Empfangsflaeche(ne, lambda, faktor, typE, abstand, nx, breiteE, nz, laengeE, f_x, f_y, f_z)
%   ne... Anzahl der Empfangspunkte
%   lambda... Wellenlände
%   faktor... Ausbreitung der Empfangspunkte im Verhältnis zur Wellenlänge
%   typ...  Punkt, xLinie, zLinie, Kreis, Kugel
if typE=="Punkt"
    ze = ones(1,1*0.005);
    ye = zeros(length(ze));
    xe = zeros(length(ze));
    Ae = zeros(length(ze));
elseif typE=="xLinie"
    xe = lambda:lambda:faktor*lambda;
    ye = zeros(length(xe));
    ze = abstand*ones(length(xe));
    Ae = zeros(length(xe));
elseif typE=="zLinie"
    ze = lambda:lambda:faktor*lambda;
    ye = zeros(length(ze));
    xe = zeros(length(ze));
    Ae = zeros(length(ze));
elseif typE=="Kreis"
    Ae = ones(1,ne);
    xe = 2*faktor*lambda*rand(1,ne)-faktor*lambda;
    ye = 2*faktor*lambda*rand(1,ne)-faktor*lambda;
    ze = abstand*ones(1,ne);
    index = find(xe.^2+ye.^2>(faktor*lambda)^2);
    xe(index) = [];
    ye(index) = [];
    ze(index) = [];
    Ae(index) = [];
elseif typE=="Kugel"
    Ae = ones(1,ne);
    xe = 2*faktor*lambda*rand(1,ne)-faktor*lambda;
    ye = 2*faktor*lambda*rand(1,ne)-faktor*lambda;
    ze = 2*faktor*lambda*rand(1,ne)-faktor*lambda;
    index = find(xe.^2+ye.^2+ze.^2>(faktor*lambda)^2);
    xe(index) = [];
    ye(index) = [];
    ze(index) = [];
    Ae(index) = [];
elseif typE=="RechteckS" %Senkrecht zur Ausbreitungsrichtung
Ae = ones(1,ne);
    xe = 2*faktor*lambda*rand(1,ne)-faktor*lambda;
    ye = 2*faktor*lambda*rand(1,ne)-faktor*lambda;
    ze = abstand+zeros(1,ne);
elseif typE=="RechteckP" %Parallel zur Aurbreitungsrichtung
    
    xe = zeros(1,nx*nz);
    ye = xe;
    ze = xe;
    Ae = xe;
    zahler = 1;
    for K = 1:nx
        for L = 1:nz %großes L weil kleines wie Eins
            xe(zahler) = (-0.5*(nx-1))*(breiteE/(nx-1))+(K-1)*(breiteE/(nx-1));     
            ze(zahler) = f_z;
            zahler = zahler+1;
        end
    end
    xe = xe+f_x;
end

