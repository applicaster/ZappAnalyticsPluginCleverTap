//
//  ZappAnalyticsPluginCleverTapPlugin
//  ZappAnalyticsPluginCleverTap
//
//  Created by Roi Kedarya on 14/08/2018.
//  Copyright © 2018 applicaster. All rights reserved.
//

import ZappPlugins
import ZappAnalyticsPluginsSDK
import CleverTapSDK

public class ZappAnalyticsPluginCleverTapPlugin: ZPAnalyticsProvider {
    
    let eventDuration = "EVENT_DURATION"
    static var isAutoIntegrated: Bool = false
    var timedEventDictionary: NSMutableDictionary?
    var userID: String?
    
    public override func createAnalyticsProvider(_ allProvidersSetting: [String : NSObject]) -> Bool {
        return super.createAnalyticsProvider(allProvidersSetting)
    }
    
    public override func configureProvider() -> Bool {
        if !(ZappAnalyticsPluginCleverTapPlugin.isAutoIntegrated) {
            ZappAnalyticsPluginCleverTapPlugin.isAutoIntegrated = true
            CleverTap.autoIntegrate()
        }
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
        retVal = !(eventName == "Launch App") && ZAAppConnector.sharedInstance().identityDelegate.isLoginPluginAuthenticated()
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
            ZAAppConnector.sharedInstance().identityDelegate.isLoginPluginAuthenticated() {
            userID = ZAAppConnector.sharedInstance().identityDelegate.getLoginPluginToken()
            CleverTap.sharedInstance().profilePush(["Identity":userID!])
        }
    }
}
