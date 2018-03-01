(

//////////////////////////SYNTHS

SynthDef(\filtered,
	{arg freq = 100,fmult = 6,
		amount= 1,amp = 0.5,envlen = 0.071,effBus = 16,eff1Amp = 0,eff2Amp = 0,eff3Amp = 0,eff4Amp = 0,
		gate=1;
		var sound=HPF.ar(LPF.ar(Saw.ar((freq*fmult) +SinOsc.ar(1, 0, amount), (EnvGen.ar(Env([0, 1, 1, 0], [0.8, 0.5, 0.7]), gate, 1, 0, envlen, 2))), 16900), 50);
		Out.ar([0, 1], sound*amp);
		Out.ar(effBus, [sound*eff1Amp, sound*eff2Amp, sound*eff3Amp, sound*eff4Amp]);
}).store;

	SynthDef("playbuf1",   //plays the recording of the synth bus with the below Pbind and also sends some of its signal back into the effects
	{ arg
		buffer,
		rate=1,
		trigger=1,
		startPos=0,
		loop=1,
		envlen =1,
		pan = 0,
		amp = 1,
		lpf = 6600,
		effBus,
		eff1Amp = 0,eff2Amp = 0,eff3Amp = 0,eff4Amp = 0,
		fftBus,
		fft1Amp = 0,fft2Amp = 0,fft3Amp = 0,fft4Amp = 0;
		var sound =
		HPF.ar(LPF.ar(Pan2.ar(
				PlayBuf.ar(1,buffer, BufRateScale.kr(buffer)*rate,trigger,
					BufFrames.ir(buffer)*startPos, loop),0.0, amp*(EnvGen.ar(Env([0, 1, 0], [0.5, 0.5]), 1, 1, 0, envlen, 2))), lpf, 1), 0050, 1);      Out.ar(effBus, [sound*eff1Amp, sound*eff2Amp, sound*eff3Amp, sound*eff4Amp]);
		Out.ar(fftBus, [sound*fft1Amp, sound*fft2Amp, sound*fft3Amp, sound*fft4Amp]);
		Out.ar(0, sound*amp);
		}).store;

	SynthDef("playbuf2",   //plays the recording of the synth bus with the below Pbind and also sending siglad ONLY to effects has to be received by somthing to be heard
	{ arg
		buffer,
		rate=1,
		trigger=1,
		startPos=0,
		loop=1,
		envlen =1,
		pan = 0,
		amp = 1,
		lpf = 6600,
		effBus,
		eff1Amp = 0,eff2Amp = 0,eff3Amp = 0,eff4Amp = 0,
		fftBus,
		fft1Amp = 0,fft2Amp = 0,fft3Amp = 0,fft4Amp = 0;
		var sound =
		HPF.ar(LPF.ar(Pan2.ar(
				PlayBuf.ar(1,buffer, BufRateScale.kr(buffer)*rate,trigger,
					BufFrames.ir(buffer)*startPos, loop),0.0, amp*(EnvGen.ar(Env([0, 1, 0], [0.5, 0.5]), 1, 1, 0, envlen, 2))), lpf, 1), 0050, 1);      Out.ar(effBus, [sound*eff1Amp, sound*eff2Amp, sound*eff3Amp, sound*eff4Amp]);
		Out.ar(fftBus, [sound*fft1Amp, sound*fft2Amp, sound*fft3Amp, sound*fft4Amp]);
		}).store;

/////////////////////////FXXX

/*SynthDef(\dev,{arg
	inBus=16,
	delay=0.02,
	decay=1.5,
	amp=1;
	Out.ar([0], CombN.ar(In.ar(inBus,1),1.0,delay,decay).dup,amp)
}).store;
*/

SynthDef(\freeze, {arg      // cant get this to work with out being VERY LOUD
		inBus=16,
	amp= 1,
	fre;
    var in, chain;
    in = In.ar(inBus,1);
    chain = FFT(LocalBuf(2048), in);
    chain = PV_MagFreeze(chain, fre);
	    Out.ar([0], 0.1*IFFT(chain).dup);
}).store;

SynthDef(\reverb,{arg
	inBus=16,
	size=1,
	damp=0.2,
	eout,
	amp=1,
	ampALL = 1;
	Out.ar(0,ampALL*FreeVerb.ar(In.ar(inBus,1),1,SinOsc.kr(0.5, 0, 200, 200)*size,damp,amp).dup);
}).store;

SynthDef("mafs",
	{arg threshold= 2,
		amp=0.5,
		inBus,
		wipe = 0,
		width = 0.2;
	var chain;
		chain = FFT(LocalBuf(2048), In.ar(inBus), 0.01);
		chain = PV_BinScramble(chain, SinOsc.ar(0.2, 0, 0.5, 0.5), SinOsc.ar(0.35, 0, 0.5, 0.5), Dust.ar(0.2));
	IFFT(chain);
		Out.ar([0, 1], IFFT(chain))}).store;

SynthDef("randWipe", { arg amp = 1,
	inbus1 = ~fftBus[\fft2].index,
	inbus2 = ~effBus[\fft1].index;
    var inA, chainA, inB, chainB, chain;
	    inA = In.ar(inbus1);
    inB = In.ar(inbus2);
    chainA = FFT(LocalBuf(2048), inA);
    chainB = FFT(LocalBuf(2048), inB);
	    chain = PV_RandWipe(chainA, chainB, SinOsc.kr(0.353, 0, 0.5, 0.5), Dust.ar(0.5));
    Out.ar(0, amp*0.5 * IFFT(chain));}).store;


/////////////////////////ORDERING

~effGroup = Group.tail(1);
~effBus = (r1: Bus.audio(s,1), fre2: Bus.audio(s,1), ps3: Bus.audio(s,1));

~fftGroup = Group.tail(1);
~fftBus = (fft1: Bus.audio(s,1), fft2: Bus.audio(s,1), fft3: Bus.audio(s,1));

/////////////////////////Buffers

r = Buffer.alloc(s,s.sampleRate*15.0, 1);
k = Buffer.alloc(s,s.sampleRate*15.0,1);
b = Buffer.read(s, "/Users/jesstambellini/Desktop/ADVORCHT19.wav");

SynthDef(\recSoundIn, {RecordBuf.ar( FreeVerb.ar(In.ar(~effBus[\r1].index), 1, 1, 1), r, loop: 2)}).play;
SynthDef(\recSoundIn, {RecordBuf.ar( FreeVerb.ar(In.ar(~fftBus[\fft1].index), 1, 1, 1), k,loop: 2)}).play;

/////////////////////////Paterns

~a = Ppar([Pbindef(\1, \instrument,\filtered,
                \amp, 0.0,
                \group, 1,
			\envlen, 0.1,
	            \effBus, ~effBus[\r1].index,
	\freq, Pwhite(3, 23, inf),
                \eff1Amp, 1.1,
		        \eff2Amp, 0.6,
			\eff3Amp, 0.3,
			\dur, Pwhite(1.5, 13.28, inf),
                \legato,0.25),
Pmono(\reverb,
			 \group,~effGroup,
                \inBus, ~effBus[\r1].index,
	\amp, Pwhite(0, 1, inf),
	\size, 0.01,
	\ampALL, 0.1)], inf);


~j = Ppar([Pbind(\instrument, \playbuf2,
	\amp, Pseq([0.97], inf),
	\buffer, b,
\fftBus, ~fftBus[\fft1].index,
	     \fft2Amp, 0,
	 \fft1Amp, 1.0,                        //thow much to send plaubuf1
			\fft3Amp, 0.1,
		\lpf, 2000,
	\startPos, Pseq([Pseq([960.rand*44100.poll, 960.rand*44100], 1)], inf),
	\dur, Pwhite(0.1, 07.7, inf),
	\rate, Pwhite(0.01, 3, inf),
	\envlen, Pseq([Pseq(([2.2.rand, 1.131.rand, 1.26.rand, 1.17.rand]/0.4), 0.6)], inf)),
Pmono(\mafs,
			 \group,~fftGroup,
                \inBus, ~fftBus[\fft1].index,
	\amp, 1)], inf);

~w = 	Pbind(
	\amp, 0.07,
	\buffer, Pseq([r, k], inf),
	     \effBus, ~effBus[\r1].index,  //these are choosing where to send plaubuf1
	\fftBus, ~fftBus[\fft1].index,
	     \fft2Amp, 0,
	 \fft1Amp, 0.35,                        //thow much to send plaubuf1
			\fft3Amp, 0.1,
	     \eff2Amp, 0,
	 \eff1Amp, 0.80,
			\eff3Amp, 0.1,
		\lpf, 4000.rand,
	\instrument, \playbuf1,
	\startPos, Pseq([Pseq([1.rand*44100, 7.rand*44100, 15.rand*44100, 31], 1)], inf),
	\dur, Pwhite(0.2, 3.5, 2),
	\rate, Pwhite(0.2, 453.5.rand, 14),
	//\rate, Pseq([10.4.rand, 100.rand, 0.3.rand, 400.rand], 1),
	\envlen, Pwhite(0.2, 1.5, 2));

)



