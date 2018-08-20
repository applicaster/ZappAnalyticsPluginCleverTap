//
//  ZappAnalyticsPluginCleverTapPlugin
//  ZappAnalyticsPluginCleverTap
//
//  Created by Roi Kedarya on 14/08/2018.
//  Copyright © 2018 applicaster. All rights reserved.
//

import Foundation
import ZappPlugins
import ApplicasterSDK
import CleverTapSDK

/**
This Template contains protocol methods to be implemented according to your needs.
Some of the methods can be removed if they are not relevant for your implementation.
You can also add methods from the protocol, for more information about the available methods, please check ZPAnalyticsProviderProtocol under ZappPlugins.
**/

public class ZappAnalyticsPluginCleverTapPlugin: ZPAnalyticsProvider {
    
    var cleverTap:CleverTap?
    var LoginProvider: ZPLoginProviderProtocol?
    var timedEventDictionary: NSMutableDictionary?
    var userID: String?
    let eventDuration = "EVENT_DURATION"
    
    public override func createAnalyticsProvider(_ allProvidersSetting: [String : NSObject]) -> Bool {
        let retVal = super.createAnalyticsProvider(allProvidersSetting)
        CleverTap.autoIntegrate()
        return retVal
    }
    
    public override func configureProvider() -> Bool {
        return true
    }
    
    public override func getKey() -> String {
        return "clevertap_analytics"
    }
    
    public override func trackEvent(_ eventName: String, parameters: [String : NSObject], completion: ((Bool, String?) -> Void)?) {
        if parameters.isEmpty {
            CleverTap.sharedInstance()?.recordEvent(eventName)
        } else {
            CleverTap.sharedInstance()?.recordEvent(eventName, withProps: parameters)
        }
    }
    
    /*
     Track Analytics only for authenticated users
     Will not track the Launch App Event
    **/
    public override func shouldTrackEvent(_ eventName: String) -> Bool {
        var retVal = false
        checkUserID()
        if let loginPlugin = getLoginPlugin() {
           retVal = !(eventName == "Launch App") && loginPlugin.isAuthenticated()
        }
        return retVal
    }
    
    public override func trackEvent(_ eventName: String) {
        trackEvent(eventName, parameters: [String : NSObject](), completion: nil)
    }
    
    public override func trackEvent(_ eventName: String, timed: Bool) {
        trackEvent(eventName, parameters: [String : NSObject](), timed: timed)
    }
    
    public override func trackEvent(_ eventName: String, parameters: [String : NSObject], timed: Bool) {
        if timedEventDictionary == nil {
            timedEventDictionary = NSMutableDictionary()
        }
        timedEventDictionary![eventName] = Date()
    }
    
    public override func endTimedEvent(_ eventName: String, parameters: [String : NSObject]) {
        if let timedEventDictionary = timedEventDictionary {
            if let startDate = timedEventDictionary[eventName] as? Date {
                let endDate = Date()
                let elapsed = endDate.timeIntervalSince(startDate)
                var params = parameters.count > 0 ? parameters : [String : NSObject]()
                let durationInMilSec = NSString(format:"%f",elapsed * 1000)
                params[eventDuration] = durationInMilSec
                trackEvent(eventName, parameters: params)
            }
        }
    }
    
    public override func trackEvent(_ eventName: String, parameters: [String : NSObject]) {
        trackEvent(eventName, parameters: parameters, completion: nil)
    }
    
    func checkUserID() {
        if userID == nil,
            let activeInstance = ZPLoginManager.sharedInstance.activeInstance {
            userID = activeInstance.getUserToken()
            CleverTap.sharedInstance().profilePush(["Identity":userID!])
        }
    }
    
    func getLoginPlugin() -> ZPLoginProviderProtocol? {
        if LoginProvider == nil {
            if let activeInstance = ZPLoginManager.sharedInstance.activeInstance {
                LoginProvider = activeInstance
            }
        }
        return LoginProvider
    }
}
