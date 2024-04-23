% Creates a plot showing a filter specification given cutoff frequencies, passband ripple and stopband attenuation.
% Optionally displays the frequency response of a filter superimposed if give b and a coefficients of the filter.
%
% Frequencies given normalised to between 0 and 1. 1 equates to Nyquist frequency or pi/rads per sample. 
%
% Example 1. Low pass filter with passband cutoff at 0.3, passband ripple of 0.6 dB, stopband at 0.8 with stopband attenuation of 20db.
% create_filter_spec_plot(0.3,0.8, 0.3 ,20)
%
% Example 2. Stop band filter with stopband edge frequencies of 0.3 and 0.5. Passband edge frequencies of 0.1 and 0.8. Passband ripple of 4dB and stopband attenuation of 50dB
% create_filter_spec_plot([0.1 0.8],[0.3 0.5], 4 ,50)
%
% Example 3. Demonstrate how to display filter frequency response with filter spec.
%  [b a] = butter(5, 1.2, 'low');
%  create_filter_spec_plot(0.1, 0.5, 0.3, 40,b,a)
%
% Ref.: David Dorran, October 13, 2013
% https://dadorran.wordpress.com/2013/10/13/create_filter_spec_plot/

function create_filter_spec_plot(PB_edge_freq,SB_edge_freq, PB_ripple ,SB_attenuation, varargin)
  
if nargin == 6
    b = varargin{1}
    a = varargin{2}
else
    b = [];
    a = [];
end
 
PB_edge_freq = round(PB_edge_freq*1000)/1000; 
SB_edge_freq = round(SB_edge_freq*1000)/1000;
 
if length(PB_edge_freq) == 1 && length(SB_edge_freq) == 1
    %low pass or high pass
    if(PB_edge_freq > SB_edge_freq)
        filter_type = 'High Pass'; 
        PB(1,:) = [PB_edge_freq 1];
        SB(1,:) = [0 SB_edge_freq];
    else
        filter_type = 'Low Pass';
        SB(1,:) = [SB_edge_freq 1];
        PB(1,:) = [0 PB_edge_freq];
    end
else
    % band pass or stop band
    if(PB_edge_freq(1) > SB_edge_freq(1))
        filter_type = 'Band Pass';
        PB(1,:) = [PB_edge_freq(1) PB_edge_freq(2)];
        SB(1,:) = [0 SB_edge_freq(1)];
        SB(2,:) = [SB_edge_freq(2) 1];
    else
        filter_type = 'Stop Band';
        SB(1,:) = [SB_edge_freq(1) SB_edge_freq(2)];
        PB(1,:) = [0 PB_edge_freq(1)];
        PB(2,:) = [PB_edge_freq(2) 1];
    end
end
  
figure
hold on
num_bins = 10000;
fax = 0:1/(num_bins-1):1;
lowest_display_attenuation = -1*(SB_attenuation*2); 
[rows cols] = size(PB);
for k = 1: rows
    sig1 = ones(1, num_bins)*NaN;
    sig1(round(PB(k,1)*num_bins)+1 : round(PB(k,2)*num_bins)) = 0;
    sig2 = ones(1, num_bins)*NaN;
    sig2(round(PB(k,1)*num_bins)+1 : round(PB(k,2)*num_bins)) = -1*PB_ripple;
    sig2(round(PB(k,1)*num_bins)+1) = sig1(round(PB(k,1)*num_bins)+1);
    sig1(round(PB(k,2)*num_bins)) = sig2(round(PB(k,2)*num_bins));
    plot(fax,sig1,'k');
    plot(fax,sig2,'k');
    for m = 0-PB_ripple/4 : -PB_ripple/4 : -3*PB_ripple/4;
        sig3 =  ones(1, num_bins)*NaN;
        sig3(round(PB(k,1)*num_bins)+1 : round(PB(k,2)*num_bins)) = m;
        plot(fax,sig3,'k');
    end
end
 
[rows cols] = size(SB);
for k = 1: rows
    num_bins
    sig1 = ones(1, num_bins)*NaN;
    sig1(round(SB(k,1)*num_bins)+1 : round(SB(k,2)*num_bins)) = lowest_display_attenuation;
    sig2 = ones(1, num_bins)*NaN;
    sig2(round(SB(k,1)*num_bins)+1 : round(SB(k,2)*num_bins)) = -1*SB_attenuation;
    sig2(round(SB(k,1)*num_bins)+1 ) = sig1(round(SB(k,1)*num_bins)+1);
    sig1(round(SB(k,2)*num_bins)) = sig2(round(SB(k,2)*num_bins));
    plot(fax,sig1,'k');
    plot(fax,sig2,'k');
    sig3 = ones(1, num_bins)*NaN;
    sig3(round(SB(k,1)*num_bins)+1 : round(SB(k,2)*num_bins)) = lowest_display_attenuation: (-1*SB_attenuation-lowest_display_attenuation)/(length(round(SB(k,1)*num_bins)+1 : round(SB(k,2)*num_bins))-1) :-1*SB_attenuation;
    plot(fax,sig3,'k'); 
    sig4 = ones(1, num_bins)*NaN;
    sig4(round(SB(k,1)*num_bins)+1 : round(SB(k,2)*num_bins)) = fliplr(lowest_display_attenuation: (-1*SB_attenuation-lowest_display_attenuation)/(length(round(SB(k,1)*num_bins)+1 : round(SB(k,2)*num_bins))-1) :-1*SB_attenuation);
    plot(fax,sig4,'k');
end
 
if(length(b)) 
    H = freqz(b,a, num_bins);
    indices = find(H==0);
    H(indices) = 10^-16; %deal with problem of log(0)
    H_db = 20*log10(abs(H));
    %lowest_display_attenuation = min(20*log10(abs(H)))*1.2;
    plot(fax, H_db);
end
 
hold off
ylim([lowest_display_attenuation 0 ]); 
xlim([0 1 ]);
ylabel('System Gain (db)');
xlabel('Normalised Frequency (x\pi rads/sample)')
 
%title([filter_type ' filter. Pass band ripple = ' num2str(PB_ripple) 'dB; Stop band attenuation = ' num2str(SB_attenuation) 'dB.' ]);
