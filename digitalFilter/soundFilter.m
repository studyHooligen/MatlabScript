clear
%�鿴��Ƶ������Ϣ
sourceWaveInf = audioinfo('SunshineSquare.wav');
%��ȡԭ��������
[audio_data,fs] = audioread('SunshineSquare.wav');

%������Ƶ����
figure
subplot(2,2,1)
t = 0:seconds(1/fs):seconds(sourceWaveInf.Duration);    %ʱ��������
t = t(1:end-1);
plot(t,audio_data)  %��ͼ
grid on
xlabel('Time')  %����ʱ��
ylabel('Audio Signal')  %�������
title('ԭ��Ƶ�ź�ʱ����')  %ͼ����

%Ƶ�׷���
if mod( sourceWaveInf.TotalSamples ,2 ) == 1
    %Ƶ����Ҫ�ԳƵĳ��ȣ�����Ҫż��
    sourceWavaLength = sourceWaveInf.TotalSamples - 1;
else
    sourceWavaLength = sourceWaveInf.TotalSamples;
end
subplot(2,2,2)
audioSpectrum = fft(audio_data);    %���ٸ���Ҷ�任����
P2 = abs(audioSpectrum/sourceWavaLength);   %����˫��Ƶ��
P1 = P2(1:sourceWavaLength/2+1);    %ȡ������Ƶ��
P1(2 : end-1) = 2*P1(2 : end-1);    %˫�ߺϳɵ��ߣ����Ƿ�����
f = fs*(0:(sourceWavaLength/2))/sourceWavaLength;   %Ƶ��������
plot(f,P1)  %��ͼ
grid on
title('�˲�ǰƵ��')
xlabel('Ƶ��/Hz')
ylabel('FFT')

%����˲���
bsFilt_1 = designfilt('bandstopiir','FilterOrder',10,...
'HalfPowerFrequency1',1500,'HalfPowerFrequency2',1650,...
'SampleRate',fs);   %IIR�˲������˳�1575HzƵ�����
audioClear_1 = filter(bsFilt_1,audio_data); %�˲�

bsFilt_2 = designfilt('bandstopiir','FilterOrder',10,...
'HalfPowerFrequency1',3100,'HalfPowerFrequency2',3200,...
'SampleRate',fs);   %IIR�˲������˳�3150HzƵ�����
audioClear_2 = filter(bsFilt_2,audioClear_1); %�˲�

% bsFilt_3 = designfilt('bandstopiir','FilterOrder',10,...
% 'HalfPowerFrequency1',4700,'HalfPowerFrequency2',4750,...
% 'SampleRate',fs);   %IIR�˲������˳�4725Ƶ�����
bsFilt_3 = designfilt('lowpassiir','FilterOrder',8, ...
        'PassbandFrequency',4000,'PassbandRipple',0.2, ...
        'SampleRate',11025);
audioClear = filter(bsFilt_3,audioClear_2); %�˲�

%ding����ʱ������
audioClear(85440:85850) = zeros(1,-85440+85850+1);
audioClear(118500:119000) = zeros(1,-118500+119000+1);

%�����˲�֮�����Ƶ�ź�
subplot(2,2,3)
plot(t,audioClear)
grid on
xlabel('Time')
ylabel('Audio Signal')
title('�˲�����ź�')

%�����˲����Ƶ��
subplot(2,2,4)
audioSpectrum = fft(audioClear);    %���ٸ���Ҷ�任����
P2 = abs(audioSpectrum/sourceWavaLength);   %����˫��Ƶ��
P1 = P2(1:sourceWavaLength/2+1);    %ȡ������Ƶ��
P1(2 : end-1) = 2*P1(2 : end-1);    %˫�ߺϳɵ��ߣ����Ƿ�����
f = fs*(0:(sourceWavaLength/2))/sourceWavaLength;   %Ƶ��������
plot(f,P1)  %��ͼ
title('�˲���Ƶ��')
xlabel('Ƶ��/Hz')
ylabel('FFT')
grid on

%�洢�˲������Ƶ����
audiowrite('sunshineSquare_Clear.wav',audioClear,fs);
%�����˲��������
sound(audioClear,fs);
%���ӻ���Ƶ��˲���
% fvtool(bsFilt_1);
