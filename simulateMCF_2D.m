%%
% Dieses Skript simuliert den Ausgang einer MultiKernFaser als PhasedArray
% bei dem die Phasen der einzelnen Lichtquellen so geschoben werden, dass
% sie in der Fokusposition gleich sind.

clear all
% close all
clc

%%
% Messebene, alle Angaben in um
r1 = -30; r2 = 30;
z1 =   0; z2 = 3000;    %0, 50
%Aufloesung
dr = 0.1;
dz =  10;                %0.1

%Fokusposition
f_r = 0;
f_z = 100;

%generiere Messebene
r = r1:dr:r2;
z = z1:dz:z2;
[R, Z]   = meshgrid(r, z);

%%
% fibre (hexagonal orientation)
MCF_N   = 80;                         % Number of cores
MCF_dc  = 4;                            % core spacing in µm
MCF_cdia = 2;                           % core diameter

% beam
lambda  = 0.666;                    % wavelength
E0      = 1;                        % Energy in focus

%% generate MCF
[cpx, cpy]   = generate_hex_grid(MCF_N,MCF_dc);  % core position x y
MCF_N       = length(cpx);                  % generate_hex_grid generates more then N cores

figure(2) 
    plot(cpx,cpy,'ob')
    xlabel('core pos x [µm]')
    ylabel('core pos y [µm]')
    xlim([min(cpx) max(cpx)])
    ylim([min(cpy) max(cpy)])
    axis image

cpr   = sqrt(cpx.^2+cpy.^2);

[~,IX] = sort(cpr,'ascend'); 
cpx = cpx(IX);
cpy = cpy(IX);
clear cpr IX

%% calculate phase distance and amplitude for desired focus = 0 --> sperical
% wave
% distance to focus
dist_foc    = sqrt((cpx-f_r).^2+(cpy).^2+(f_z).^2); 

% Abstand durch Wellenlänge = Häufigkeit der Durchläufe; Rest -->
% Gangunterschied
% Phase wird berechnet
phi         = mod(dist_foc,lambda)/lambda*2*pi;

%% generate Gaussian Beams
B_k             = 2*pi/lambda;            % k = 2pi/lambda
B_w0            = MCF_cdia/2;             % Strahltaille
B_zr            = pi*B_w0^2/lambda;       % Rayleighlength
E               = zeros(size(R));


for ii = 1:MCF_N
    B_w(:,:,:) = B_w0*sqrt(1+((Z)/B_zr).^2); % core, x,y,z;
    B_R(:,:,:) = Z.*(1+(B_zr./Z).^2);
    B_r(:,:,:) = ((cpx(ii)-R).^2+(cpy(ii)).^2).^.5;     %am -R erkennt man, dass der Abstand in x Richutng berechnet wird, der Strahl sich also in x-Richutng ausbreitet
    
    % Gaußstrahl eines jeden Kerns
    Ecore      = E0*B_w0./B_w.*exp(-B_r./B_w).^2.*exp(-1i*B_k.*B_r.^2./(2*B_R)).*exp(-1i*(B_k*Z-phi(ii)));
    
    % Summation aller E-Felder
    E(:,:,:)   = E+ Ecore;
    disp([num2str(ii) '/' num2str(MCF_N)])
    
    figure(21);
    imageAbsAndAngel(r,z,E); axis image; camroll(90);
    xlabel('r [um]') 
    ylabel('z [um]') 
    drawnow
    %pause(0.1)
    
    
    % optional kann man sich auch den Betrag und die Phase getrennt von
    % einander betrachten:
    
   % Betrag
     figure(22);
     imagesc(r,z,(abs(E))); %axis image; 
     camroll(180); colorbar; colormap gray
     xlabel('r [um]') 
     ylabel('z [um]') 
     drawnow
    
    % Phase
%     figure(23);
%     imagesc(r,z,(angle(E))); axis image; camroll(90); colorbar; colormap hsv
%     xlabel('r [um]') 
%     ylabel('z [um]') 
%     drawnow
    
end

