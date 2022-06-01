import Foundation
import Data

class HttpClientSpy: HttpPostClient {
    var url: URL?
    var data: Data?
    var completion: ((Result<Data, HttpError>) -> Void)?
    var callsCount = 0
    
    func post(
        to url: URL,
        with data: Data?,
        completion: @escaping (Result<Data, HttpError>) -> Void
    ) {
        self.url = url
        self.data = data
        self.completion = completion
        self.callsCount += 1
    }
    
    func completeWithError(_ error: HttpError) {
        completion?(.failure(error))
    }
    
    func completeWithData(_ data: Data) {
        completion?(.success(data))
    }
}
