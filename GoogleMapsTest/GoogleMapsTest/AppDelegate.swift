//
//  AppDelegate.swift
//  GoogleMapsTest
//

import UIKit
import GoogleMaps
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyCwNBvx-l-iw8rXGTZznAThTROofudLdio")
        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "625584202561-lse020f7i07gqpvvgb1c4veeq60p4ljj.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        LocationManager.startMonitoring()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            if let gpSignin = GIDSignIn.sharedInstance() {
                if gpSignin.scopes != nil {
                    let scopes = NSMutableArray(array: gpSignin.scopes)
                    scopes.add("https://www.googleapis.com/auth/plus.login")
                    if let convertedScopes = scopes as? [Any] {
                        gpSignin.scopes = convertedScopes
                    }
                }
                
                if gpSignin.hasAuthInKeychain() {
                    print("Signed In")
                    // GIDSignIn.sharedInstance().signInSilently()
                    gpSignin.signIn()
                    // logInToBackendServerWithAuthIdToken()
                } else {
                    print("Not Signed In")
                    gpSignin.signOut()
                    gpSignin.signIn()
                    //  region.show(googleLoginView())
                }
            }
            
            
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

