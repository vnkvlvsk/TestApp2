import UIKit

extension UIViewController {
    func showAlertError(title: String = "Error", errorDescription: String) {
        let alertController = UIAlertController(title: title, message: errorDescription, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
