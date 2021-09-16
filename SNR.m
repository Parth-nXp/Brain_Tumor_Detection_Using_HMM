function snr_power = SNR(signal, noise)

[signalRowSize signalColSize] = size(signal);
[noiseRowSize noiseColSize] = size(noise);

signalAmp = signal(:);
noiseAmp = noise(:);

signalPower = sum(signalAmp.^2)/(signalRowSize*signalColSize);
noisePower = sum(noiseAmp.^2)/(noiseRowSize*noiseColSize);

snr_power = 10*log10(signalPower/noisePower);

end 