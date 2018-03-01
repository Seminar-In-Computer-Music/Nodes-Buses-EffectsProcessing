/*****
Welcome to Loui's Processed Synth Library 🍭🤖🌈
******/


/*Setup*/

Server.default.options.numOutputBusChannels
Server.default.options.numInputBusChannels

(
Server.default.options.numOutputBusChannels=8;
Server.default.options.numInputBusChannels = 8;

Server.local.latency= 0.05;
)


(
/***CONVOLUTION***/

// convolution:strict convolution of two continuously changing inputs
SynthDef(\Convolution,{|inBus=16, frameSize= 512|
	Out.ar(0, Convolution.ar(In.ar(inBus,1), LFSaw.ar([300,500,800,1000]), frameSize));

}).store;

//convolution with less CPU cost , if the kernel is longer than this framesize, the end will be ignored

SynthDef(\Convolution2,{|inBus=16, frameSize= 512|
	Out.ar(0, Convolution.ar(In.ar(inBus,1), LFSaw.ar([300,500,800,1000]), frameSize));

}).store;



/*******DELAYS******/

//Pluck
SynthDef( \Pluck, {|inBus=16,trig=1, maxdelayTime= 0.05, delayTime=0.55,decayTime=1|
	Out.ar(0, Pluck.ar(In.ar(inBus,1),trig,maxdelayTime,delayTime,decayTime))
}).store;


//delay1
SynthDef(\delay1, {|inBus=16, mul=1|
	Out.ar(0, Delay1.ar(In.ar(inBus,1),mul));
}).store;


//Greyhole
/*
SynthDef(\greyHole, { |inBus=16, delayTime=2, damp=0, size=1, diff=0.707, feedBack=0.9, modDepth= 0.1, modFreq=2|
Out.ar(0, Greyhole.ar(In.ar(inBus,1), delayTime,damp,size,diff,feedBack,modDepth, modFreq));


}).store;*/



/*******DYNAMICS***/

//Limiter

SynthDef(\limiter, {|inBus=16, level=1, dur=0.01|
	Out.ar(0, Limiter.ar(In.ar(inBus, 1), level, dur));

}).store;

//Compressor,expander, limiter, gate, & ducker

SynthDef(\compander, {|inBus=16, thresh= 0.8, slopeBelow=1, slopeAbove=1, clampTime= 0.01, relaxTime=0.01|
	Out.ar(0, CompanderD.ar(In.ar(inBus,1), thresh,slopeBelow, slopeAbove, clampTime, relaxTime));
}).store;


//Normalizer
SynthDef(\normalizer, {|inBus=16, level=1, dur=0.01|
	Out.ar(0, Normalizer.ar(In.ar(inBus, 1), level, dur));
}).store;



/*******FILTERS******/


SynthDef(\MoogFF,{|inBus=16,freq=440,gain=0.05,amp=0.25|
	Out.ar(0,MoogFF.ar(In.ar(inBus,1),freq,gain,mul:amp))
}).store;




SynthDef( \Ringz, {|inBus=16,freq=1000, decay= 0.05, amp=1|
	Out.ar(0, Ringz.ar(In.ar(inBus,1),freq,decay,amp))
}).store;





/****REVERB*********/

/*SynthDef(\jpVerb,{|inBus=16, t60=1, damp=1, size=1, earlyDiff=0.707, modDepth=0.1, modFreq=2, low=1, mid=1, high=1, lowcut=500, highcut=2000 |
Out.ar(0, JPverb.ar(In.ar(inBus,1),t60, damp ,size, earlyDiff, modDepth, modFreq,low, mid, high, lowcut, highcut));
}).store;*/



SynthDef(\gVerb,{|inBus=16, roomsize=10, revtime=3, damping=0.5, inputbw=0.5, spread=15,
	drylevel=1, earlyreflevel=0.7, taillevel=0.5, maxroomsize=300, mul=1|
	Out.ar(0, GVerb.ar(In.ar(inBus,1), roomsize, revtime, damping, inputbw, spread, drylevel, earlyreflevel, taillevel, maxroomsize, mul));

}).store;


SynthDef(\freeVerb, {|inBus=16, mix=0.33, room=0.5, damp=0.5, mul=1 |
	Out.ar(0, FreeVerb.ar(In.ar(inBus,1), mix, room, damp, mul));
}).store;

/***PITCH**********/

SynthDef(\Vibrato, {|inBus=16, rate=6, depth=0.02, delay=0,rateVariation=1, depthVariation=0.1|
	Out.ar(0,Vibrato.ar(In.ar(inBus,1),rate,depth,delay,rateVariation:rateVariation, depthVariation:depthVariation));

}).store;


SynthDef(\pshift,{|inBus=16,wsize=0.2,pRtio=0.75,pDsp=0,tDsp=0.01,amp=1|
	Out.ar(0,PitchShift.ar(In.ar(inBus,1),wsize,pRtio,pDsp,tDsp,amp));
}).store;

/******FFT**********/




)

