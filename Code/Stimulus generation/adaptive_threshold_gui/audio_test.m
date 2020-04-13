deviceWriter = audioDeviceWriter("SampleRate",44100, "Device", "MacBook Pro Speakers");

tst_sound_short = [.01*randn(44100,1), .01*randn(44100,1)];
deviceWriter(tst_sound_short)

n = deviceWriter(tst_sound_short)
m = deviceWriter(tst_sound_short)

%release(deviceWriter)