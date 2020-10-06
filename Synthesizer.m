clear all;
% read data and create base parameters
T = readtable('parameters.txt', 'ReadVariableNames', true);
fc = table2array(T(:,1));
fs = table2array(T(1,2));
time = table2array(T(1,3));

% time interval
dt = 1/fs;
t = 0:dt:time-dt;

% create string sound for all fc
string = zeros(length(fc), fs*time);
for i = 1:length(fc)
    string(i,:) = StringSound(fc(i), fs, time);
end
string = sum(string);
string = string/max(abs(string));

% output
string_int16 = cast(string * 2^15, 'int16');
audiowrite('string_int16.wav', string_int16, 44100);
plot(t,string);
sound(string, fs);

% Karplus-Strong Algorithm
function string = StringSound(fc_, fs_, time_)
    noise = wgn(int16(fs_/fc_),1,0);
    string = zeros(1, fs_*time_);
    for i = 1:length(noise)
        string(i) = noise(i);
    end
    for i = length(noise):length(string)
        string(i) = 0.99*(string(i-length(noise) + 2) + string(i-length(noise) + 1))/2;
    end
    string = string/max(abs(string));
end
