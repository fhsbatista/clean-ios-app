import Foundation

public protocol HttpPostClient {
    func post(
        to: URL,
        with: Data?,
        completion: @escaping (HttpError) -> Void
    )
}
