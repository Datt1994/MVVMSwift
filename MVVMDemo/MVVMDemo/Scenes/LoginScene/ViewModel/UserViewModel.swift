

import Foundation
import RxSwift

enum UserValidationState {
    case valid
    case invalid(String)
}

class UserViewModel {
    private let minUsernameLength = 4
    private let minPasswordLength = 5
    private let codeRefreshTime = 3.0
    private var user = User()
    
    private let disposeBag = DisposeBag()
    
    var username = PublishSubject<String?>()
    var password = PublishSubject<String?>()
    
    var protectedUsername: String {
        let characters = user.username

        if characters.count >= minUsernameLength {
            var displayName = [Character]()
            for (index, character) in characters.enumerated() {
                if index > characters.count - minUsernameLength {
                    displayName.append(character)
                } else {
                    displayName.append("*")
                }
            }
            return String(displayName)
        }

        return characters
    }
    
    var accessCode = BehaviorSubject<String?>(value: LoginService.generateAccessCode())
    
    init(user: User = User()) {
        self.user = user
        username.onNext(user.username)
        password.onNext(user.password)
        setModelDataOnChange()
        startAccessCodeTimer()
    }
}

// MARK: Public Methods
extension UserViewModel {
    
    func validate() -> UserValidationState {
        if user.username.isEmpty || user.password.isEmpty {
            return .invalid("Username and password are required.")
        }
        
        if user.username.count < minUsernameLength {
            return .invalid("Username needs to be at least \(minUsernameLength) characters long.")
        }
        
        if user.password.count < minPasswordLength {
            return .invalid("Password needs to be at least \(minPasswordLength) characters long.")
        }
        
        return .valid
    }
    
    func login(completion: (_ errorString: String?) -> Void) {
        LoginService.loginWithUsername(user.username, password: user.password) { success in
            if success {
                completion(nil)
            } else {
                completion("Invalid credentials.")
            }
        }
    }
}

// MARK: - Private Methods
private extension UserViewModel {
    
    func setModelDataOnChange()  {
        
        username
            .subscribe(onNext: { [unowned self] in
                self.user.username = $0 ?? ""
            })
            .disposed(by: disposeBag)
        
        password
            .subscribe(onNext: { [unowned self] in
                self.user.password = $0 ?? ""
            })
            .disposed(by: disposeBag)
        
    }
    
    func startAccessCodeTimer() {
        accessCode.onNext(LoginService.generateAccessCode())
        
        dispatchAfter(codeRefreshTime) { [weak self] in 
            self?.startAccessCodeTimer()
        }
    }
}
