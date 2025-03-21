# FFT based FIR filter design

Ref.; [FFT based FIR filter design](https://dadorran.wordpress.com/2019/07/19/372/), David Dorian, July 19, 2019, acessado em 22/04/2024.

Parece estar associado com video: [fft based FIR filter design (windowing and phase issues)](https://www.youtube.com/watch?v=R4RpNG_Botk), de David Dorran, 4.667 visualizações  19 de jul. de 2019.

Explains impact of windowing and phase on FIR filter design  and shows some matlab/octave code implementation at the end of the video.

> Aqui está um link para uma prova de que uma janela retangular no domínio da frequência é uma função sinc --> [The Rectangular Window](https://ccrma.stanford.edu/~jos/sasp/Rectangular_Window.html).



```matlab
%% This script deals issues related with 'fft' based FIR filter design
% See youtube video at https://youtu.be/R4RpNG_Botk
% David Dorran, July 19, 2019
% Ref.: https://dadorran.wordpress.com/2019/07/19/372/

% GO TO lines 115 to 133 if you want to skip the preamble
 
%% First show fft of finite number of impulse response samples  lie on the continuous spectrum
%Design a band reject filter using buit-in fir1 function
b = fir1(22, [0.3913 0.6522],'stop'); %cutoff frequency is (0.3, 0.6 x pi) radians/sample = 0.3,0.6 x fs/2;
h = b; % The non-zero values of the impulse response of any fir filter 
       %   is equal to the b coefficients
H = fft(h); % Frequency response bin values
bin_freqs = [0:length(H)-1]/length(H)*2*pi; 
 
%% Create the continuous spectrum
% Going to do this three ways - just for the purpose of demonstration. 
% The mathematical formula for the frequency response of an mth order FIR is:
%   H(w) = b0 + b1*e^-jw + b2*e^-2jw + b3*e^-2*jw + ... ... + bm*e^(-m*jw)
%
%   This equation comes from the fact that H(w) = H(z) when z= e^jw i.e. when H(z) is
%   evaluated around the unit circle (see https://youtu.be/esZ_6n-qHuU )
%  The transfer function H(z) = b0*Z^0+b1*z^-1+b2*z^-2+b3*z-3+ ... +bmz^-m
 
% We'll create a 'continuous' spectrum by evaluating this equation for a
% "large" number of frequencies, w.
 
% Two alternatives to creating a 'continuous' spectrum are to zero pad the
% b coefficients by a "large" amount prior to taking the fft; and to use the built in freqz
% function. I'll use all three approaches here for comparison purposes.
 
% METHOD 1 - zero-pad method
H_cont_1 = abs(fft([h zeros(1,10000)])); % the value of 10000 could be any relatively large number i.e. large enough to capture the spectral detail of the frequency response
w_cont_1 = [0:length(H_cont_1)-1]/length(H_cont_1)*2*pi;
 
% METHOD 2 - freqz method
[H_cont_2_complex w_cont_2] = freqz(b,1,length(H_cont_1), 'whole'); % the second parameter of freqz is the a coefficients
H_cont_2 = abs(H_cont_2_complex);
 
% METHOD 3 -evaluate H(z) around the unit circle method (see
%https://youtu.be/esZ_6n-qHuU)
H_cont_3_complex = [];
k = 0;
w_cont_3 = [0:length(H_cont_1)-1]/length(H_cont_1)*2*pi;
for w = w_cont_3
    k = k + 1;
    H_cont_3_complex(k) = b(1);
    for ind = 2:length(b)
        H_cont_3_complex(k) = H_cont_3_complex(k) + b(ind)*exp(-1i*w*(ind-1));
    end
end
 
H_cont_3= abs(H_cont_3_complex);
 
%% plot 'continuous' frequency response and overlay 'sampled' bin values
figure
plot(w_cont_1, H_cont_1,'LineWidth', 6)
hold on
plot(w_cont_2, H_cont_2,'LineWidth', 3)
plot(w_cont_3, H_cont_3)
plot(bin_freqs, abs(H),'g.','MarkerSize', 16) 
xlabel('Frequency (radians per sample)')
ylabel('Magnitude')
legend('Cont. Freq Resp Method 1', 'Cont. Freq Resp Method 2', 'Cont. Freq Resp Method 3', 'Bin Values')
title('Frequency response of filter using a built-in filter design technique')
set(gcf,'Position',[22 416 613 420]);
 
%% Now let's try and design a filter by starting with the desired frequency response
% First we'll look at the band pass filter
H_desired = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0];
freq_bins_desired = [0:length(H_desired)-1]/length(H_desired)*2*pi;
b_ifft = ifft(H_desired); %b coefficients of newly designed filter
h_ifft = b_ifft; 
 
% Now compute the continuous spectrum using any of the methods above. (Zero
% padding b_ifft prior to taking the fft is the most straightforward
% appraoch - I think!)
H_cont_desired = abs(fft([b_ifft zeros(1,1000)]));
w_cont_desired = [0:length(H_cont_desired)-1]/length(H_cont_desired)*2*pi;
 
figure
plot(w_cont_desired, H_cont_desired);
hold on
plot(freq_bins_desired, H_desired,'r.','MarkerSize', 12) 
 
xlabel('Frequency (radians per sample)')
ylabel('Magnitude')
legend('Continuous Frequency Response','DFT bin values of desired frequency response')
title('Frequency response of band pass filter using ''inverse fft'' filter design technique')
set(gcf,'Position',[649   190   610   420]);
 
%% 
% We'll now mimic the 'desired' filter shown in the video i.e. a band reject filter
H_desired = [1 1 1 1 1 0 0 0 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1];
freq_bins_desired = [0:length(H_desired)-1]/length(H_desired)*2*pi;
b_ifft = ifft(H_desired);
 
 
% Now compute the continuous spectrum using any of the methods above. (Zero
% padding b_ifft prior to taking the fft is the most straighforward
% appraoch I think)
H_cont_desired = abs(fft([b_ifft zeros(1,1000)]));
w_cont_desired = [0:length(H_cont_desired)-1]/length(H_cont_desired)*2*pi;
 
figure
plot(w_cont_desired, H_cont_desired);
hold on
plot(freq_bins_desired, H_desired,'r.','MarkerSize', 12) 
 
xlabel('Frequency (radians per sample)')
ylabel('Magnitude')
legend('Continuous Frequency Response','DFT bin values of desired frequency response')
title('Frequency response of band reject filter using ''inverse fft'' filter design technique')
set(gcf,'Position',[649   190   610   420]);
 
%%
% Now try using a 'practical' linear phase response rather than phase values of zero
 
H_desired = [1 1 1 1 1 0 0 0 1 1 1 1 1 1 1 1 0 0 0 1 1 1 1];
% An alternative way to create H_desired to ensure first half is a mirror
% image of the second half (for odd lengths only!)
% H_desired = [1 1 1 1 1 0 0 0 1 1 1 1];
% H_desired = [H_desired fliplr(H_desired(2:end))]
 
phase_diff = pi/length(H_desired)-pi;
phase_desired = [0:floor(length(H_desired)/2)]*phase_diff;
phase_desired = [phase_desired fliplr(phase_desired(2:end))*-1];
 
freq_bins_desired = [0:length(H_desired)-1]/length(H_desired)*2*pi;
h_ifft = ifft(H_desired.*exp(j*phase_desired));
 
 
b_ifft = h_ifft; %b coefficients of newly designed filter
%b_ifft = h_ifft.*hanning(length(h_ifft))'; %windowed b coefficients of newly designed filter 
 
% Now compute the continuous spectrum using any of the methods above. (Zero
% padding b_ifft prior to taking the fft is the most straighforward
% approach - I think!)
H_cont_desired = abs(fft([b_ifft zeros(1,1000)]));
w_cont_desired = [0:length(H_cont_desired)-1]/length(H_cont_desired)*2*pi; %frequency axis
 
plot(w_cont_desired, H_cont_desired, 'Linewidth', 1);
hold on
plot(freq_bins_desired, H_desired,'r.','MarkerSize', 12) 
 
xlabel('Frequency (radians per sample)')
ylabel('Magnitude')
legend('Continuous Frequency Response','DFT bin values of desired frequency response')
title('Frequency response of band reject filter using ''inverse fft'' filter design technique')
set(gcf,'Position',[649   190   610   420]);
 
%% Demonstration of filters being a sum of prototype bandpass filters
% H_acc is the accumulation of individual prototype bandpass filter
 
H_prot = zeros(size(H_desired)); %initialise
%start with the DC prototype filter
H_prot(1) = H_desired(1).*exp(j*phase_desired(1));
H_acc = fft(ifft(H_prot), length(H_cont_desired)); 
 
% loop through 11 prototype band pass filters
show_plots = 0;
if(show_plots)
    figure
end
for k = 1: 11 
    prot_bins = [k+1 24-k] %pair of bins associated with positive and negative frequencies
    H_prot = zeros(size(H_desired)); %initialise
    H_prot(prot_bins) = H_desired(prot_bins).*exp(j*phase_desired(prot_bins));
     
    H_cont_prot = fft(ifft(H_prot), length(H_cont_desired));
    H_acc = H_acc + H_cont_prot; %accumulate each individual band pass prototype
    if(show_plots)
        plot(abs(H_acc))
        hold on
        plot(abs(H_cont_prot))
        hold off
        pause(1)
    end
end
 
sum(abs(H_acc) - abs(H_cont_desired))
```

Fim.