import Foundation

protocol AddAccount {
    func add(
        data: AddAccountDTO,
        completion: @escaping (Result<AccountEntity, Error>) -> Void
    )
}

struct AddAccountDTO {
    var name: String
    var email: String
    var password: String
    var passwordConfirmation: String
}