SynthDef("help-randWipe", { arg out=0;
    var inA, chainA, inB, chainB, chain;
	    inA = In.ar(~fftBus[\fft1].index),
    inB = In.ar(~effBus[\r1].index, 1);
    chainA = FFT(LocalBuf(2048), inA);
    chainB = FFT(LocalBuf(2048), inB);
	    chain = PV_RandWipe(chainA, chainB, SinOsc.kr(0.5, 0, 0.5, 0.5), Dust.ar(0.05));
    Out.ar(0, 0.5 * IFFT(chain).dup);
}).play(s);


/////////  to play it i improvis with the controls below

v = ~a.play;
v.stop;
w = ~j.play;
w.stop;


115.do({{~w.play}.defer(38.rand)});




(                                                             //activiating this more than twice is dangerous
SynthDef("magMul", { arg out=0;
    var inA, chainA, inB, chainB, chain;
	    inA = In.ar(~effBus[\r1].index, 1);
    inB = In.ar(~effBus[\ps3].index, 1);
    chainA = FFT(LocalBuf(2048), inA);
    chainB = FFT(LocalBuf(2048), inB);
	chain = PV_MagDiv(chainA, chainB, SinOsc.ar(0.1, 0, 0.5, 0.5));
	Out.ar(0, 0.009 * IFFT(chain).dup);
}).play;
)




