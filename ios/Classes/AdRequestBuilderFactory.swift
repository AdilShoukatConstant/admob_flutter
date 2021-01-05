//
//  AdRequestBuilderFactory.swift
//  admob_flutter
//
//  Created by 유송이 on 2021/01/05.
//
//  Converted to Swift 5.2 by Swiftify v5.2.23024 - https://swiftify.com/
import GoogleMobileAds

class FLTRequestFactory {
    private var targetingInfo: [AnyHashable : Any]?

    init(targetingInfo: [AnyHashable : Any]?) {
        self.targetingInfo = targetingInfo
    }

    func targetingInfoArray(forKey key: String?, info: [AnyHashable : Any]?) -> [AnyHashable]? {
        let value = info?[key ?? ""] as? NSObject
        if value == nil {
            return nil
        }
        if !(value is [AnyHashable]) {
            //    FLTLogWarning(@"targeting info %@: expected an array (MobileAd %@)", key, self);
            return nil
        }
        return value as? [AnyHashable]
    }

    func targetingInfoString(forKey key: String?, info: [AnyHashable : Any]?) -> String? {
        let value = info?[key ?? ""] as? NSObject
        if value == nil {
            return nil
        }
        if !(value is NSString) {
            //    FLTLogWarning(@"targeting info %@: expected a string (MobileAd %@)", key, self);
            return nil
        }
        let stringValue = value as? String
        if (stringValue?.count ?? 0) == 0 {
            //    FLTLogWarning(@"targeting info %@: expected a non-empty string (MobileAd %@)", key, self);
            return nil
        }
        return stringValue
    }

    func targetingInfoBool(forKey key: String?, info: [AnyHashable : Any]?) -> NSNumber? {
        let value = info?[key ?? ""] as? NSObject
        if value == nil {
            return nil
        }
        if !(value is NSNumber) {
            //    FLTLogWarning(@"targeting info %@: expected a boolean, (MobileAd %@)", key, self);
            return nil
        }
        return value as? NSNumber
    }
    
    func createRequest() -> GADRequest? {
        let request = GADRequest()
        if targetingInfo == nil {
            return request
        }

        let testDevices = targetingInfoArray(forKey: "testDevices", info: targetingInfo)
//        if let testDevices = testDevices {
//            request.testDevices = testDevices
//        }

        let keywords = targetingInfoArray(forKey: "keywords", info: targetingInfo)
        if let keywords = keywords {
            request.keywords = keywords
        }

        let contentURL = targetingInfoString(forKey: "contentUrl", info: targetingInfo)
        if let contentURL = contentURL {
            request.contentURL = contentURL
        }

        let birthday = targetingInfo?["birthday"] as? NSObject
        if let birthday = birthday {
            if !(birthday is NSNumber) {
                //      FLTLogWarning(@"targeting info birthday: expected a long integer (MobileAd %@)", self);
            } else {
                // Incoming time value is milliseconds since the epoch, NSDate uses
                // seconds.
                request.birthday = Date(timeIntervalSince1970: Double((birthday as? NSNumber)?.intValue ?? 0) / 1000.0)
            }
        }

        let gender = targetingInfo?["gender"] as? NSObject
        if let gender = gender {
            if !(gender is NSNumber) {
                //      FLTLogWarning(@"targeting info gender: expected an integer (MobileAd %@)", self);
            } else {
                let genderValue = (gender as? NSNumber)?.intValue ?? 0
                switch genderValue {
                    case 0 /* MobileAdGender.unknown */, 1 /* MobileAdGender.male */, 2 /* MobileAdGender.female */:
                        request.gender = GADGender(rawValue: genderValue)!
                    default:
                        break
                }
            }
        }

        let childDirected = targetingInfoBool(forKey: "childDirected", info: targetingInfo)
        if let childDirected = childDirected {
            request.tag(forChildDirectedTreatment: childDirected.boolValue)
        }

        let requestAgent = targetingInfoString(forKey: "requestAgent", info: targetingInfo)
        if let requestAgent = requestAgent {
            request.requestAgent = requestAgent
        }

        let nonPersonalizedAds = targetingInfoBool(
            forKey: "nonPersonalizedAds",
            info: targetingInfo)
        if nonPersonalizedAds != nil && nonPersonalizedAds?.boolValue ?? false {
            let extras = GADExtras()
            extras.additionalParameters = [
                "npa": "1"
            ]
            request.register(extras)
        }

        return request
    }
}
