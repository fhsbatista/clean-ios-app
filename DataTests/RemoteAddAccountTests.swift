import XCTest
import Domain

class RemoteAddAccount {
    private let url: URL
    private let httpClient: HttpPostClient
    
    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(data: AddAccountDTO) {
        let data = try? JSONEncoder().encode(data)
        httpClient.post(to: url, with: data)
    }
}

protocol HttpPostClient {
    func post(to: URL, with: Data?)
}

class RemoteAddAccountTests: XCTestCase {
    func test_add_should_call_http_client_with_correct_url() throws {
        let url = URL(string: "https://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: url, httpClient: httpClientSpy)
        let dto = AddAccountDTO(
            name: "any_name",
            email: "any_email",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
        sut.add(data: dto)
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_should_call_http_client_with_correct_values() throws {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccount(url: URL(string: "https://any-url.com")!, httpClient: httpClientSpy)
        let dto = AddAccountDTO(
            name: "any_name",
            email: "any_email",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
        sut.add(data: dto)
        let data = try? JSONEncoder().encode(dto)
        XCTAssertEqual(httpClientSpy.data, data)
    }
}

extension RemoteAddAccountTests {
    class HttpClientSpy: HttpPostClient {
        var url: URL?
        var data: Data?
        
        func post(to url: URL, with data: Data?) {
            self.url = url
            self.data = data
        }
    }
}
