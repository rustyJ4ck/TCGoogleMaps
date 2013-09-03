//
//  TCDirectionsParameters.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 8/25/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import "TCDirectionsParameters.h"
#import "TCDirectionsDataMapper.h"

NSString * const TCTravelModeDriving = @"DRIVING";
NSString * const TCTravelModeWalking = @"WALKING";
NSString * const TCTravelModeBicycling = @"BICYCLING";
NSString * const TCTravelModeTransit = @"TRANSIT";

@implementation TCDirectionsParameters

- (id)init
{
    self = [super init];
    if (self) {
        // Default travel mode is DRIVING.
        _travelMode = TCTravelModeDriving;
        
        // Initialize to invalid coordinates, so that if we forget to
        // set the origin or destination it will fail the assertion.
        _origin = kCLLocationCoordinate2DInvalid;
        _destination = kCLLocationCoordinate2DInvalid;
    }
    return self;
}

- (NSDictionary *)dictionary
{
    NSAssert(CLLocationCoordinate2DIsValid(self.origin), @"Origin must be set to valid coordinates.");
    NSAssert(CLLocationCoordinate2DIsValid(self.destination), @"Destination must be set to valid coordinates.");
    
    NSDictionary *parameters = @{@"origin": [TCDirectionsDataMapper stringFromCoordinate:self.origin],
                                 @"destination": [TCDirectionsDataMapper stringFromCoordinate:self.destination],
                                 @"sensor": @"false",
                                 @"mode": self.travelMode,
                                 @"alternatives": [TCDirectionsDataMapper stringFromBool:self.provideRouteAlternatives]};
    
    NSMutableDictionary *mutableParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
    // Add the optional "avoid" parameter only if requested.
    if (self.avoidTolls || self.avoidHighways) {
        mutableParameters[@"avoid"] = [self avoidParameterValue];
    }
    
    return [mutableParameters copy];
}

/**
 * Returns the string to be used as the 'avoid' request parameter's value.
 */
- (NSString *)avoidParameterValue
{    
    NSMutableString *value = [[NSMutableString alloc] init];
    
    if (self.avoidTolls) { [value appendString:@"tolls"]; }
    if (self.avoidTolls && self.avoidHighways) { [value appendString:@"|"]; }
    if (self.avoidHighways) { [value appendString:@"highways"]; }
    
    return value;
}

@end