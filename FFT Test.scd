

fx=Ppar([
Pmono(\reverb,
	\amp, 1),
Pmono(\delay,
	\amp, 1),
]).play;

(
Ndef(\magAbove,{arg freq=80,threshold=1,amp=0.5;
var in, chain, out;
	in= WhiteNoise.ar(amp);
	chain= FFT(LocalBuf(2048,1),in);
	chain= PV_MagAbove(chain,threshold);
	IFFT(chain).dup;
});
)
Ndef(\magAbove).gui;


(
s.options.memSize = 8192*4;
s = Server.local.waitForBoot({s.scope(2)});
);

(
(
    Synth(\reverb);
	Synth(\delay);
	Synth(\pdelay);
	Synth(\reverbsc)
);

Pbind(\instrument,\simpleSamplerStereo, //clicks
	\amp, 0.35,
	\rate, Pwhite(1,400),
	\buf, Pxrand([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,22,23],inf),
	\pan, Pwhite(-1,1),
	\vol1, 1,
	\vol2, Pwhite(0,1),
	\voldecay, Pseq([Pn(0.05,128),Pn(0.3,128)],inf),
	\dur, Pseq([Pseq([1,Rest(2),1,Rest(2),1,Rest(1),1,1,1,Rest(3),1,Rest(1)],3),Pseq([1,1,Rest(1),1,0.5,Rest(0.5),0.5,Rest(0.5),0.5,Rest(0.5),0.5,Rest(0.5),1,1,1,Rest(3),1,Rest(1)],1)],inf),
	\trem, 0.2,
	\effAmp4, Pxrand([0,0,0,0,0,0,0,0,0,0.1],inf)).play(TempoClock(170*4/60));

Pbind(\instrument,\kick,
	\amp, 1.5,
	\freq2, 50,
	\voldecay, 0.3,
	\dur, Pseq([1,Rest(3)],inf)).play(TempoClock(170*4/60));

Pbind(\instrument,\simpleSamplerStereo, //break
	\amp, 1,
	\rate, Pwhite(0.5,2),
	\buf, Pseq([11,Rest(1),11,Rest(1),29,Rest(1),27,14,13,12,22,23,29,Rest(1),25,25],inf),
	\pan, Pwhite(-1,1),
	\vol1, 1,
	\vol2, 0,
	\voldecay, 0.05,
	\dur, Pseq([1,Rest(1),1,Rest(1),1,Rest(1),1,1,1,1,1,1,1,Rest(1),1,1],inf),
	\trem, 0.2,
	\effAmp4, Pxrand([0,0,0,0,0,0,0,0,0,0.1],inf)).play(TempoClock(170*4/60));

Pbind(\instrument,\kick, //basshit
	\amp, 1,
	\freq1, Pseq([200,100,Rest(1),250,200,Rest(1),210,Rest(3),210,100],inf),
	\freq2, Pseq([200,100,Rest(1),250,200,Rest(1),210,Rest(3),210,100],inf),
	\voldecay, 0.1,
	\dur, Pseq([1,1,Rest(1),1,1,Rest(1),1,Rest(3),1,1],inf)).play(TempoClock(170*4/60));

Pbind(\instrument,\acidSaw, //higher
	\amp, 1.5,
	\vol1, Pseq([1,1,Rest(1),1,1,Rest(1),0,Rest(3),1,1],inf),
	\vol2, Pseq([0,0,Rest(1),0,0,Rest(1),1,Rest(3),0,Pwhite(0,1)],inf),
	\voldecay, Pwhite(0.05,0.3),
	\freq1, Pseq([400,200,Rest(1),500,400,Rest(1),420,Rest(3),420,200],inf),
	\freq2, Pseq([400,200,Rest(1),500,400,Rest(1),420,Rest(3),420,200],inf),
	\fltr1, Pwhite(300,7000),
	\fltr2, Pwhite(10,1000),
	\multi, Prand([1,1.5,2,3,0.5],inf),
	\pan, Pwhite(-1,1),
	\q, 3,
	\fltrdecay, Pwhite(1,5),
	\effAmp1, 0.5,
	\fltrdecay, Pseq([Pn(0.01,128),Pn(0.05,128)],inf),
	\dur, Pseq([1,1,Rest(1),1,1,Rest(1),1,Rest(3),1,1],inf)).play(TempoClock(170*4/60));

Pbind(\instrument,\acidSaw, //lower
	\amp, 1.5,
	\vol1, Pseq([1,1,Rest(1),1,1,Rest(1),0,Rest(3),1,1],inf),
	\vol2, Pseq([0,0,Rest(1),0,0,Rest(1),1,Rest(3),0,0],inf),
	\voldecay, 0.2,
	\freq1, Pseq([400,200,Rest(1),500,400,Rest(1),420,Rest(3),420,200],inf),
	\freq2, Pseq([400,200,Rest(1),500,400,Rest(1),420,Rest(3),420,200],inf),
	\fltr1, Pwhite(3000,7000),
	\fltr2, Pwhite(25,100),
	\multi, 0.25,
	\q, 3,
	\fltrdecay, 0.05,
	\fltrenvamt, 1,
	\dur, Pseq([1,1,Rest(1),1,1,Rest(1),1,Rest(3),1,1],inf)).play(TempoClock(170*4/60));

Pbind(\instrument,\simpleSampler, //vox
	\amp, 0.5,
	\buf, Prand([1,2,3],inf),
	\rate, Prand([1,2],inf),
	\voldecay, Pwhite(0.02,0.08),
	\effAmp4, Prand([0,0,0,0,0,0,0,0.2],inf),
	\dur, Pseq([1,1,Rest(1),1,1,Rest(1),1,Rest(3),1,1],inf)).play(TempoClock(170*4/60));

Pbind(\instrument,\simpleSamplerStereo, //snare
	\amp, 0.5,
	\buf, 30,
	\rate, 1,
	\voldecay, 0.1,
	\dur, Pseq([Rest(4),1,Rest(11)],inf)).play(TempoClock(170*4/60));

Pbind(\instrument,\simpleSamplerStereo, //hh
	\amp, 0.5,
	\buf, 21,
	\rate, Pseq([1,Rest(3),1,Rest(3),1,Rest(3),1,Rest(3),1,Rest(3),1,Rest(3),1,Rest(3),1,1,15,Rest(1)],inf),
	\voldecay, Pseq([0.1,Rest(3),0.1,Rest(3),0.1,Rest(3),0.1,Rest(3),0.1,Rest(3),0.1,Rest(3),0.1,Rest(3),0.1,0.1,0.2,Rest(1)],inf),
	\dur, Pseq([1,Rest(3),1,Rest(3),1,Rest(3),1,Rest(3),1,Rest(3),1,Rest(3),1,Rest(3),1,1,1,Rest(1)],inf)).play(TempoClock(170*4/60));
)


