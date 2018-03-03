
( // effects SynthDefs+src SynthDef
// each effect Synthdef has an 'inBus' argument, like its effect-send channel, read in by 'In.ar(inBus)'
SynthDef(\rvb,{|inBus=16,size=1,damp=0.2,amp=1,ppan=0|
	Out.ar(([0,1]), Pan2.ar((FreeVerb.ar(In.ar(inBus,1),1,size,damp,amp)), ppan));
}).store;

SynthDef(\rngFlt,{|inBus=16,freq=440,decay=0.05,amp=0.25,ppan=0|
	Out.ar(([0,1]),Pan2.ar((Ringz.ar(In.ar(inBus,1),freq,decay,amp)), ppan));
}).store;

SynthDef(\combDelay,{|inBus=16,delay=0.5,decay=4,amp=1,ppan=0|
	Out.ar(([0,1]),Pan2.ar((CombN.ar(In.ar(inBus,1),1.0,delay,decay,amp)), ppan));
}).store;

SynthDef(\pshift,{|inBus=16,wsize=0.2,pRtio=0.5,pDsp=0,tDsp=0.01,amp=1|
	Out.ar(0,PitchShift.ar(In.ar(inBus,1),wsize,pRtio,pDsp,tDsp,amp));
}).store;

SynthDef(\rLPF,{|inBus=16,freq=440,res=0.5,amp=0.25|
	Out.ar(0,RLPF.ar(In.ar(inBus,1),freq,res,amp));
}).store;

SynthDef(\rHPF,{|inBus=16,freq=440,res=0.5,amp=0.25|
	Out.ar(0,RHPF.ar(In.ar(inBus,1),freq,res,amp));
}).store;

SynthDef(\resB,{|inBus=16,freq=440,amp=0.25|
	Out.ar(0,Resonz.ar(In.ar(inBus,1),freq,1,amp));
}).store;

SynthDef(\formL,{|inBus=16,freq=440,decay=0.3,amp=0.25|
	Out.ar(0,Formlet.ar(In.ar(inBus,1),freq,1,decay,amp));
}).store;
)



(  // this is an intialization block that will need to be compiled again to change effects
~effGroup = Group.tail(1);  // create a Group for effects
// the parenthesis enclosure below creates an Event, a kind of Dictionary that provides a list of  pairs of keys(symbols) associated with things, in this case audio Buses
~effBus = (rvb: Bus.audio(s,1), flt: Bus.audio(s,1), delay: Bus.audio(s,1), pshift:Bus.audio(s,1), rLPF: Bus.audio(s,1), rHPF: Bus.audio(s,1), resB: Bus.audio(s,1), formL: Bus.audio(s,1)  );
// the next Event stores references to the effect Synths
if(~effects.notNil,{~effects.keysValuesDo {|k,v| v.free }; });
~effects = (
	rvb: Synth(\rvb,[\inBus,~effBus[\rvb]],~effGroup),
	flt: Synth(\rngFlt,[\inBus,~effBus[\flt]],~effGroup),
	delay: Synth(\combDelay,[\inBus,~effBus[\delay]],~effGroup),
	pshift: Synth(\pshift,[\inBus,~effBus[\pshift]],~effGroup),
	rLPF: Synth(\rLPF,[\inBus,~effBus[\rLPF]],~effGroup),
	rHPF: Synth(\rHPF,[\inBus,~effBus[\rHPF]],~effGroup),
	resB: Synth(\resB,[\inBus,~effBus[\resB]],~effGroup),
	formL: Synth(\formL,[\inBus,~effBus[\formL]],~effGroup),
);
)

(
~effGroup = Group.tail(1);
~effBus = (rvb: Bus.audio(s,1), flt: Bus.audio(s,1), delay: Bus.audio(s,1), pshift:Bus.audio(s,1), rLPF: Bus.audio(s,1), rHPF: Bus.audio(s,1), resB: Bus.audio(s,1), formL: Bus.audio(s,1)   );
)


