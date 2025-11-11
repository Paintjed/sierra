import SwiftUI

struct DeviceListView: View {
    @ObservedObject var deviceManager: DeviceStatusManager
    @State private var searchText = ""
    
    var filteredDevices: [Device] {
        if searchText.isEmpty {
            return deviceManager.devices
        } else {
            return deviceManager.devices.filter { device in
                device.name.localizedCaseInsensitiveContains(searchText) ||
                device.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            SearchBarView(searchText: $searchText)
            
            List(filteredDevices, selection: Binding(
                get: { deviceManager.selectedDevice },
                set: { device in
                    if let device = device {
                        deviceManager.selectDevice(device)
                    }
                }
            )) { device in
                DeviceRowView(device: device)
                    .tag(device)
            }
            .listStyle(SidebarListStyle())
        }
        .navigationTitle("Devices")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search Devices", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

struct DeviceRowView: View {
    let device: Device
    
    var body: some View {
        HStack(spacing: 12) {
            // Device icon
            ZStack {
                Circle()
                    .fill(device.isOnline ? 
                          LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing) :
                          LinearGradient(colors: [.gray, .secondary], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                
                Image(device.type.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(device.type.rawValue)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    // Online status
                    HStack(spacing: 4) {
                        Circle()
                            .fill(device.isOnline ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        
                        Text(device.isOnline ? "Online" : "Offline")
                            .font(.caption)
                            .foregroundColor(device.isOnline ? .green : .red)
                    }
                    
                    Spacer()
                    
                    // Battery level for devices that have batteries
                    if true {
                        HStack(spacing: 4) {
                            Image(systemName: batteryIcon(level: device.status.batteryLevel))
                                .font(.caption)
                                .foregroundColor(batteryColor(level: device.status.batteryLevel))
                            
                            Text("\(Int(device.status.batteryLevel))%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Spacer()
            
            // CPU usage indicator
            VStack {
                Text("CPU")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                CircularProgressView(
                    progress: device.status.cpuUsage / 100,
                    color: cpuColor(usage: device.status.cpuUsage)
                )
                .frame(width: 30, height: 30)
                
                Text("\(Int(device.status.cpuUsage))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    
    private func batteryIcon(level: Double) -> String {
        switch level {
        case 75...100: return "battery.100"
        case 50..<75: return "battery.75"
        case 25..<50: return "battery.25"
        default: return "battery.0"
        }
    }
    
    private func batteryColor(level: Double) -> Color {
        switch level {
        case 50...100: return .green
        case 20..<50: return .orange
        default: return .red
        }
    }
    
    private func cpuColor(usage: Double) -> Color {
        switch usage {
        case 0..<50: return .green
        case 50..<80: return .orange
        default: return .red
        }
    }
}

struct CircularProgressView: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 3)
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}

#Preview {
    NavigationView {
        DeviceListView(deviceManager: DeviceStatusManager())
    }
}
