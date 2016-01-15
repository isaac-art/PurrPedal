//
//  Purr.m
//  PP
//
//  Created by Isaac Clarke on 23/07/2015.
//  Copyright (c) 2015 Isaac Clarke. All rights reserved.
//

#import "Purr.h"

@implementation Purr
- (instancetype)initWithNumber:(NSUInteger)instrumentNumber
{
    self = [super initWithNumber:instrumentNumber];
    if (self){
        _amplitude = [self createPropertyWithValue:0.6 minimum:0 maximum:0.9];
        _noiseAmp = [self createPropertyWithValue:0.6 minimum:0 maximum:0.9];
        _sawSpeed = [self createPropertyWithValue:0.18 minimum:0 maximum:0.8];
        _sawPinkMix = [self createPropertyWithValue:0.5 minimum:0 maximum:1];
        _pinkHalfPower = [self createPropertyWithValue:40 minimum:10 maximum:1000];
        _sawFreq = [self createPropertyWithValue:20 minimum:1 maximum:150];
        _LFOnoiseFreq = [self createPropertyWithValue:0.15 minimum:0.1 maximum:8];

        //Saw
        AKJitter *frequencyVariation =[[AKJitter alloc] initWithAmplitude:akp(0.1) minimumFrequency:akp(0.01) maximumFrequency:akp(0.1)];
        AKJitter *frequencyVariation2 =[[AKJitter alloc] initWithAmplitude:akp(6) minimumFrequency:akp(0.06) maximumFrequency:akp(0.1)];
        
        AKLowFrequencyOscillator *LFO = [[AKLowFrequencyOscillator alloc] init];
        LFO.waveformType = [AKLowFrequencyOscillator waveformTypeForSine];
        LFO.amplitude = [_amplitude minus:akp(0.1)];
        LFO.frequency = [_sawSpeed plus:frequencyVariation];
        
        AKVCOscillator *sawtooth = [[AKVCOscillator alloc] init];
        sawtooth.waveformType = [AKVCOscillator waveformTypeForSawtooth];
        sawtooth.amplitude = LFO;
        sawtooth.frequency = [_sawFreq plus:frequencyVariation2];
        sawtooth.bandwidth = akp(155);
        
        AKBandPassButterworthFilter *BPF = [AKBandPassButterworthFilter filterWithInput:sawtooth];
        BPF.bandwidth = akp(155);
        BPF.centerFrequency = akp(75);
        
        
        //Noise
        AKNoise *pinkNoise = [[AKNoise alloc] initWithAmplitude:_noiseAmp pinkBalance:akp(1) beta:akp(0)];
        AKLowFrequencyOscillator *LFOnoise = [[AKLowFrequencyOscillator alloc] init];
        LFOnoise.waveformType = [AKLowFrequencyOscillator waveformTypeForSine];
        LFOnoise.amplitude = [_noiseAmp plus:akp(0.1)];
        LFOnoise.frequency = [_LFOnoiseFreq plus:frequencyVariation];
        
        AKLowPassFilter *noiseFilter = [[AKLowPassFilter alloc] initWithInput:pinkNoise];
        noiseFilter.halfPowerPoint = [_pinkHalfPower scaledBy:LFOnoise];

    //GeigerCount
//        AKAudioInput *microphone = [[AKAudioInput alloc] init];
//        AKTrackedAmplitude *geigerCounter;
//        geigerCounter = [[AKTrackedAmplitude alloc] initWithInput:microphone];
//        //get geiger click and if clicks start measure time
        
        //audio out
        AKMix *noiseSawMix = [[AKMix alloc] initWithInput1:noiseFilter input2:BPF balance:_sawPinkMix];
//
        
        [self setAudioOutput:noiseSawMix];
   
    }
    return self;
}


@end
