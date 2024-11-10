import Foundation

protocol DateProviding {
    var now: Date { get }
}

struct LiveDateProvider: DateProviding {
    var now: Date { Date() }
}

struct MockDateProvider: DateProviding {
    let staticDate: Date
    var now: Date { staticDate }
}
