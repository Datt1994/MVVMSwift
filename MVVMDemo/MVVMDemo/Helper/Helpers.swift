
import Foundation

func dispatchAfter(_ seconds: Double, block: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        block()
    }
}
