function [phi] = Fokus(xs,ys,zs,f_x,f_y,f_z,lambda)
%FOKUS berechnet den Phasenunterschied, um auf einen Punkt zu fokussieren
%aka überall die gleiche Distanz zu haben
    dist_foc = sqrt((xs-f_x).^2+(ys-f_y).^2+(zs-f_z).^2);
    phi = mod(dist_foc,lambda)/lambda*2*pi;
end

