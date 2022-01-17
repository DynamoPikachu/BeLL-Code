function [Aeout]= Berechnung(f,c,xs,ys,zs,envxs,envys,envzs,xe,ye,ze,As,w0,typR,phi,Ke)
%   Berechnung der Lichtintensität
%   f... Frequenz
%   c... Lichtgeschwindigkeit
%   xs, ys, zs... Sendefläche
%   envxs, envys, envzs... Einheitsnormalenvektoren
%   xe, ye, ze... Empfangsfläche
%   As... Sendeamplitude
%   Ae... Empfangsamplitude
lambda = c/f;
Ae = zeros(1,length(ze));
if typR=="Kugel"
for i=1:length(ze)
    r = sqrt((xs-xe(i)).^2+(ys-ye(i)).^2+(zs-ze(i)).^2);
    Ae(i) = sum(As./r.*exp(-1i*(2*pi/lambda).*r));
end
elseif typR=="Gauss"
        rr=sqrt((xe(Ke)-xs).^2+(ye(Ke)-ys).^2);
        z=ze(Ke)-zs;
        zr=(pi*w0*w0)/lambda;
        invtan=atan(z./zr);
        wz=w0*sqrt(1+(z./zr).^2);
        k=(2*pi)/lambda;
        Rz=z.*(1+(zr./z).^2);
        Ae = sum(As.*exp(1i*phi).*(w0./wz).*exp(-(rr./wz).^2).*exp(-1i.*k.*(rr.^2./(2.*Rz))).*exp(-1i.*(k.*z-invtan)));
end
Aeout = Ae;
