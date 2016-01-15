//
//  Purr.h
//  PP
//
//  Created by Isaac Clarke on 23/07/2015.
//  Copyright (c) 2015 Isaac Clarke. All rights reserved.
//

#import "AKFoundation.h"
@interface Purr : AKInstrument

@property AKInstrumentProperty *amplitude;
@property AKInstrumentProperty *noiseAmp;
@property AKInstrumentProperty *sawSpeed;
@property AKInstrumentProperty *sawPinkMix;
@property AKInstrumentProperty *pinkHalfPower;
@property AKInstrumentProperty *sawFreq;
@property AKInstrumentProperty *LFOnoiseFreq;

@end