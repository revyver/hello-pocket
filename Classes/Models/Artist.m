//
//  Artist.m
//  Hello! Pocket
//
//  Created by Bryan Veloso on 10/23/11.
//  Copyright (c) 2011 Revyver, Inc. All rights reserved.
//

#import "Artist.h"

#import "HPHelloRankingAPIClient.h"
#import "NSDate+RFC2822.h"
#import "SVProgressHUD.h"

@implementation Artist

@synthesize pk = _pk;
@synthesize name = _name;
@synthesize kanji = _kanji;
@synthesize alias = _alias;
@synthesize aliasKanji = _aliasKanji;
@synthesize birthdate = _birthdate;
@synthesize bloodtype = _bloodtype;
@synthesize familyKanji = _familyKanji;
@synthesize familyName = _familyName;
@synthesize givenKanji = _givenKanji;
@synthesize givenName = _givenName;
@synthesize nicknames = _nicknames;
@synthesize note = _note;
@synthesize scope = _scope;
@synthesize status = _status;

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.pk = [attributes valueForKeyPath:@"id"];
    self.name = [attributes valueForKeyPath:@"name"];
    self.kanji = [attributes valueForKeyPath:@"kanji"];
    self.alias = [attributes valueForKeyPath:@"alias"];
    self.aliasKanji = [attributes valueForKeyPath:@"alias_kanji"];
    self.birthdate = [NSDate dateFromRFC2822:[attributes valueForKeyPath:@"birthdate"]];
    self.bloodtype = [attributes valueForKeyPath:@"bloodtype"];
    self.familyKanji = [attributes valueForKeyPath:@"family_kanji"];
    self.familyName = [attributes valueForKeyPath:@"family_name"];
    self.givenKanji = [attributes valueForKeyPath:@"given_kanji"];
    self.givenName = [attributes valueForKeyPath:@"given_name"];
    self.nicknames = [attributes valueForKeyPath:@"nicknames"];
    self.note = [attributes valueForKeyPath:@"note"];
    self.scope = [attributes valueForKeyPath:@"scope"];
    self.status = [attributes valueForKeyPath:@"status"];

    return self;
}

+ (void)fetchWithBlock:(void (^)(NSArray *))block
{
    NSDictionary *limit = [NSDictionary dictionaryWithObject:@"0" forKey:@"limit"];
    [[HPHelloRankingAPIClient sharedClient] getPath:@"/artists/" parameters:limit success:^(id object) {
        NSMutableArray *mutableRecords = [NSMutableArray array];
        for (NSDictionary *attributes in [object valueForKeyPath:@"objects"]) {
            Artist *artist = [[Artist alloc] initWithAttributes:attributes];
            [mutableRecords addObject:artist];
        }
        if (block) {
            block([NSArray arrayWithArray:mutableRecords]);
            [SVProgressHUD dismissWithSuccess:@"Success!"];
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        if (block) {
            block([NSArray array]);
            [SVProgressHUD dismissWithError:@"Whoops!"];
        }
    }];
}

+ (void)fetchWithString:(NSString *)urlString parameters:(NSDictionary *)parameters block:(void (^)(Artist *))block
{
    NSDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [[HPHelloRankingAPIClient sharedClient] getPath:urlString parameters:mutableParameters success:^(id object) {
        if (block) {
            block([[Artist alloc] initWithAttributes:object]);
        }
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        if (block) {
            block([[Artist alloc] init]);
        }
    }];
}

@end
