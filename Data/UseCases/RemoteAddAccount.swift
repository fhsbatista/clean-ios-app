import Foundation
import Domain

public final class RemoteAddAccount: AddAccount {
    private let url: URL
    private let httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(
        account: AddAccountDTO,
        completion: @escaping (Result<AccountEntity, DomainError>) -> Void
    ) {
        httpClient.post(to: url, with: account.toData()) { error in
            completion(.failure(.unexpected))
        }
        
    }
}
