
import Foundation

class ReachabilityManager {
    
    fileprivate(set) var isConnected : Bool = false
    fileprivate(set) var isConnectedViaWiFi: Bool = false
    fileprivate(set) var isConnectedViaCellualar: Bool = false
    fileprivate(set) static var isConnectedErrorShow: Bool = false
    
    fileprivate var reachability : Reachability!
    
    fileprivate static let sharedInstance = ReachabilityManager()
    
    static func isNetworkConnected() -> Bool   {
        return sharedInstance.isConnected
    }
    
    class func getInstance() -> ReachabilityManager {
        return sharedInstance
    }
    
    fileprivate init()  {
        self.isConnected = false
        self.isConnectedViaCellualar = false
        self.isConnectedViaWiFi = false
        self.reachability = Reachability()!
    }
    
    func reachabilityChanged(_ note: Notification) {
        
        let reachability = note.object as! Reachability
        if reachability.isReachable    {
            if reachability.isReachableViaWiFi   {
                print("Reachable via Wifi")
            }
            else    {
                print("Reachable via Cellular")
            }
        } else {
            print("Not reachable")
        }
    }
    
    static func startMonitoring()  {
        
        let manager = self.sharedInstance
        do  {
            try manager.reachability.startNotifier()
            
            manager.reachability.whenReachable = { reachability in
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                    manager.isConnected = true
                    manager.isConnectedViaWiFi = true
                    manager.isConnectedViaCellualar = false
                    if isConnectedErrorShow {
                        isConnectedErrorShow = false
                    }
                    else    {
                        isConnectedErrorShow = false
                    }
                } else {
                    print("Reachable via Cellular")
                    manager.isConnected = true
                    manager.isConnectedViaCellualar = true
                    manager.isConnectedViaWiFi = false
                    isConnectedErrorShow = false
                }
            }
            self.sharedInstance.reachability.whenUnreachable = { reachability in
                print("Not reachable")
                manager.isConnected = false
                //                self.showNotification()
            }
            manager.isConnected = manager.reachability.isReachable
            manager.isConnectedViaWiFi = manager.reachability.isReachableViaWiFi
            manager.isConnectedViaCellualar = manager.reachability.isReachableViaWWAN
        }   catch   {
            debugPrint(error)
        }
        
    }
    
    static func stopMonitoring()   {
        self.sharedInstance.reachability.stopNotifier()
    }
    
    
}
