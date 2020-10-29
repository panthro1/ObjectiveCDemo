#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <parse/parse.h>
@interface BasicMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
	NSString *_title;
    
    
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) PFUser *doctor;
- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
