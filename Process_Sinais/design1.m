% Ref.: Designing a Digital filter from given Transfer function ? Coefficient Calculation ?
% URL: https://www.mathworks.com/matlabcentral/answers/83094-designing-a-digital-filter-from-given-transfer-function-coefficient-calculation

clc; clear; close all;
 fs = 8e3;
 fc = [200 3.5e3];
 order = 2;
 % b - nominator of complex transfer function; a - denominator;
 [b, a] = butter(order, 2*fc/fs, 'bandpass');
 disp([{'Numerator'} num2str(b); {'Denominator'} num2str(a)])
 %%check
 f = fs/2*linspace(0, 1, 8192);
 h = freqz(b,a, 8192);
 K_dB = 20*log10(abs(h));
 plot(f/1e3, K_dB, fc/1e3, [-3 -3], 'or', 'LineWidth', 2); grid on;
 xlabel('frequency, kHz'); ylabel('|H|, dB')
 axis([min(f/1e3) max(f/1e3) -60 10])