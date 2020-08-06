
import XCTest
@testable import MVVMDemo
@testable import RxSwift

class LoginTests: XCTestCase {
    
    var validUserViewModel: UserViewModel!
    var invalidUserViewModel: UserViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let user = User(username: "dattpatel", password: "swift")
        validUserViewModel = UserViewModel(user: user)
        
        invalidUserViewModel = UserViewModel()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testUsername() {
        validUserViewModel.username.subscribe(onNext: {
            XCTAssertEqual($0, "dattpatel")
        }).disposed(by: disposeBag)
        validUserViewModel.username.onNext("dattpatel")
    }
    
    func testPassword() {
        validUserViewModel.password.subscribe(onNext: {
            XCTAssertEqual($0, "swift")
        }).disposed(by: disposeBag)
        validUserViewModel.username.onNext("swift")
    }
    
    func testProtectedUsernameLong() {
        XCTAssertEqual(validUserViewModel.protectedUsername, "******tel")
    }
    
    func testProtectedUsernameShort() {
        validUserViewModel = UserViewModel(user: User(username: "dp", password: "swift"))
        XCTAssertEqual(validUserViewModel.protectedUsername, "dp")
    }
    
    
    func testValidateNoUserOrPassword() {
        let validation = invalidUserViewModel.validate()
        
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Username and password are required.")
        } else {
            XCTAssert(false)
        }
    }
    
    func testValidateNoPassword() {
        invalidUserViewModel = UserViewModel(user: User(username: "dattpatel", password: ""))
        let validation = invalidUserViewModel.validate()
        
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Username and password are required.")
        } else {
            XCTAssert(false)
        }
    }
    
    func testValidateShortUsername() {
        invalidUserViewModel = UserViewModel(user: User(username: "dp", password: "swift"))
        let validation = invalidUserViewModel.validate()
        
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Username needs to be at least 4 characters long.")
        } else {
            XCTAssert(false)
        }
    }
    
    func testValidateShortPassword() {
        invalidUserViewModel = UserViewModel(user: User(username: "dattpatel", password: "sw"))
        let validation = invalidUserViewModel.validate()
        
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Password needs to be at least 5 characters long.")
        } else {
            XCTAssert(false)
        }
    }
    
    func testValidateValidUser() {
        let validation = validUserViewModel.validate()
        
        if case .valid = validation {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }
    
    func testLoginSuccess() {
        validUserViewModel.login { errorString in
            XCTAssert(errorString == nil)
        }
    }
    
    func testLoginFailure() {
        invalidUserViewModel.login { errorString in
            XCTAssertEqual(errorString, "Invalid credentials.")
        }
    }
}

