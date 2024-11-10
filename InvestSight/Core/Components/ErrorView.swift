import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Error loading portfolio")
                .font(.headline)
            Text(error.localizedDescription)
                .foregroundColor(.red)
            Button("Retry", action: retryAction)
                .padding()
        }
    }
}
