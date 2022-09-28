function [F,FBL] = fittingmodel(fitType)
	if(nargin == 0 || strcmp(fitType,'exp2'))
		fitBL = @(x,f) fitAP(x(1),x(2),x(3),x(4),2*pi*f);
	elseif(strcmp(fitType,'lorenz'))
		fitBL = @(x,f) fitLorenz(x(1),x(2),x(3),x(4),2*pi*f);
	end
	F = @(f,x) fitBL(x(1:4),f) + fitPeaks(x(5:end),f);
	FBL = @(f,x) fitBL(x(1:4),f);
end
function y = fitAP(tau1,tau2,ratio,mag,f)
	y0 = (tau1-tau2)^2 ./ ((1+tau1^2*f.^2).*(1+tau2^2*f.^2));
	y = mag + log10(exp(ratio)+y0);
end
function y = fitLorenz(tau1,tau2,ratio,mag,f)
	% y0 = ratio./(1+tau1^2*f.^2) + (1-ratio)./(1+tau2^2*f.^2);
	% y = mag + log10(y0);
	y = log10(10^ratio./(1+tau1^2*f.^2) + 10^mag./(1+tau2^2*f.^2));
end
function y = fitPeaks(x,f)
	y = zeros(size(f));
	for i = 1:3:length(x)
		y = y+fitGauss(x(i),x(i+1),x(i+2),f);
	end
end
function y = fitGauss(mu,hgt,sig,f)
	y = hgt * exp(-(f-mu).^2 / (2*sig^2));
end
