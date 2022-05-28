import Foundation

public protocol HttpPostClient {
    func post(to: URL, with: Data?)
}
