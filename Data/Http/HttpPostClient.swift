import Foundation

public protocol HttpPostClient {
    func post(
        to: URL,
        with: Data?,
        completion: @escaping (Result<Data, HttpError>) -> Void
    )
}
