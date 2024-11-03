import SwiftUI

struct PortfolioToolbar: ToolbarContent {
    @Binding var showSettings: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text("Portfolio")
                .font(.headline)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
            }
        }
    }
}
