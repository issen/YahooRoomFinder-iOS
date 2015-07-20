//
//  RoomsManager.m
//  wheres-my-room
//
//  Created by Chu-An Hsieh on 7/16/15.
//  Copyright (c) 2015 Chu-An Hsieh. All rights reserved.
//

#import "RoomsLocalityManager.h"
#import "../Model/FloorLocalityInfo.h"
#import "../Model/RoomLocalityInfo.h"
#import <CoreLocation/CLLocation.h>
@interface RoomsLocalityManager ()
@property (strong, nonatomic) NSDictionary *building;
@property (strong, nonatomic) NSDictionary *floors;
@end

@implementation RoomsLocalityManager

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initBuilding];
        [self initFloors];
    }
    return self;
}

+ (RoomsLocalityManager *) sharedInstance {
    static RoomsLocalityManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    // Make the block to be thread-safe
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[RoomsLocalityManager alloc] init];
        }
    });
    return instance;
}

- (FloorLocalityInfo*) getFloorInfoForOrder:(NSInteger)floorOrder {
    NSDictionary *floorDic = [self.floors objectForKey:@(floorOrder)];
    FloorLocalityInfo* floor = [[FloorLocalityInfo alloc] init];
    floor.order = floorOrder;
    floor.realWidthForMap = [floorDic[@"realWidth"] doubleValue];
    floor.realHeightForMap = [floorDic[@"realHeight"] doubleValue];
    floor.mapImageName = [NSString stringWithFormat:@"TW-%ldF", floorOrder + 1];
    return floor;
}

- (void) floors:(void(^)(NSArray *floors, NSError *error))completion {
    // TODO Don't hard-code the data here
    NSMutableArray *floors = [NSMutableArray array];
    for (id key in self.floors) {
        NSInteger floorOrder = [key integerValue];
        [floors addObject:[self getFloorInfoForOrder:floorOrder]];
    }
    completion(floors, nil);
}

- (void) floorForOrder:(NSInteger) floorOrder complete:(void(^)(FloorLocalityInfo *floor, NSError *error))completion {
    completion([self getFloorInfoForOrder:floorOrder], nil);
}


- (void) roomsForFloorWithOrder:(NSInteger)floorOrder complete:(void(^)(NSArray *rooms, NSError *error))completion {
    NSDictionary *floorDic = self.floors[@(floorOrder)];
    if (floorDic == nil) {
        NSError *err = [[NSError alloc] initWithDomain:@"RoomsLocalityManagerDomain" code:1 userInfo:
        @{
          NSLocalizedDescriptionKey: [NSString stringWithFormat: @"Invalid floor order: %ld", floorOrder]
          }];
        completion(nil, err);
        return;
    }
    NSMutableArray *rooms = [NSMutableArray array];
    for (NSDictionary *roomDic in floorDic[@"rooms"]) {
        RoomLocalityInfo* roomInfo = [[RoomLocalityInfo alloc] init];
        roomInfo.roomId = roomDic[@"id"];
        NSMutableArray *boundary = [NSMutableArray array];
        for (NSDictionary *boundaryPointDic in roomDic[@"boundary"]) {
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:[boundaryPointDic[@"lat"] doubleValue] longitude:[boundaryPointDic[@"lng"] doubleValue]];
            [boundary addObject:loc];
        }
        roomInfo.boundary = boundary;
        [rooms addObject:roomInfo];
    }
    
    completion(rooms, nil);
}

- (void)initBuilding {
    self.building =
    @{
      @"boundary": @[
              @{
                  @"lat": @(25.0571082),
                  @"lng": @(121.6142797)
                  },
              @{
                  @"lat": @(25.0572996),
                  @"lng": @(121.6142937)
                  },
              @{
                  @"lat": @(25.0572935),
                  @"lng": @(121.6144453)
                  },
              @{
                  @"lat": @(25.0573858),
                  @"lng": @(121.6144513)
                  },
              @{
                  @"lat": @(25.0573858),
                  @"lng": @(121.6144962)
                  },
              @{
                  @"lat": @(25.057559),
                  @"lng": @(121.6145023)
                  },
              @{
                  @"lat": @(25.0575268),
                  @"lng": @(121.61523720000001)
                  },
              @{
                  @"lat": @(25.057336),
                  @"lng": @(121.61522510000002)
                  },
              @{
                  @"lat": @(25.0573433),
                  @"lng": @(121.6150649)
                  },
              @{
                  @"lat": @(25.0572656),
                  @"lng": @(121.6150588)
                  },
              @{
                  @"lat": @(25.057263700000004),
                  @"lng": @(121.61503470000001)
                  },
              @{
                  @"lat": @(25.0570767),
                  @"lng": @(121.61502660000001)
                  },
              @{
                  @"lat": @(25.0571082),
                  @"lng": @(121.6142797)
                  },
              ]
      };
}

- (void)initFloors {
    self.floors =
    @{
      @(9): @{
              @"realWidth": @(90.0),
              @"realHeight": @(49.7277937),
              @"rooms": @[]
              },
      @(10): @{
              @"realWidth": @(90.04297994),
              @"realHeight": @(49.59885387),
              @"rooms": @[]
              },
      @(11): @{
              @"realWidth": @(90.04297994),
              @"realHeight": @(49.51289398),
              @"rooms": @[
                      @{
                          @"id": @"VC-TW-12FN-DajiaRiver",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FN-DanshuiRiver",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FN-DongshanRiver",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FN-HoneymoonBay",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FN-NanFangAo",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FS-Cijin",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FS-LianchiPond",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FS-LiyuPond",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FS-LoveRiver",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"VC-TW-12FS-QixingTan",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FS-TsengwenRiver",
                          @"boundary": @[]
                          },
                      @{
                          @"id": @"CR-TW-12FS-XiziWan",
                          @"boundary": @[]
                          }
                      ]
              },
      @(12): @{
              @"realWidth": @(90.47277937),
              @"realHeight": @(33.43839542),
              @"rooms": @[]
              },
      @(13): @{
              @"realWidth": @(90.17191977),
              @"realHeight": @(49.64183381),
              @"rooms": @[]
              },
      @(14): @{
              @"realWidth": @(91.67621777),
              @"realHeight": @(49.51289398),
              @"rooms": @[]
              },
      @(15): @{
              @"realWidth": @(90),
              @"realHeight": @(49.64183381),
              @"rooms": @[]
              },
      };
}
@end
