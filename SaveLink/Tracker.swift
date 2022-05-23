//
//  Tracker.swift
//  SaveLink
//
//  Created by Home on 9/1/22.
//

import Foundation
import FirebaseAnalytics

final class Tracker {
    static func trackCreateLinkEvent(url: String) {
        Analytics.logEvent("CreateLinkEvent",
                           parameters: ["url" : url])
    }
    
    static func trackSaveLinkEvent() {
        Analytics.logEvent("SaveLinkEvent",
                           parameters: nil)
    }
    
    static func trackErrorSaveLinkEvent(error: String) {
        Analytics.logEvent("ErrorSaveLinkEvent",
                           parameters: ["error" : error])
    }
}
