import SwiftUI

struct RefreshableView<Content: View>: View {
    let action: () async -> Void
    let content: () -> Content
    @State private var isRefreshing = false
    @State private var scrollViewHeight: CGFloat = 0
    @State private var contentOffset: CGFloat = 0
    
    init(action: @escaping () async -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.action = action
        self.content = content
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .named("scroll")).minY
                Color.clear
                    .preference(key: ScrollOffsetPreferenceKey.self, value: offset)
                    .onAppear {
                        scrollViewHeight = geometry.size.height
                    }
            }
            .frame(height: 0)
            
            content()
                .overlay(alignment: .top) {
                    if isRefreshing {
                        ProgressView()
                            .padding()
                    }
                }
        }
        .coordinateSpace(name: "scroll")
        .scrollIndicators(.hidden)
        .refreshable {
            isRefreshing = true
            await action()
            isRefreshing = false
        }
    }
}
