function y = myGauss(p,x)

    y = p(1)*exp(-((x-p(2)).^2)/p(3));
end