(
SynthDef(\turq,{|effBus=16, eff1Amp=0, eff2Amp=0, eff3Amp=0, amp=0.1, freq=700, length=2, ppan=0|
	var modulator, carrier, carrier2, rev, pan;
	modulator = SinOsc.ar(0.2, 0, 5);
	carrier = LFSaw.ar(modulator.abs);
	carrier2 = LFTri.ar(freq, 0, carrier)*SinOsc.ar(1000);
	rev = FreeVerb.ar(carrier2, 0.50, 10, 0.5)*EnvGen.kr(Env.new([0.0, 0.5, 0.5, 0.0],length*[0.1, 3.0, 1.0]), doneAction: 2);
	pan = Pan2.ar(rev, ppan);
	Out.ar(effBus,[pan*eff1Amp,pan*eff2Amp,pan*eff3Amp]);
	Out.ar(0,pan*amp);
}).store;



SynthDef(\orange,{|effBus=16, eff1Amp=0, eff2Amp=0, eff3Amp=0, amp=0.4, freq=300, dur=1.0, ind=5.0, sinin=0.2, ppan= 0|
	var index, sig, pan;
	index = SinOsc.ar(sinin, 0, 10)*ind;
	sig = LFPulse.ar(LFSaw.ar(freq, 0, SinOsc.ar(50), freq*index, 440), 10, 0.5, SinOsc.ar(50))*EnvGen.kr(Env.new([0.0, 0.5, 0.5, 0.0],[0.1, 3.0, 0.2]), doneAction: 2);
	pan = Pan2.ar(sig, ppan);
	Out.ar(effBus,[pan*eff1Amp,pan*eff2Amp,pan*eff3Amp]);
	Out.ar(0, pan*amp)
}).add;



SynthDef(\black,{|amp=0.1, amp2=0.1, effBus=16, eff1Amp=0, eff2Amp=0, eff3Amp=0|
	var modulator, carrier, filt, noise, ring, pan, modulator2, carrier2, filt2, noise2, ring2, pan2;
	modulator = SinOsc.ar(0.02, 0, 5);
	carrier = LFSaw.ar(modulator.abs);
	noise = PinkNoise.ar(carrier);
	filt = LPF.ar(noise, modulator.abs*300.0, 0.2);
	ring = filt+Mix(Ringz.ar(filt, [Line.kr(50, 2000, 120, 1, 0, 0), Line.kr(2000, 50, 120, 1, 0, 0), 920, 300, 456], 1, 0.1));
	pan = Pan2.ar(ring, modulator*0.2);
	Out.ar(effBus,[pan*eff1Amp,pan*eff2Amp,pan*eff3Amp]);
	Out.ar(0,pan*amp);
	modulator2 = SinOsc.ar(0.02, 0.05, 5);
	carrier2 = LFSaw.ar(modulator2.abs);
	noise2 = PinkNoise.ar(carrier2);
	filt2 = LPF.ar(noise2, modulator2.abs*300.0, 0.2);
	ring2 = filt2+Mix(Ringz.ar(filt2, [Line.kr(50, 2000, 120, 1, 0, 0), Line.kr(2000, 50, 120, 1, 0, 0), 950, 290, 459], 1, 0.1));
	pan2 = Pan2.ar(ring2, modulator2* -0.2);
	Out.ar(effBus,[pan2*eff1Amp,pan*eff2Amp,pan*eff3Amp]);
	Out.ar(0,pan2*amp2)
}).add;

SynthDef(\white,{|effBus=16, eff1Amp=0, eff2Amp=0, eff3Amp=0, amp=0.4, freq=1.0, length=1.0|
	var modulator, carrier, filt, pan;
	modulator = Mix(SinOsc.ar(freq*[200, 500, 900, 700], 0, 1).abs);
	carrier = Mix(SinOsc.ar([200*modulator, 300*modulator, 500*modulator]), 0, 1);
	filt = RHPF.ar(freq*carrier*Crackle.ar(2)*EnvGen.kr(Env.new(amp*[0.0, 0.5, 0.5, 0.0],length*[3.0, 4.0, 3.0]), doneAction:2));
	pan = Pan2.ar(filt, ClipNoise.ar(1.0)*0.5*SinOsc.ar(10, 0, 5).poll(4,"dust"));
	Out.ar(effBus,[pan*eff1Amp,pan*eff2Amp,pan*eff3Amp]);
	Out.ar(0,pan*amp)
}).add;

SynthDef(\yellow,{|effBus=16, eff1Amp=0, eff2Amp=0, eff3Amp=0, amp=0.4, freq=300, dur=1.0, ind=5.0, sinin=0.2, ppan= 0|
	var index, sig, pan, filt, rev;
	index = LFSaw.ar(sinin, 0, 10)*ind;
	sig = SinOsc.ar(Impulse.ar(freq, 0, Impulse.ar(500), freq*index, 440), 10, 0.5, SinOsc.ar(50));
	filt = HPF.ar(sig, 500);
	rev = FreeVerb.ar(filt, 0.75, 10, 0.5)*EnvGen.kr(Env.new([0.0, 0.5, 0.5, 0.0],[0.1, 2.0, 3.0]), doneAction: 2);
	pan = Pan2.ar(rev, ppan);
	Out.ar(effBus,[pan*eff1Amp,pan*eff2Amp,pan*eff3Amp]);
	Out.ar(0, pan*amp)
}).add;

SynthDef(\clear,{|effBus=16, eff1Amp=0, eff2Amp=0, eff3Amp=0, amp=0.3, freq=1200, freq2=1000 filtfreq=1100, ppan=0, length=1.0|
	var sig, filt, pan;
	sig = SinOsc.ar(freq*LFTri.ar(freq2), 0, EnvGen.kr(Env.new([0.0, 0.6, 0.1, 0.9, 0.3, 0.5, 0.2, 0.7, 0.0],length*[0.2, 0.9, 0.3, 0.8, 0.9, 0.2, 0.8, 0.6, 3.0]), doneAction: 2));
	filt = RHPF.ar(sig, filtfreq);
	pan = Pan2.ar(filt, ppan);
	Out.ar(effBus,[pan*eff1Amp,pan*eff2Amp,pan*eff3Amp]);
	Out.ar(0, pan*amp)
}).add;


SynthDef(\hit,{|effBus=16, eff1Amp=0, eff2Amp=0, eff3Amp=0, amp=0.6, freq=1.0, freq2=100.0, ffreq=600 ppan=0, dur=10.0|
	var sig, filt, rev, pan;
	sig = Mix(SinOsc.ar(freq*[40, 70, 100, 150, 300]))*(LFPulse.ar(freq2));
	filt = RLPF.ar(sig, ffreq);
	rev = FreeVerb.ar(filt, 0.8, 10, 0.2)*EnvGen.kr(Env.perc(0.05, 5), doneAction: 2);
	pan = Pan2.ar(rev, ppan);
	Out.ar(effBus,[pan*eff1Amp,pan*eff2Amp,pan*eff3Amp]);
	Out.ar(0, pan*amp)
}).add;

(
~samps = ["Sounds/Saa.wav"];
~buffers = ~samps.collect {|file| Buffer.read(s,file) } ;
);

SynthDef(\grain,{ arg effBus=16, eff1Amp=0, eff2Amp=0, eff3Amp=0, sampbuf=0,rate=1.0,startPos=0, size=0.1, ppan=0, ffreq=1000;
	var bufz, filt, pan, del, rev;
	bufz = PlayBuf.ar(1,sampbuf,
				rate*BufRateScale.kr(sampbuf),1,
				startPos*BufSamples.kr(sampbuf),1)
			*EnvGen.kr(
				Env([0,0.2,0],[size,size],\sine),
				doneAction: 2);
	filt = Ringz.ar(bufz, ffreq, 1, 0.4);
	del = DelayN.ar(filt, 0.2, 0.5);
	rev = FreeVerb.ar(del, 0.5, 10, 3);
	pan = Pan2.ar(rev, ppan);
	Out.ar(effBus,[pan*eff1Amp,pan*eff2Amp,pan*eff3Amp]);
	Out.ar(0, pan)
}).add;


Pdef(\effturq,
	Ppar([
		Pbind(\instrument, \turq,
			\group,1,
			\amp, 0.2,
			\effBus, ~effBus[\rvb].index,  // point to the first of four Busses
			\eff1Amp,Prand([0, 0.05, 0.1]*0.1,inf),
			\freq,Prand([600, 700, 800, 900, 1000, 1200, 1500, 2000],inf),
			\length,([1, 1.5, 2, 2.5, 3]),
			\dur,Prand([2, 3, 7, 10, 5, 8, 13],inf),
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
			\eff2Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
			\eff3Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
		),
		Pmono(\combDelay,
			\group,~effGroup,
			\inBus, ~effBus[\delay].index, // point to the effect 'delay'
			\amp, 0.3,
			\time, 1,
			\decay, 4,
			\delay,Prand([0.5,0.25,0.125,0.375],inf),
			\decay,4,
			\dur,2
		),
		Pmono(\rngFlt,
			\group,~effGroup,
			\inBus, ~effBus[\flt].index, // point to the effect 'delay'
			\freq,Pwhite(880,1760),
			\decay,0.02,
			\amp,0.1,
			\dur,4
		)
]));



Pdef(\efforange,
	Ppar([
		Pbind(\instrument, \orange,
			\group,1,
			\amp, 0.4,
			\effBus, ~effBus[\rvb].index,  // point to the first of four Busses
			\eff1Amp,Prand([0, 0.05, 0.1],inf),
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800],inf),
			\amp,0.4,
			\dur,Prand([10, 5, 15, 8, 13],inf),
			\sinin,Prand([0.1, 0.2, 0.3, 0.4, 0.5],inf),
			\ind,Prand([1, 2, 3, 4, 5],inf),
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
			\eff2Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
			\eff3Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
		),
		Pmono(\combDelay,
			\group,~effGroup,
			\inBus, ~effBus[\delay].index, // point to the effect 'delay'
			\amp, 0.3,
			\time, 1,
			\decay, 4,
			\delay,Prand([0.5,0.25,0.125,0.375],inf),
			\decay,4,
			\dur,2,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
		Pmono(\pshift,
			\group,~effGroup,
			\inBus, ~effBus[\pshift].index,
			\pRatio,Prand([1, 2, 3, 4, 5], inf),
			\wsize,Prand([0.1, 0.2, 0.3, 0.4, 0.5]),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		)
]));



