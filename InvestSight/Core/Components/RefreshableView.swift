import SwiftUI

struct RefreshableView<Content: View>: View {
    let action: () async -> Void
    let content: () -> Content
    
    init(action: @escaping () async -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
    
    var body: some View {
        List {
            content()
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .refreshable {
            await action()
        }
    }
}
