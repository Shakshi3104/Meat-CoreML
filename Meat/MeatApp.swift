//
//  MeatApp.swift
//  Meat
//
//  Created by MacBook Pro on 2021/07/11.
//

import SwiftUI

@main
struct MeatApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions lanchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.badge]) { granted, error in
                if let error = error {
                    // Handle the error
                    print(error)
                }
                
                DispatchQueue.main.async {
                    UIApplication.shared.perform(NSSelectorFromString("setApplicationBadgeString:"), with: "🥩")
                }
            }
            
            return true
        }
}
