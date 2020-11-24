clear
%查看音频数据信息
sourceWaveInf = audioinfo('SunshineSquare.wav');
%读取原声音数据
[audio_data,fs] = audioread('SunshineSquare.wav');

%绘制音频波形
figure
subplot(2,2,1)
t = 0:seconds(1/fs):seconds(sourceWaveInf.Duration);    %时间轴数组
t = t(1:end-1);
plot(t,audio_data)  %画图
grid on
xlabel('Time')  %横轴时间
ylabel('Audio Signal')  %纵轴幅度
title('原音频信号时域波形')  %图表名

%频谱分析
if mod( sourceWaveInf.TotalSamples ,2 ) == 1
    %频谱需要对称的长度，所以要偶数
    sourceWavaLength = sourceWaveInf.TotalSamples - 1;
else
    sourceWavaLength = sourceWaveInf.TotalSamples;
end
subplot(2,2,2)
audioSpectrum = fft(audio_data);    %快速傅里叶变换计算
P2 = abs(audioSpectrum/sourceWavaLength);   %计算双侧频谱
P1 = P2(1:sourceWavaLength/2+1);    %取出单边频谱
P1(2 : end-1) = 2*P1(2 : end-1);    %双边合成单边，就是翻倍了
f = fs*(0:(sourceWavaLength/2))/sourceWavaLength;   %频率轴数组
plot(f,P1)  %画图
grid on
title('滤波前频谱')
xlabel('频率/Hz')
ylabel('FFT')

%设计滤波器
bsFilt_1 = designfilt('bandstopiir','FilterOrder',10,...
'HalfPowerFrequency1',1500,'HalfPowerFrequency2',1650,...
'SampleRate',fs);   %IIR滤波器，滤除1575Hz频率噪点
audioClear_1 = filter(bsFilt_1,audio_data); %滤波

bsFilt_2 = designfilt('bandstopiir','FilterOrder',10,...
'HalfPowerFrequency1',3100,'HalfPowerFrequency2',3200,...
'SampleRate',fs);   %IIR滤波器，滤除3150Hz频率噪点
audioClear_2 = filter(bsFilt_2,audioClear_1); %滤波

% bsFilt_3 = designfilt('bandstopiir','FilterOrder',10,...
% 'HalfPowerFrequency1',4700,'HalfPowerFrequency2',4750,...
% 'SampleRate',fs);   %IIR滤波器，滤除4725频率噪点
bsFilt_3 = designfilt('lowpassiir','FilterOrder',8, ...
        'PassbandFrequency',4000,'PassbandRipple',0.2, ...
        'SampleRate',11025);
audioClear = filter(bsFilt_3,audioClear_2); %滤波

%ding声音时域置零
audioClear(85440:85850) = zeros(1,-85440+85850+1);
audioClear(118500:119000) = zeros(1,-118500+119000+1);

%绘制滤波之后的音频信号
subplot(2,2,3)
plot(t,audioClear)
grid on
xlabel('Time')
ylabel('Audio Signal')
title('滤波后的信号')

%绘制滤波后的频谱
subplot(2,2,4)
audioSpectrum = fft(audioClear);    %快速傅里叶变换计算
P2 = abs(audioSpectrum/sourceWavaLength);   %计算双侧频谱
P1 = P2(1:sourceWavaLength/2+1);    %取出单边频谱
P1(2 : end-1) = 2*P1(2 : end-1);    %双边合成单边，就是翻倍了
f = fs*(0:(sourceWavaLength/2))/sourceWavaLength;   %频率轴数组
plot(f,P1)  %画图
title('滤波后频谱')
xlabel('频率/Hz')
ylabel('FFT')
grid on

%存储滤波后的音频数据
audiowrite('sunshineSquare_Clear.wav',audioClear,fs);
%播放滤波后的声音
sound(audioClear,fs);
%可视化设计的滤波器
% fvtool(bsFilt_1);
