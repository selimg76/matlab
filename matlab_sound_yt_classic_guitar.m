%%% 1ST BLOCK %%%
clear
close all
%first let's see the properties of the recorded file:
info = audioinfo('eadgbe.mp3')
%let's import the file with the audioread command: 
[y,Fs] = audioread('eadgbe.mp3');
%let's see the waveform by plotting it
figure
plot(y);
title('Raimundo Classical Guitar eadgbe');
%and now let's see if we can play it properly in matlab:
p = audioplayer(y, 48000);
play(p)
y=y(:,1); %reducing to one channel


%%% 2ND BLOCK %%%
%resampling the original signal to reduce data size:
res_y=resample(y,20000,Fs);
figure
plot(res_y);
title('Raimundo Classical Guitar Resampled Signal eadgbe');
%let's play to see if we can understand the difference
% p = audioplayer(res_y, 20000);
% play(p)


%%% 3RD BLOCK %%%
%getting the A note (2nd played note, 5th string)
y2_A= y(295000:434000,1);
figure
plot(y2_A);
title('Guitar note A');
%let's play A only to see whether we cropped well:
p = audioplayer(y2_A, 48000);
play(p)


%%% 4TH BLOCK %%%
%resampling the A note:
res_y2_A=resample(y2_A,20000,Fs);
figure
plot(res_y2_A);
title('Guitar Resampled note A');
%let's play resampled A only to see if we can understand the difference
% p = audioplayer(res_y2_A, 20000);
% play(p)


%%% 5TH BLOCK  %%%
four_tr = fft(y2_A); % discrete Fourier transform of note A
n = length(y2_A); % number of samples
fs=48000;
f = (0:n-1)*(fs/n); % frequency range
power = abs(four_tr).^2/n; % power of the DFT
figure
plot(f,power)
xlim([0 10000])
title('Guitar Note A Freq Spectrum');
xlabel('Frequency')
ylabel('Power')


%%% 6TH BLOCK A  %%%
%comparing low E and high E: octave + base frequency
%now let's play low E only (1st note played):
y2_lowE= y(36000:179000,1);
figure
plot(y2_lowE);
title('note low E');
%let's play low E only to see whether we cropped well:
p = audioplayer(y2_lowE, 48000);
play(p)


%%% 6TH BLOCK B  %%%
four_tr = fft(y2_lowE); % discrete Fourier transform
n = length(y2_lowE); % number of samples
fs=48000;
f = (0:n-1)*(fs/n); % frequency range
power = abs(four_tr).^2/n; % power of the DFT
figure
plot(f,power)
title('note low E Freq Spectrum');
xlim([0 9000])
xlabel('Frequency')
ylabel('Power')


%%% 6TH BLOCK C  %%%
%now let's high E only (last-6th note played):
y2_highE= y(1320000:end,1);
figure
plot(y2_highE);
title('note high E');
%let's play A only to see whether we cropped well:
p = audioplayer(y2_highE, 48000);
play(p)


%%% 6TH BLOCK D  %%%
four_tr = fft(y2_highE); % discrete Fourier transform
n = length(y2_highE); % number of samples
fs=48000;
f = (0:n-1)*(fs/n); % frequency range
power = abs(four_tr).^2/n; % power of the DFT
figure
plot(f,power)
xlim([0 9000])
title('note high E Freq Spectrum');
xlabel('Frequency')
ylabel('Power')

%What if we want to observe the frequency components in time?
%we can use discrete fourier transform and spectrogram for this:


%%% 7TH BLOCK  %%%
figure
spek=spectrogram(res_y2_A,4000,15,960,20000);
spectrogram(res_y2_A,4000,15,960,20000);
title('Guitar Note A2 Spectrum');


%%% 8TH BLOCK  %%%
figure
spek_whole=spectrogram(res_y,4000,15,960,20000); %better resolution
spectrogram(res_y,4000,15,960,20000);
title('Guitar eadgbe Spectrum');
