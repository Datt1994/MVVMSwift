
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var topVaultView: UIView!
    @IBOutlet weak var bottomVaultView: UIView!
    @IBOutlet weak var lockView: UIImageView!

    private let disposeBag = DisposeBag()
    private var viewModel = UserViewModel()
    
    var loginSuccess: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindUI()
        updateUI()
        
    }
    
    func bindUI() {
        
        usernameField.rx.text.bind(to: viewModel.username).disposed(by: disposeBag)
        passwordField.rx.text.bind(to: viewModel.password).disposed(by: disposeBag)
        
    }
    
    func updateUI() {
        
        viewModel.accessCode
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.codeLabel.text = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.username
            .filter({($0?.count ?? 0) > 5})
            .subscribe(onNext: {
                debugPrint("username--- \($0 ?? "")")
            })
            .disposed(by: disposeBag)
        
        viewModel.password
            .filter({($0?.count ?? 0) > 3})
            .subscribe(onNext: {
                debugPrint("password--- " + ($0 ?? ""))
            })
            .disposed(by: disposeBag)
        
    }
    deinit {
        debugPrint("deinit :- " + String(describing: LoginViewController.self))
    }
}

// MARK: Actions
extension LoginViewController {
    @IBAction func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func authenticate() {
        dismissKeyboard()
        
        switch viewModel.validate() {
        case .valid:
            viewModel.login() { errorMessage in
                if let errorMessage = errorMessage {
                    self.displayErrorMessage(errorMessage)
                } else {
                    self.loginSuccess?()
                }
            }
        case .invalid(let error):
            displayErrorMessage(error)
        }
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameField {
            textField.text = viewModel.protectedUsername
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            passwordField.becomeFirstResponder()
        } else {
            authenticate()
        }
        
        return true
    }
    
}

// MARK: Private Methods
private extension LoginViewController {
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
