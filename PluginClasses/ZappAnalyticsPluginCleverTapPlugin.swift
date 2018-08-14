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

/**
This Template contains protocol methods to be implemented according to your needs.
Some of the methods can be removed if they are not relevant for your implementation.
You can also add methods from the protocol, for more information about the available methods, please check ZPAnalyticsProviderProtocol under ZappPlugins.
**/

public class CleverTapAnalyticsPlugin: ZPAnalyticsProvider {
    
    var cleverTap:CleverTap?
    var timedEventDictionary: NSMutableDictionary?
    let eventDuration = "EVENT_DURATION"
    
    public override func createAnalyticsProvider(_ allProvidersSetting: [String : NSObject]) -> Bool {
        return super.createAnalyticsProvider(allProvidersSetting)
    }
    
    public override func configureProvider() -> Bool {
        CleverTap.autoIntegrate()
        return super.configureProvider()
    }
    
    public override func getKey() -> String {
        return "clevertap_analytics"
    }
    
    public override func trackEvent(_ eventName: String, parameters: [String : NSObject], completion: ((Bool, String?) -> Void)?) {
        switch eventName {
        case "APPLICATION_STARTED":
            break
        default:
            if parameters.isEmpty {
                CleverTap.sharedInstance()?.recordEvent(eventName)
            } else {
                CleverTap.sharedInstance()?.recordEvent(eventName, withProps: parameters)
            }
        }
    }
    
    public override func trackEvent(_ eventName: String) {
        trackEvent(eventName, parameters: [String : NSObject](), completion: nil)
        let components = getDateComponents()
        if timedEventDictionary == nil {
            timedEventDictionary = NSMutableDictionary()
        }
        timedEventDictionary![eventName] = components
    }
    
    public override func trackEvent(_ eventName: String, timed: Bool) {
        trackEvent(eventName, parameters: [String : NSObject](), timed: timed)
    }
    
    public override func trackEvent(_ eventName: String, parameters: [String : NSObject], timed: Bool) {
        let components = getDateComponents()
        if timedEventDictionary == nil {
            timedEventDictionary = NSMutableDictionary()
        }
        timedEventDictionary![eventName] = components
    }
    
    public override func trackEvent(_ eventName: String, parameters: [String : NSObject]) {
        trackEvent(eventName, parameters: parameters, completion: nil)
    }
    
    func getDateComponents() -> DateComponents {
        let date = Date()
        let calendar = NSCalendar.current
        return calendar.dateComponents([.day,.hour, .minute, .second], from: date)
    }
    
}