/*SOURCE SYNTHS*/

(

SynthDef(\realParallelFmP, { arg modAmp1=0.33, modAmp2= 0.33,  modFreq1= 441 ,modFreq2=551, carFreq= 30 ,carAmp= 0.33, modDepth=500,effBus=16,eff1Amp=0,eff2Amp=0,eff3Amp=0,eff4Amp=0,amp=0.1;

	var moddedFreqs= SinOsc.ar(carFreq+(modDepth* (SinOsc.ar(modFreq1,0, modAmp1)+
		SinOsc.ar(modFreq2,0, modAmp2)) ),0, carAmp);
	Out.ar(effBus,[moddedFreqs*eff1Amp,moddedFreqs*eff2Amp,moddedFreqs*eff3Amp,moddedFreqs*eff4Amp].dup);
	Out.ar(0, moddedFreqs*amp.dup);

}).store;


SynthDef(\aSynthP, {

	arg roomsize=100, revtime=30, taillevel=0, amp=1,effBus=16,eff1Amp=0,eff2Amp=0,eff3Amp=0,eff4Amp=0,amp1=0.1;

	var env = Env.linen(0.1,0.5,1.5,0.5);
	var modFreq= PinkNoise.ar(EnvGen.kr(env,doneAction: 2));
	var modFreq2= SinOsc.ar(70,0,EnvGen.kr(env,doneAction: 2));
	var carFreq= SinOsc.ar(20,0,EnvGen.kr(env,doneAction: 2));
	var added= modFreq+modFreq2;
	var filtered= Resonz.ar(carFreq*added);
	var gverbed= GVerb.ar(filtered,roomsize,revtime,taillevel:taillevel);

	Out.ar(effBus,[added*eff1Amp,added*eff2Amp,added*eff3Amp,added*eff4Amp]);
	Out.ar(0, gverbed*amp1.dup);

}).store;


SynthDef(\realMulticarrierFmP, { arg modFreq=411, carFreq1=40, carFreq2= 50, carFreq3=60, carAmp1=0.33,
	carAmp2=0.33, carAmp3=0.33,modDepth=500,effBus=16,eff1Amp=0,eff2Amp=0,eff3Amp=0,eff4Amp=0,amp1=0.1;

	var freq= SinOsc.ar(modFreq);
	var cars=SinOsc.ar(carFreq1+ (SinOsc.ar(carFreq2+( SinOsc.ar(carFreq3, 0, carFreq3)),0,carFreq2)),0,carAmp1);
	var multCar= SinOsc.ar((modDepth*freq)+cars);

	Out.ar(effBus,[multCar*eff1Amp,multCar*eff2Amp,multCar*eff3Amp,multCar*eff4Amp]);
	Out.ar(0, (multCar*amp1).dup);

}).store;


)
