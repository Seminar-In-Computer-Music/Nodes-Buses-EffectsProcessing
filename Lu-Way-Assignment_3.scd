/*Assigment 3*/

/********************/

/*EFFECT GROUPS AND BUSSES*/

(
~effGroup1 = Group.tail(1);
~effBus1 = (gVerb: Bus.audio(s,1), 	Ringz: Bus.audio(s,1), pshift: Bus.audio(s,1), Pluck:Bus.audio(s,1), limiter:Bus.audio(s,1) );
)

(
~effGroup2 = Group.tail(1);
~effBus2 = (delay1: Bus.audio(s,1), MoogFF: Bus.audio(s,1), freeVerb: Bus.audio(s,1), limiter:Bus.audio(s,1)  );
)

(

~effGroup3 = Group.tail(1);
~effBus3 = (Ringz: Bus.audio(s,1), Convolution: Bus.audio(s,1), Vibrato: Bus.audio(s,1), compander:Bus.audio(s,1)  );
);

)



/**Initialization of synths*/



a=  Synth.before(~effGroup1,\realParallelFmP,[\effBus,~effBus1[\gVerb],\eff1Amp,0.2]);
b= Synth.before(~effGroup2,\aSynthP,[\effBus,~effBus2[\Ringz],\eff1Amp,0.2]);
c= Synth.before(~effGroup3,\realMulticarrierFM,[\effBus,~effBus3[\Ringz],\eff1Amp,0.2]);




a.free;
b.free;
c.free;

/**PATTERNS AND PBINDS*/

(x= Ppar([
	Pbind(\instrument,\realParallelFmP,
		\group,1,
		\amp,1,
		\effBus,~effBus1[\gVerb].index,
		\eff1Amp,Pseq([1,0.75,0.5,0.25,0],8),
		\freq, 189.93,
		\modFreq2, 78.82,
		\eff2Amp,Pseq([1,0.75,0.5,0.25,0],8),
		\eff3Amp,Pseq([0,0.25,0.5,0.75,1],8),
		\eff4Amp,Pseq([0,0.25,0.5,0.75,1],8)
	),//pbind
	Pmono(\gVerb,
		\group,~effGroup1,
		\inBus, ~effBus1[\gVerb].index,
		\taillevel,10,
		\damping,0.2,
		\mul,1,
		\dur,8),
	Pmono(\Ringz,
		\group,~effGroup1,
		\inBus, ~effBus1[\Ringz].index,
		\freq, 100,
		\amp,1,
		\dur,1),
	Pmono(\pshift,
		\group,~effGroup1,
		\inBus, ~effBus1[\pshift].index,
		\wsize,Pseq([0.2, 0.5, 0.6],8),
		\pRtio,0.05,
		\pDsp,0,
		\tDsp,0.01,
		\amp,1,
		\dur,4),
	Pmono(\Pluck,
		\group,~effGroup1,
		\inBus, ~effBus1[\Pluck].index,
		\delayTime, 0.6,
		\amp,1,
		\dur,1),
		Pmono(\limiter,
		\group,~effGroup1,
		\inBus, ~effBus1[\limiter].index,
		\level,1,
		\dur,1)

])//Pparx

)

(y= Ppar([
	Pbind(\instrument,\aSynthP,
		\group,1,
		\amp,1,
		\effBus,~effBus2[\delay1].index,
		\eff1Amp,Pseq([1,0.75,0.5,0.25,0],8),
		\freq, 189.93,
		\modFreq2, 78.82,
		\eff2Amp,Pseq([1,0.75,0.5,0.25,0],8),
		\eff3Amp,Pseq([0,0.25,0.5,0.75,1],8),
		\eff4Amp,Pseq([0,0.25,0.5,0.75,1],8)
	),//pbind
	Pmono(\delay1,
		\group,~effGroup2,
		\inBus, ~effBus2[\delay1].index,
		\mul, 1,
		\dur,8),
	Pmono(\MoogFF,
		\group,~effGroup2,
		\inBus, ~effBus2[\MoogFF].index,
		\freq, 441,
		\gain, 0.5,
		\amp,1,
		\dur,1),
	Pmono(\freeVerb,
		\group,~effGroup2,
		\inBus, ~effBus2[\freeVerb].index,
		\mix, 0.5,
		\room, 0.85,
		\damp, 0.5,
		\mul,1,
		\dur,4),
	Pmono(\limiter,
		\group,~effGroup2,
		\inBus, ~effBus2[\limiter].index,
		\level,1,
		\dur,1)

])//Ppary
)




(z= Ppar([
	Pbind(\instrument,\realMulticarrierFM,
		\group,1,
		\amp,1,
		\effBus,~effBus3[\Ringz].index,
		\eff1Amp,Pseq([1,0.75,0.5,0.25,0],8),
		\freq, 189.93,
		\modFreq2, 78.82,
		\eff2Amp,Pseq([1,0.75,0.5,0.25,0],8),
		\eff3Amp,Pseq([0,0.25,0.5,0.75,1],8),
		\eff4Amp,Pseq([0,0.25,0.5,0.75,1],8)
	),//pbind
	Pmono(\Ringz,
		\group,~effGroup3,
		\inBus, ~effBus3[\Ringz].index,
		\freq, 100,
		\amp,1,
		\dur,1),
	Pmono(\Convolution,
		\group,~effGroup3,
		\inBus, ~effBus3[\Convolution].index,
		\dur,8),
	Pmono(\Vibrato,
		\group,~effGroup3,
		\inBus, ~effBus3[\Vibrato].index,
		\rate, Pseq([1,2,3,4],8),
		\depth, Pseq([0.02, 0.5,0.02],8 ),
		\delay,0.33,
		\dur,4),
	Pmono(\compander,
		\group,~effGroup3,
		\inBus, ~effBus3[\compander].index,
		\thresh, 0.8,
	              )

])//Pparz
)

/**Play & Stop them here!*/

//Too loud
x=x.play;
x.stop;

y=y.play;
y.stop;

//Won't stop after telling it to stop
z=z.play;
z.stop;