Pbind(\instrument,\simpleSampler, //vox
	\amp, 1,
	\buf, Prand([2],inf),
	\rate, Pseq([1.5,0.75,Rest(1),2,0.75,Rest(1),0.8,Rest(3),2,1.5],inf),
	\voldecay, 0.1,
	\effAmp4, Prand([0,0,0,0,0,0,0,0.2],inf),
	\dur, Pseq([1,1,Rest(1),1,1,Rest(1),1,Rest(3),1,1],inf)).play(TempoClock(170*4/60));

//_______________________________________________Extra Shuffle Note
Pbind(\instrument,\acidSaw, //higher
	\amp, 1.5,
	\freq1, Pseq([400,Rest(0.3),400,400,Rest(0.3),400,420,Rest(0.6),400,Rest(0.6),420,Rest(0.6),400,Rest(0.6),375,Rest(0.6),400,Rest(0.6)],inf),
	\freq2, Pseq([400,Rest(0.3),400,400,Rest(0.3),400,420,Rest(0.6),400,Rest(0.6),420,Rest(0.6),400,Rest(0.6),375,Rest(0.6),400,Rest(0.6)],inf),
	\fltr1, Pseq([4000,Rest(0.3),4000,4000,Rest(0.3),4000,4200,Rest(0.6),4000,Rest(0.6),4200,Rest(0.6),4000,Rest(0.6),3750,Rest(0.6),4000,Rest(0.6)],inf),
	\fltr2, Pseq([4000,Rest(0.3),4000,4000,Rest(0.3),4000,4200,Rest(0.6),4000,Rest(0.6),4200,Rest(0.6),4000,Rest(0.6),3750,Rest(0.6),4000,Rest(0.6)],inf),
	\multi, 1,
	\voldecay, 0.2,
	\dur, Pseq([0.3,Rest(0.3),0.3,0.3,Rest(0.3),0.3,0.3,Rest(0.6),0.3,Rest(0.6),0.3,Rest(0.6),0.3,Rest(0.6),0.3,Rest(0.6),0.3,Rest(0.6)],inf)).play(TempoClock(125*2/60));