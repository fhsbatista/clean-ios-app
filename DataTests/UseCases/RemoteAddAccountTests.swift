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
        expect(
            sut,
            completeWith: .failure(.unexpected),
            when: { httpClientSpy.completeWithError(HttpError.noConnection) }
        )
    }
    
    func test_add_should_complete_with_account_if_http_client_succeeds() throws {
        let (sut, httpClientSpy) = makeSut()
        let expectedAccount = makeAccountEntity()
        expect(
            sut,
            completeWith: .success(expectedAccount),
            when: { httpClientSpy.completeWithData(expectedAccount.toData()!) }
        )
    }
    
    func test_add_should_complete_with_error_if_http_client_succeeds_but_with_invalid_data() throws {
        let (sut, httpClientSpy) = makeSut()
        expect(
            sut,
            completeWith: .failure(.unexpected),
            when: { httpClientSpy.completeWithData(makeInvalidData()) }
        )
    }
    
    func test_add_should_not_complete_if_sut_has_been_dealocated() throws {
        let url = URL(string: "https://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccount? = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        var result: Result<AccountEntity, DomainError>?
        sut?.add(account: makeAddAccountDTO()) { result = $0 }
        sut = nil
        httpClientSpy.completeWithError(.noConnection)
        XCTAssertNil(result)
    }
    
}

extension RemoteAddAccountTests {
    func makeSut(
        url: URL = URL(string: "https://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteAddAccount,httpClientSpy: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    func expect(
        _ sut: RemoteAddAccount,
        completeWith expectedResult: Result<AccountEntity, DomainError>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "waiting")
        sut.add(account: makeAddAccountDTO()) { receivedResult in
            switch (expectedResult,  receivedResult) {
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)):
                XCTAssertEqual(receivedAccount, expectedAccount, file: file, line: line)
            default: XCTFail(
                "Expected was \(expectedResult), but received \(receivedResult) instead",
                file: file,
                line: line
            )
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
    
    func makeAddAccountDTO() -> AddAccountDTO {
        return AddAccountDTO(
            name: "any_name",
            email: "any_email",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
    }
}
