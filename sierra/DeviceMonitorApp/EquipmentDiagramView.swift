import SwiftUI

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct EquipmentDiagramView: View {
  let selectedDevice: Device?
  let showTitle: Bool
  
  init(selectedDevice: Device? = nil, showTitle: Bool = true) {
    self.selectedDevice = selectedDevice
    self.showTitle = showTitle
  }
  
  var body: some View {
    VStack(spacing: 20) {
      if showTitle {
        Text("Equipment Operation Diagram")
          .font(.title2)
          .fontWeight(.bold)
          .padding()
      }
            
      GeometryReader { geometry in
        let width = geometry.size.width
        let height = geometry.size.height
                
        ZStack {
          // Background sections
          HStack(spacing: 0) {
            // Painted Metal Section
            Rectangle()
              .fill(Color.gray.opacity(0.3))
              .overlay(
                VStack {
                  Spacer()
                  Text("PAINTED METAL")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                }
              )
                        
            // Bare Metal Section
            Rectangle()
              .fill(Color.blue.opacity(0.2))
              .overlay(
                VStack {
                  Spacer()
                  Text("BARE METAL")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                }
              )
                        
            // Unprepared Surface Section
            Rectangle()
              .fill(Color.brown.opacity(0.3))
              .overlay(
                VStack {
                  Spacer()
                  Text("UNPREPARED\nSURFACE")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                }
              )
          }
                    
          // Painter Equipment (top right)
          ZStack {
            Image("painter")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 120, height: 80)
              .blendMode(.multiply)
              .background(Color.clear)
            
            if let device = selectedDevice, device.type == .painter {
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.orange, lineWidth: 4)
                .frame(width: 130, height: 90)
                .shadow(color: .orange.opacity(0.5), radius: 8, x: 0, y: 0)
                .animation(.easeInOut(duration: 0.5), value: selectedDevice?.id)
            }
          }
          .position(x: width * 0.7, y: height * 0.3)
                    
          // Water Blaster Equipment (bottom left)
          ZStack {
            Image("water_blaster")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 100, height: 70)
              .blendMode(.multiply)
              .background(Color.clear)

            if let device = selectedDevice, device.type == .blaster {
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: 110, height: 80)
                .shadow(color: .blue.opacity(0.5), radius: 8, x: 0, y: 0)
                .animation(.easeInOut(duration: 0.5), value: selectedDevice?.id)
            }
          }
          .position(x: width * 0.25, y: height * 0.8)

          // Vision System Equipment (center)
          ZStack {
            Image("vision")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 110, height: 75)
              .blendMode(.multiply)
              .background(Color.clear)

            if let device = selectedDevice, device.type == .vision {
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.green, lineWidth: 4)
                .frame(width: 120, height: 85)
                .shadow(color: .green.opacity(0.5), radius: 8, x: 0, y: 0)
                .animation(.easeInOut(duration: 0.5), value: selectedDevice?.id)
            }
          }
          .position(x: width * 0.5, y: height * 0.45)

          // Work Area Indicators
          Circle()
            .fill(Color.red.opacity(0.3))
            .frame(width: 20, height: 20)
            .position(x: width * 0.2, y: height * 0.7)
                    
          Circle()
            .fill(Color.orange.opacity(0.3))
            .frame(width: 20, height: 20)
            .position(x: width * 0.5, y: height * 0.7)
                    
          Circle()
            .fill(Color.yellow.opacity(0.3))
            .frame(width: 20, height: 20)
            .position(x: width * 0.8, y: height * 0.7)
        }
      }
      .frame(height: 300)
      .border(Color.gray, width: 1)
    }
    .if(showTitle) { view in
      view
        .navigationTitle("Equipment Diagram")
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  EquipmentDiagramView()
}
