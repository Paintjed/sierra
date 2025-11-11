import SwiftUI

struct ContentView: View {
    @StateObject private var deviceManager = DeviceStatusManager()
    
    var body: some View {
        NavigationSplitView {
            DeviceListView(deviceManager: deviceManager)
                .navigationSplitViewColumnWidth(min: 300, ideal: 350)
        } detail: {
            DeviceDetailView(device: deviceManager.selectedDevice)
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            configureAppearance()
        }
    }
    
    private func configureAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}