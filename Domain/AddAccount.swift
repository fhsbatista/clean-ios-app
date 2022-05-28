import Foundation

public protocol AddAccount {
    func add(
        data: AddAccountDTO,
        completion: @escaping (Result<AccountEntity, Error>) -> Void
    )
}

public struct AddAccountDTO: Encodable {
    public var name: String
    public var email: String
    public var password: String
    public var passwordConfirmation: String
    
    public init(
        name: String,
        email: String,
        password: String,
        passwordConfirmation: String
    ) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}