Pdef(\effblack,
	Ppar([
		Pbind(\instrument, \black,
			\group,1,
			\effBus, ~effBus[\rvb].index,
			\eff1Amp,Prand([0, 0.05, 0.1],inf),
			\eff2Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
			\eff3Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
		),
		Pmono(\resB,
			\group,~effGroup,
			\inBus, ~effBus[\resB].index,
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
		Pmono(\formL,
			\group,~effGroup,
			\inBus, ~effBus[\formL].index,
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
]));



Pdef(\effgrain,
	Ppar([
		Pbind(\instrument, \grain,
			\group,1,
			\amp, 0.2,
			\effBus, ~effBus[\rvb].index,
			\eff1Amp,Prand([0, 0.05, 0.1],inf),
			\sampbuf,~buffers[2],
			\rate,Pwhite(0.5,2.0),
			\startPos,Pn(Pseries(0,40.reciprocal,40)),
			\size,Pbrown(0.01,1,0.05),
			\dur,Pstutter(10,Pseq(((1..20)*0.03).mirror2,inf)),
			\ffreq,Prand(2*[1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000],inf),
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
			\eff2Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
			\eff3Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
		),
		Pmono(\combDelay,
			\group,~effGroup,
			\inBus, ~effBus[\delay].index,
			\amp, 0.3,
			\time, 1,
			\decay, 4,
			\delay,Prand([0.5,0.25,0.125,0.375],inf),
			\decay,4,
			\dur,2,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
		Pmono(\formL,
			\group,~effGroup,
			\inBus, ~effBus[\formL].index,
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		)
]));




Pdef(\effclear,
	Ppar([
		Pbind(\instrument, \clear,
			\group,1,
			\amp, 0.2,
			\effBus, ~effBus[\rvb].index,
			\eff1Amp,Prand([0, 0.05, 0.1],inf),
			\freq,Prand(2*[1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000],inf),
			\freq2,Prand(2.5*[1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000],inf),
			\filtfreq,Prand(2.8*[1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000],inf),
			\amp,Prand([0.1, 0.2, 0.3, 0.4, 0.5],inf),
			\dur,Prand([10, 5, 1, 4, 0.5, 2, 7, 8, 12],inf),
			\sinind,Prand([0.1, 0.2, 0.3, 0.4, 0.5],inf),
			\ind,Prand([1, 2, 3, 4, 5],inf),
			\length,Prand([1, 2, 3, 4, 5],inf),
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
			\eff2Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
			\eff3Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
		),

		Pmono(\rLPF,
			\group,~effGroup,
			\inBus, ~effBus[\rLPF].index,
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
		Pmono(\rHPF,
			\group,~effGroup,
			\inBus, ~effBus[\rHPF].index,
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		)
]));



Pdef(\effyellow,
	Ppar([
		Pbind(\instrument, \yellow,
			\group,1,
			\amp, 0.2,
			\effBus, ~effBus[\rvb].index,
			\eff1Amp,Prand([0, 0.05, 0.1],inf),
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800],inf),
			\dur,Prand([10, 5, 15, 8, 13],inf),
			\sinin,Prand(10*[0.1, 0.2, 0.3, 0.4, 0.5],inf),
			\ind,Prand([1, 2, 3, 4, 5],inf),
			\dur,Prand([5, 10, 12, 7, 13, 15],inf),
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
			\eff2Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
			\eff3Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
		),
		Pmono(\rngFlt,
			\group,~effGroup,
			\inBus, ~effBus[\flt].index,
			\freq,Pwhite(880,1760),
			\decay,0.02,
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
		Pmono(\formL,
			\group,~effGroup,
			\inBus, ~effBus[\formL].index,
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
]));


Pdef(\effwhite,
	Ppar([
		Pbind(\instrument, \white,
			\group,1,
			\amp, 0.2,
			\effBus, ~effBus[\rvb].index,
			\eff1Amp,Prand([0, 0.05, 0.1],inf),
			\freq,Prand([1, 2, 3, 4, 5, 6, 7],inf),
			\dur,Prand([10, 9, 15, 7, 13],inf),
			\length,Prand([1, 1.5, 2, 2.5],inf),
			\eff2Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
			\eff3Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
		),
		Pmono(\rngFlt,
			\group,~effGroup,
			\inBus, ~effBus[\flt].index,
			\freq,Pwhite(880,1760),
			\decay,0.02,
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
		Pmono(\resB,
			\group,~effGroup,
			\inBus, ~effBus[\resB].index,
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		)
]));


Pdef(\effhit,
	Ppar([
		Pbind(\instrument, \hit,
			\group,1,
			\amp, 0.2,
			\effBus, ~effBus[\rvb].index,
			\eff1Amp,Prand([0, 0.05, 0.1],inf),
			\freq,Prand([0.5, 0.75, 1, 1.5, 2, 2.5],inf),
			\freq2,Prand(100*[0.5, 0.75, 1, 1.5, 2, 2.5],inf),
			\ffreq,Prand(300*[0.5, 0.75, 1, 1.5, 2, 2.5],inf),
			\dur,Prand([5, 10, 12, 7, 13, 15],inf),
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
			\eff2Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
			\eff3Amp, Pxrand([0.25,0.125,1,0.75,0.5,0.875]*0.1,inf),
		),
		Pmono(\resB,
			\group,~effGroup,
			\inBus, ~effBus[\resB].index,
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
		Pmono(\formL,
			\group,~effGroup,
			\inBus, ~effBus[\formL].index,
			\freq,Prand([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf),
			\amp,0.1,
			\dur,4,
			\ppan,Prand([-1, -0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75, 1],inf),
		),
]));
)



Synth(\black).play;
Pdef(\efforange).play;
Pdef(\effturq).play;
Pdef(\effwhite).play;
Pdef(\effyellow).play;
Pdef(\effclear).play;
Pdef(\effgrain).play;
Pdef(\effhit).play;