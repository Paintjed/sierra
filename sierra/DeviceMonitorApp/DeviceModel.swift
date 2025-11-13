import Foundation
import SwiftUI

struct Device: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var type: DeviceType
    var isOnline: Bool
    var isWorking: Bool
    var workProgress: Double // 0-100 (percentage of current task completion)
    var currentTask: String? // Description of current task
    var lastSeen: Date
    var status: DeviceStatus
    
    enum DeviceType: String, CaseIterable {
        case painter = "Painter"
        case blaster = "Water Blaster"
        case vision = "Vision System"

        var icon: String {
            switch self {
            case .painter: return "painter"
            case .blaster: return "water_blaster"
            case .vision: return "vision"
            }
        }
    }
}

struct DeviceStatus: Equatable, Hashable {
    var cpuUsage: Double // 0-100
    var batteryLevel: Double // 0-100
    var memoryUsage: Double // 0-100
    var storageUsage: Double // 0-100
    var temperature: Double // celsius
    var networkStatus: NetworkStatus
    var uptime: TimeInterval
    
    struct NetworkStatus: Equatable, Hashable {
        var isConnected: Bool
        var signalStrength: Double // 0-100
        var downloadSpeed: Double // Mbps
        var uploadSpeed: Double // Mbps
    }
}

class DeviceStatusManager: ObservableObject {
    @Published var devices: [Device] = []
    @Published var selectedDevice: Device?
    
    private var timer: Timer?
    
    init() {
        setupSampleData()
        startStatusUpdates()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func setupSampleData() {
        devices = [
            Device(
                name: "Painter",
                type: .painter,
                isOnline: true,
                isWorking: true,
                workProgress: 67.5,
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
            ),
            Device(
                name: "Blaster",
                type: .blaster,
                isOnline: true,
                isWorking: true,
                workProgress: 42.3,
                currentTask: "Cleaning Exterior Wall Section B",
                lastSeen: Date(),
                status: DeviceStatus(
                    cpuUsage: 68.4,
                    batteryLevel: 65.0,
                    memoryUsage: 81.2,
                    storageUsage: 42.1,
                    temperature: 38.3,
                    networkStatus: DeviceStatus.NetworkStatus(
                        isConnected: true,
                        signalStrength: 88.0,
                        downloadSpeed: 356.2,
                        uploadSpeed: 89.7
                    ),
                    uptime: 3600 * 24 * 2
                )
            ),
            Device(
                name: "Vision",
                type: .vision,
                isOnline: true,
                isWorking: true,
                workProgress: 28.7,
                currentTask: "Scanning Building Structure - Floor 2",
                lastSeen: Date(),
                status: DeviceStatus(
                    cpuUsage: 72.5,
                    batteryLevel: 91.0,
                    memoryUsage: 85.4,
                    storageUsage: 67.8,
                    temperature: 35.6,
                    networkStatus: DeviceStatus.NetworkStatus(
                        isConnected: true,
                        signalStrength: 92.0,
                        downloadSpeed: 428.3,
                        uploadSpeed: 156.4
                    ),
                    uptime: 3600 * 24 * 5
                )
            ),
        ]
        
        selectedDevice = devices.first
    }
    
    private func startStatusUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.updateDeviceStatuses()
        }
    }
    
    private func updateDeviceStatuses() {
        for index in devices.indices {
            var device = devices[index]
            
            if device.isOnline {
                device.status.cpuUsage = max(0, min(100, device.status.cpuUsage + Double.random(in: -5...5)))
                device.status.memoryUsage = max(0, min(100, device.status.memoryUsage + Double.random(in: -3...3)))
                
                device.status.batteryLevel = max(0, min(100, device.status.batteryLevel + Double.random(in: -0.5...0.1)))
                
                device.status.temperature = max(0, device.status.temperature + Double.random(in: -2...2))
                device.status.networkStatus.downloadSpeed = max(0, device.status.networkStatus.downloadSpeed + Double.random(in: -20...20))
                device.status.networkStatus.uploadSpeed = max(0, device.status.networkStatus.uploadSpeed + Double.random(in: -10...10))
                
                device.lastSeen = Date()
                device.status.uptime += 2.0
                
                // Update work progress for working devices
                if device.isWorking {
                    let progressIncrement = Double.random(in: 0.1...1.5)
                    device.workProgress = min(100.0, device.workProgress + progressIncrement)
                    
                    // Complete task when reaching 100%
                    if device.workProgress >= 100.0 {
                        device.isWorking = false
                        device.workProgress = 0.0
                        device.currentTask = nil
                    }
                } else if Double.random(in: 0...1) < 0.05 { // 5% chance to start new task
                    device.isWorking = true
                    device.workProgress = 0.0
                    
                    // Assign random task based on device type
                    switch device.type {
                    case .painter:
                        let tasks = [
                            "Painting Building Section A - Wall 1",
                            "Painting Building Section A - Wall 2",
                            "Painting Building Section B - Wall 1",
                            "Painting Building Section B - Wall 2",
                            "Painting Interior Room 101",
                            "Painting Interior Room 102",
                            "Painting Exterior Facade - North",
                            "Painting Exterior Facade - South"
                        ]
                        device.currentTask = tasks.randomElement()
                    case .blaster:
                        let tasks = [
                            "Cleaning Exterior Wall Section A",
                            "Cleaning Exterior Wall Section B",
                            "Cleaning Exterior Wall Section C",
                            "Cleaning Roof Section 1",
                            "Cleaning Roof Section 2",
                            "Cleaning Windows - Floor 1",
                            "Cleaning Windows - Floor 2",
                            "Pressure Washing Parking Area"
                        ]
                        device.currentTask = tasks.randomElement()
                    case .vision:
                        let tasks = [
                            "Scanning Building Structure - Floor 1",
                            "Scanning Building Structure - Floor 2",
                            "Scanning Building Structure - Floor 3",
                            "Inspecting Wall Quality - Section A",
                            "Inspecting Wall Quality - Section B",
                            "Detecting Surface Defects - North Wall",
                            "Detecting Surface Defects - South Wall",
                            "3D Mapping Construction Site",
                            "Monitoring Work Progress - Zone A",
                            "Analyzing Structural Integrity"
                        ]
                        device.currentTask = tasks.randomElement()
                    }
                }
            }
            
            devices[index] = device
        }
        
        if let selectedId = selectedDevice?.id,
           let updatedDevice = devices.first(where: { $0.id == selectedId }) {
            selectedDevice = updatedDevice
        }
    }
    
    func selectDevice(_ device: Device) {
        selectedDevice = device
    }
}
