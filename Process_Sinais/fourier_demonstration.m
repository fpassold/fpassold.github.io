% illustration of Fourier Theory using plots
%
% usage : fourier_demonstration(1) % a well defined signal
%          fourier_demonstration(2)  % a segment of speech signal (download from https://www.dropbox.com/s/bw4dpf93xxz1lyb/speech_seg.wav)
%          fourier_demonstration(3)  % a SQUARE WAVE
%          fourier_demonstration(4)  % an impulse
%
% David Dorran, March 27, 2014
% Ref.: https://dadorran.wordpress.com/2014/03/27/matlab-fourier-demo/

function fourier_demonstration(num)
if(num==1)
    %sum of sinusoids as input
    t = 0:1/16000:1-1/16000;
    s1 = cos(2*pi*1*t);%cosw(16000,1, 16000, 0);
    s2 = cos(2*pi*5*t)*5;%cosw(16000,5, 16000, 0)*5;
    s3 = cos(2*pi*10*t + pi/2+0.56)*3;%cosw(16000,10, 16000, pi/2+0.56)*3;
    s4 = cos(2*pi*8*t+pi)*3;%cosw(16000,8, 16000, pi)*3;
    s5 = cos(2*pi*12*t+pi/2.2)*3;%cosw(16000,12, 16000, pi/2.2)*3;
    s6 = cos(2*pi*3*t+pi/2+0.4);%cosw(16000,3, 16000, pi/2+0.4)*3;
    sig = s1+s2+s3+s2+s3+s4;
elseif(num==2)
     % sig = wavread('speech_seg.wav');   % função válida para versões
     % antigas de matlab
     % In new versions of MATLAB wavread is no longer supported.
     % Ref.: https://www.mathworks.com/matlabcentral/answers/338556-converting-code-to-use-wavread-to-audioread
% >>info = audioinfo('speech_seg.wav')
% info = 
%  struct with fields:
%
%             Filename: '/Users/fernandopassold/Documents/GitHub/fpassold.github.io/Process_Sinais/speech_seg.wav'
%    CompressionMethod: 'Uncompressed'
%          NumChannels: 1
%           SampleRate: 16000
%         TotalSamples: 230
%             Duration: 0.014375
%                Title: []
%              Comment: []
%               Artist: []
%        BitsPerSample: 16

     % 
     % [sig, Fs] = audioread('speech_seg.wav');
     sig = audioread('speech_seg.wav');
elseif(num==3)    
    sig = [zeros(1,100) ones(1,100) zeros(1,100) ones(1,100) zeros(1,100) ones(1,100) zeros(1,100) ones(1,100) ];
     sig = (sig-0.5)*2; 
else
    sig = [zeros(1, 200) 1 zeros(1,200)]; 
end
sig = sig - mean(sig);
 
N = length(sig);
ft = fft(sig);
ft(round(length(ft)/2)-2:end) = [];
mags = abs(ft);
phases = angle(ft);
dc_mag = mags(1);
mags(1) = [];
phases(1) = [];
 
[sorted_mags sorted_indices] = sort(mags,2);
% sort in decending order
sorted_mags = fliplr(sorted_mags);
sorted_indices = fliplr(sorted_indices);
sorted_phases = phases(sorted_indices);
 
synth_op = zeros(1, N);
sig = sig -dc_mag;
n = [0:N-1]; % sample numbers
 
ylim_max = max([ sorted_mags(1)/N*2 sig])*1.05;
ylim_min = min([ -sorted_mags(1)/N*2 sig])*1.05;
ylims = [ylim_min ylim_max ];
    subplot(3,1,1)
    plot(sig)
    set(gca,'Xticklabel','', 'YLim', ylims)
    set(gca,'Xticklabel','')
    ylabel('Amplitude')
    xlabel('Time')
    title('Example Signal');
pause
colors = 'rgkbm';
significant_freqs = find(sorted_mags > max(sorted_mags/100));
freq_vals_to_display = max(sorted_indices(1:length(significant_freqs))) +1 ;
u = length(mags);
% for k  = 1: length(mags)
for k  = 1: u
    omega = 2*pi*(sorted_indices(k))/N;
    sinusoid = cos(n*omega+sorted_phases(k))*sorted_mags(k)/N*2 ;
    if(sorted_mags(k) < 10^-6)
        break
    end
    synth_op = synth_op + sinusoid;
    subplot(3,1,1)
    plot(sig)
    set(gca,'Xticklabel','', 'YLim', ylims)
    hold on 
    plot(synth_op,'r', 'LineWidth', 2)
    set(gca,'Xticklabel','')
    ylabel('Amplitude')
    xlabel('Time')
    if k ==1
        title('Example signal and sinusoid shown in lower plot');
    else
        title(['Example signal and ' num2str(k) ' sinusoids shown in middle plot added together.']);
    end
    hold off
    subplot(3,1,2)
    hold on
    plot(sinusoid,colors(rem(k,5)+1), 'LineWidth', 2)
    set(gca,'Xticklabel','')
    %set(gca, 'Ylim', [-max(mags)/N*2 max(mags)/N*2]) 
    set(gca, 'Ylim', ylims) 
    ylabel('Amplitude')
    xlabel('Time')
    subplot(3,1,3);
    ft_mag_vals = ones(1, freq_vals_to_display)*NaN;
    sorted_indices(k) 
    if( sorted_indices(k) < freq_vals_to_display)
        ft_mag_vals(sorted_indices(k)) = sorted_mags(k)/N*2;
    end
    hold on
    %stem([0:freq_vals_to_display],[NaN ft_mag_vals],'^')
    stem([0:freq_vals_to_display],[NaN ft_mag_vals],'o', 'LineWidth', 2)
    hold off
    ylabel('Magnitude')
    xlabel('Normalised Frequency (1/(periods displayed))')
    fprintf('k = %3i/%3i\n',k,u); 
    pause
    %plot(sinusoid,colors(rem(k,6)+1))%
end
% close all