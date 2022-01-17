function [xs,ys,zs,envxs,envys,envzs,As,MCF_cdia] = Sendeflaeche(ns,rs,typS,f_x,f_y,f_z)
%   Erstellen der Sendefläche als Kreis
%   ns... Anzahl der Sendepunkte
%   rs... Ausbreitung der Sendepunkte
%   typ... Anordnung der Sendepunkte: Kreis, Punkt, Linie (in x-Richtung)
if typS=="Kreis"
    As = ones(1,ns);
    xs = 2*rs*rand(1,ns)-rs;
    ys = 2*rs*rand(1,ns)-rs;
    zs = zeros(1,ns);
    envxs = zeros(1,ns);
    envys = zeros(1,ns);
    envzs = ones(1,ns);
    index = find(xs.^2+ys.^2>rs^2);
    xs(index) = [];
    ys(index) = [];
    zs(index) = [];
    As(index) = [];
    envxs(index) = [];
    envys(index) = [];
    envzs(index) = [];
elseif typS=="Punkt"
    As = ones(1,1);
    xs = zeros(1,1);
    ys = zeros(1,1);
    zs = zeros(1,1);
    envxs = zeros(1,1);
    envys = zeros(1,1);
    envzs = ones(1,1);
elseif typS=="Linie"
    As = ones(1,ns);
    xs = -rs:2*rs/ns:rs-rs/ns;
    ys = zeros(1,ns);
    zs = zeros(1,ns);
    envxs = zeros(1,ns);
    envys = zeros(1,ns);
    envzs = ones(1,ns);
elseif typS=="Hex"
    %%Kreisförmige heaxgonale Anordnung, übernommen von Elias Scharf
    % fibre (hexagonal orientation)
    MCF_N   = ns;                           % Number of cores
    MCF_dc  = 4;                            % core spacing in µm
    MCF_cdia = 2;                           % core diameter

    [cpx, cpy]   = generate_hex_grid(MCF_N,MCF_dc);  % core position x y
      MCF_N       = length(cpx);                  % generate_hex_grid generates more then N cores

%     figure(102) 
%       plot(cpx,cpy,'ob')
%        xlabel('core pos x [µm]')
%        ylabel('core pos y [µm]')
%        xlim([min(cpx) max(cpx)])
%        ylim([min(cpy) max(cpy)])
%         axis image

    cpr   = sqrt(cpx.^2+cpy.^2);

    [~,IX] = sort(cpr,'ascend'); 
    cpx = cpx(IX);
    cpy = cpy(IX);
    clear cpr IX
    
    %Integrierung in unsere Sprache
    ns = length(cpx);
    xs = cpx/1E6;
    xs = 0-xs;
    ys = cpy/1E6;
    zs = zeros(1,ns);
    envxs = f_x-xs;
    envys = f_y-ys;
    envzs = f_z-zs;
    envges=(envxs.^2+envys.^2+envzs.^2).^0.5;
    hesse_envxs = envxs/envges;
    hesse_envys = envys/envges;
    hesse_envzs = envzs/envges;
    As = ones(1,ns);
end


