import UIKit
import Photos

class PhotoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("PhotoViewController viewDidLoad 被呼叫了")

        checkPhotoLibraryPermission()
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        print("當前相簿訪問權限狀態: \(status.rawValue)")
        
        switch status {
        case .authorized:
            print("PhotoViewController 相簿訪問權限已授權")
            showPhotoPicker()
        case .denied:
            print("PhotoViewController 相簿訪問權限被拒絕")
            showSettingsAlert()
        case .restricted:
            print("PhotoViewController 相簿訪問權限受限制")
            showSettingsAlert()
        case .notDetermined:
            print("PhotoViewController 相簿訪問權限尚未確定")
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        print("PhotoViewController 用戶授予了相簿訪問權限")
                        self?.showPhotoPicker()
                    } else {
                        print("PhotoViewController 用戶未授予相簿訪問權限。狀態: \(status.rawValue)")
                        self?.showSettingsAlert()
                    }
                }
            }
        case .limited:
            print("PhotoViewController 相簿訪問權限受限")
            showPhotoPicker()
        @unknown default:
            print("PhotoViewController 未知的權限狀態: \(status.rawValue)")
        }
    }
    
    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "需要相簿訪問權限",
            message: "此應用需要訪問您的相簿。請在設置中啟用相簿訪問權限。",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "開啟設置", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        present(alert, animated: true, completion: nil)
    }
    
    func showPhotoPicker() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            print("PhotoViewController 成功選擇了照片")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("PhotoViewController 用戶取消了照片選擇")
        picker.dismiss(animated: true, completion: nil)
    }
}

