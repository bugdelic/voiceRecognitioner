/*
    Copyright (C) 2016 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The application delegate.
*/

import UIKit

//import framework
import SwiftOSC

// Setup Client. Change address from localhost if needed.
var client = OSCClient(address: "sonic.local", port: 8080)


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
}
