
[
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen reverb.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen w: synth.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen1.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/noise.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/st.rhondi .wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/st.rhondi bass.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/st.rhondi reverb.wav",
"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/st.rhondi w: synth.wav"
]

b=Buffer.alloc(s, 120*48000, 1);


(
n = Buffer.read(s,"/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/noise.wav");

SynthDef(\noise, {
	arg freq, gate = 1, amp = 0.5, source, pan = 0;
	source = n;
	Out.ar(0, source)
}).play;
)


(
var noiseEnv;
noiseEnv = Env.asr(0.3, 1, 4, [3, -2]);
z = Buffer.sendCollection(s, noiseEnv.discretize, 1);

SynthDef(\noiseGrain, { |out, gate = 1, amp, sndbuf, envbuf|
	var pan, env, freqdef;
	pan = SinOsc.kr([-1,1]);
	env = EnvGen.kr(
		Env([0,1,0], [1,1], \sin, 1),
		gate,
		levelScale: amp,
		doneAction: 0);
	Out.ar(out,
		GrainBuf.ar(2, Impulse.kr(10), 0.1, sndbuf, LFNoise1.kr.range(0.5,2),
			LFNoise2.kr(0.1).range(0,1), 2, pan, envbuf) * env)
}).send;
)

Synth(\noiseGrain);

b.free;

-------

(
g = Buffer.alloc(s, 10*48000, 1);

SynthDef("playBuf", {| out = 0, buffer, rate = 1, trigger = 1, startPos = 0, loop = 1 |
	Out.ar(out, Pan2.ar(PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * rate, trigger, BufFrames.ir(buffer) * startPos, loop),0.0))
}).send;

g = Buffer.read(s, "/Volumes/GoogleDrive/My Drive/Comp Stuff/New Comp Proj./deer song 1/Audio for SC/ellen1.wav");

Synth(\playBuf, [\out, 0, \buffer, g]);
)
(
SynthDef("grain",{ arg sampbuf=0,rate=1.0,startPos=0, size=1, amp=0.5;
	Out.ar(0, Pan2.ar(PlayBuf.ar(1, sampbuf, rate*BufRateScale.kr(sampbuf), 1, startPos * BufSamples.kr(sampbuf),1) * EnvGen.kr(Env([0, 1, 0], [size, size], \sine), doneAction: 2), 0,amp))
}).add;
)
x = Synth(\grain,[\sampbuf, g, \startPos, 1.0.rand, \size, 0.5]);
(
Pdef(\granCloud,
	Pbind(\instrument,\grain,
		\sampbuf, g,
		\rate,Pwhite(0.5,2.0),
		\startPos,Pn(Pseries(0,40.reciprocal,40)),
		\size,Pbrown(0.01,1,0.05),
		\dur,Pstutter(10,Pseq(((1..20)*0.01).mirror2,inf))
));
)
Pdef(\granCloud).play
Pdef(\granCloud).stop

------

// Jess's Buffer

SynthDef("playbuf", { arg
	buffer,
	rate=1,
	trigger=1,
	startPos=0,
	loop=1,
	envlen =1,
	pan = 0,
	amp = 1,
	lpf = 6600;
	Out.ar(0, HPF.ar(LPF.ar(Pan2.ar(PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * rate, trigger, BufFrames.ir(buffer) * startPos, loop), 0.0, amp * (EnvGen.ar(Env([0, 1, 0], [0.5, 0.5]), 1, 1, 0, envlen, 2))), lpf, 1), 0050, 1))
}).store;


b = Buffer.read(s,"/Users/jesstambellini/Desktop/sounds/fbsdf.wav", nil, nil, nil, 1);
