import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    func test_add_should_call_http_client_with_correct_url() throws {
        let url = URL(string: "https://any-other-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.add(account: makeAddAccountDTO()) { _ in}
        XCTAssertEqual(httpClientSpy.url, url)
        XCTAssertEqual(httpClientSpy.callsCount, 1)
    }
    
    func test_add_should_call_http_client_with_correct_values() throws {
        let (sut, httpClientSpy) = makeSut()
        let account = makeAddAccountDTO()
        sut.add(account: account) { _ in}
        XCTAssertEqual(httpClientSpy.data, account.toData())
    }
    
    func test_add_should_complete_with_error_if_http_client_fails() throws {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.add(account: makeAddAccountDTO()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("An error was expected, but received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(HttpError.noConnection)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_account_if_http_client_succeeds() throws {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedAccount = makeAccountEntity()
        sut.add(account: makeAddAccountDTO()) { result in
        switch result {
            case .success(let account): XCTAssertEqual(account, expectedAccount)
            case .failure: XCTFail("Success was expected, but received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithData(expectedAccount.toData()!)
        wait(for: [exp], timeout: 1)
    }
    
    func test_add_should_complete_with_error_if_http_client_succeeds_but_with_invalid_data() throws {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.add(account: makeAddAccountDTO()) { result in
            switch result {
            case .failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("An error was expected, but received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithData(Data("invalid_data".utf8))
        wait(for: [exp], timeout: 1)
    }
    
}

extension RemoteAddAccountTests {
    func makeSut(url: URL = URL(string: "https://any-url.com")!) -> (
        sut: RemoteAddAccount,
        httpClientSpy: HttpClientSpy
    ) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    func makeAddAccountDTO() -> AddAccountDTO {
        return AddAccountDTO(
            name: "any_name",
            email: "any_email",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
    }
    
    func makeAccountEntity() -> AccountEntity {
        return AccountEntity(
            id: "any_id",
            name: "any_name",
            email: "any_email",
            password: "any_password"
        )
    }
    
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
}
