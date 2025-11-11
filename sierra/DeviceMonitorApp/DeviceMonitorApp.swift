import SwiftUI

@main
struct DeviceMonitorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // 強制橫向模式
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                }
        }
    }
}