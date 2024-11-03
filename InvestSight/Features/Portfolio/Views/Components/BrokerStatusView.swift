import SwiftUI

struct BrokerStatusView: View {
    let isConnected: Bool
    
    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .frame(width: 40, height: 40)
            .overlay {
                Image(systemName: "building.columns.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(12)
                    .foregroundColor(.primary)
            }
    }
}

#Preview {
    BrokerStatusView(isConnected: true)
}
