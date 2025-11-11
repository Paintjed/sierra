import SwiftUI
import Charts

struct DeviceDetailView: View {
    let device: Device?
    
    var body: some View {
        if let device = device {
            ScrollView {
                VStack(spacing: 20) {
                    // Equipment Diagram
                    EquipmentDiagramView(selectedDevice: device, showTitle: false)
                        .frame(height: 300)
                    
                    // Device Header
                    DeviceHeaderView(device: device)
                  
                  // Work Progress (if device is working)
                  if device.isOnline && device.isWorking {
                      WorkProgressView(device: device)
                  }
                  
                    
                    // 狀態卡片區域
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatusCardView(
                            title: "CPU Usage",
                            value: device.status.cpuUsage,
                            unit: "%",
                            icon: "cpu",
                            color: cpuColor(usage: device.status.cpuUsage)
                        )
                        
                        if true {
                            StatusCardView(
                                title: "Battery Level",
                                value: device.status.batteryLevel,
                                unit: "%",
                                icon: "battery.100",
                                color: batteryColor(level: device.status.batteryLevel)
                            )
                        }
                        
                    }
                    
                    // Network Status
                    NetworkStatusView(networkStatus: device.status.networkStatus)
                    
                    // 系統信息區域
                    SystemInfoView(device: device)
                }
                .padding()
            }
            .navigationTitle(device.name)
            .navigationBarTitleDisplayMode(.large)
        } else {
            ContentUnavailableView(
                "Select Device",
                systemImage: "ipad.and.iphone",
                description: Text("Choose a device from the left sidebar to view details")
            )
        }
    }
    
    private func cpuColor(usage: Double) -> Color {
        switch usage {
        case 0..<50: return .green
        case 50..<80: return .orange
        default: return .red
        }
    }
    
    private func batteryColor(level: Double) -> Color {
        switch level {
        case 50...100: return .green
        case 20..<50: return .orange
        default: return .red
        }
    }
    
}

struct DeviceHeaderView: View {
    let device: Device
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(device.isOnline ?
                          LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing) :
                          LinearGradient(colors: [.gray, .secondary], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 80, height: 80)
                
                Image(device.type.icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(device.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(device.type.rawValue)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                HStack {
                    Circle()
                        .fill(device.isOnline ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                    
                    Text(device.isOnline ? "Online" : "Offline")
                        .font(.subheadline)
                        .foregroundColor(device.isOnline ? .green : .red)
                }
            }
            
            Spacer()
            
            VStack {
                Text("Temperature")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(Int(device.status.temperature))°C")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(temperatureColor(temp: device.status.temperature))
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
    }
    
    private func temperatureColor(temp: Double) -> Color {
        switch temp {
        case 0..<40: return .blue
        case 40..<60: return .orange
        default: return .red
        }
    }
}

struct StatusCardView: View {
    let title: String
    let value: Double
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: CGFloat(value / 100))
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: value)
                
                VStack {
                    Text("\(Int(value))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct NetworkStatusView: View {
    let networkStatus: DeviceStatus.NetworkStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Network Status")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack {
                    Image(systemName: networkStatus.isConnected ? "wifi" : "wifi.slash")
                        .font(.title2)
                        .foregroundColor(networkStatus.isConnected ? .green : .red)
                    
                    Text(networkStatus.isConnected ? "Connected" : "Disconnected")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if networkStatus.isConnected {
                    VStack {
                        Text("Signal Strength")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ProgressView(value: networkStatus.signalStrength / 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: signalColor(strength: networkStatus.signalStrength)))
                        
                        Text("\(Int(networkStatus.signalStrength))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 100)
                    
                    VStack {
                        Text("Download")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(String(format: "%.1f", networkStatus.downloadSpeed))")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Mbps")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack {
                        Text("Upload")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(String(format: "%.1f", networkStatus.uploadSpeed))")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Mbps")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
    }
    
    private func signalColor(strength: Double) -> Color {
        switch strength {
        case 0..<30: return .red
        case 30..<70: return .orange
        default: return .green
        }
    }
}

struct SystemInfoView: View {
    let device: Device
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("System Information")
                .font(.headline)
                .foregroundColor(.primary)
            
            VStack(spacing: 8) {
                InfoRowView(
                    title: "Uptime",
                    value: formatUptime(device.status.uptime),
                    icon: "clock"
                )
                
                InfoRowView(
                    title: "Last Activity",
                    value: formatLastSeen(device.lastSeen),
                    icon: "clock.arrow.circlepath"
                )
                
                InfoRowView(
                    title: "Device Type",
                    value: device.type.rawValue,
                    icon: device.type.icon
                )
                
                InfoRowView(
                    title: "Status",
                    value: device.isOnline ? "Running" : "Offline",
                    icon: device.isOnline ? "checkmark.circle.fill" : "xmark.circle.fill"
                )
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
    }
    
    private func formatUptime(_ uptime: TimeInterval) -> String {
        let days = Int(uptime) / 86400
        let hours = (Int(uptime) % 86400) / 3600
        let minutes = (Int(uptime) % 3600) / 60
        
        if days > 0 {
            return "\(days) days \(hours) hours"
        } else if hours > 0 {
            return "\(hours) hours \(minutes) minutes"
        } else {
            return "\(minutes) minutes"
        }
    }
    
    private func formatLastSeen(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct InfoRowView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    NavigationView {
        DeviceDetailView(device: Device(
            name: "Test Device",
            type: .painter,
            isOnline: true,
            isWorking: true,
            workProgress: 75.5,
            currentTask: "Painting Building Section A - Wall 3",
            lastSeen: Date(),
            status: DeviceStatus(
                cpuUsage: 45.2,
                batteryLevel: 87.0,
                memoryUsage: 62.3,
                storageUsage: 78.5,
                temperature: 32.1,
                networkStatus: DeviceStatus.NetworkStatus(
                    isConnected: true,
                    signalStrength: 85.0,
                    downloadSpeed: 125.5,
                    uploadSpeed: 45.2
                ),
                uptime: 3600 * 24 * 3
            )
        ))
    }
}

struct WorkProgressView: View {
    let device: Device
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Work Progress")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 8, height: 8)
                    
                    Text("Working")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Current Task:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                
                if let currentTask = device.currentTask {
                    Text(currentTask)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                HStack {
                    Text("Progress:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", device.workProgress))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: max(0, CGFloat(device.workProgress / 100) * geometry.size.width), height: 12)
                            .animation(.easeInOut(duration: 1.0), value: device.workProgress)
                    }
                }
                .frame(height: 12)
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
    }
}
