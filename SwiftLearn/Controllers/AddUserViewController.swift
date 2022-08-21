import UIKit

class AddUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var avatar: UIImage?

    private var viewModel = CreateUserViewModel()

    lazy var avatarPlaceHolder: UIImageView = {
        let image = UIImage(systemName: "person.crop.circle.fill.badge.plus")
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    lazy var avatarPlaceHolderContainer: UIView = {
        let v = UIView()
        v.heightAnchor.constraint(equalToConstant: 100).isActive = true
        v.translatesAutoresizingMaskIntoConstraints = true
        return v
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "UIStackView inside UIScrollView."
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    lazy var emailField: UITextField = {
        let ef = UITextField()
        ef.translatesAutoresizingMaskIntoConstraints = false
        ef.backgroundColor = .white
        ef.placeholder = "Enter Email"
        ef.font = UIFont.systemFont(ofSize: 15)
        ef.borderStyle = UITextField.BorderStyle.roundedRect
        ef.autocorrectionType = UITextAutocorrectionType.no
        ef.keyboardType = UIKeyboardType.default
        ef.returnKeyType = UIReturnKeyType.done
        ef.clearButtonMode = UITextField.ViewMode.whileEditing
        ef.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return ef
    }()

    lazy var nameField: UITextField = {
        let nf = UITextField()
        nf.translatesAutoresizingMaskIntoConstraints = false
        nf.backgroundColor = .white
        nf.placeholder = "Enter Name"
        nf.font = UIFont.systemFont(ofSize: 15)
        nf.borderStyle = UITextField.BorderStyle.roundedRect
        nf.autocorrectionType = UITextAutocorrectionType.no
        nf.keyboardType = UIKeyboardType.default
        nf.returnKeyType = UIReturnKeyType.done
        nf.clearButtonMode = UITextField.ViewMode.whileEditing
        nf.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return nf
    }()

    lazy var saveButton: UIButton = {
        let sb = UIButton()
        sb.backgroundColor = .systemBlue
        sb.setTitle("Create User", for: .normal)
        sb.addTarget(self, action: #selector(onClickSave), for: .touchUpInside)
        return sb
    }()

    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .onDrag
        return view
    }()

    lazy var scrollStackViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Add User"
        setupScrollView()
        setupKeyboardNotifications()
        setUpAvatarPlaceholder()
    }

    private func setupScrollView() {
        let margins = view.layoutMarginsGuide
        view.addSubview(scrollView)
        scrollView.addSubview(scrollStackViewContainer)

        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        scrollStackViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollStackViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollStackViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollStackViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollStackViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        configureContainerView()
    }

    private func configureContainerView() {
        avatarPlaceHolderContainer.addSubview(avatarPlaceHolder)
        scrollStackViewContainer.addArrangedSubview(avatarPlaceHolderContainer)
        NSLayoutConstraint.activate([
            NSLayoutConstraint.init(item: avatarPlaceHolder, attribute: .centerX, relatedBy: .equal, toItem: avatarPlaceHolderContainer, attribute: .centerX, multiplier: 1, constant: 0)
        ])
        scrollStackViewContainer.addArrangedSubview(nameField)
        scrollStackViewContainer.addArrangedSubview(emailField)
        scrollStackViewContainer.addArrangedSubview(saveButton)
    }

    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = value.cgRectValue
        scrollView.contentInset.bottom = keyboardFrame.height
    }

    @objc fileprivate func handleKeyboardHide() {
        scrollView.contentInset.bottom = 0
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: scrollView.scrollIndicatorInsets.top, left: scrollView.scrollIndicatorInsets.left, bottom: 0, right: scrollView.scrollIndicatorInsets.right)
    }

    private func setUpAvatarPlaceholder() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapAvatar(tapGestureRecognizer:)))
        avatarPlaceHolder.isUserInteractionEnabled = true
        avatarPlaceHolder.addGestureRecognizer(tapGestureRecognizer)
    }

    private func roundAvatar() {
        avatarPlaceHolder.layer.cornerRadius = avatarPlaceHolder.frame.height * 0.5
        avatarPlaceHolder.contentMode = .scaleAspectFill
        avatarPlaceHolder.layer.masksToBounds = true
    }

    @objc func onTapAvatar(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.alpha = 0.5
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(myPickerController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tappedImage.alpha = 1.0
        }
    }

    @objc func onClickSave() {
        guard let avatar = avatar else {
            return
        }
        viewModel.createUser(image: avatar, name: (nameField.text ?? ""), email: (emailField.text ?? ""), viewController: self)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        avatarPlaceHolder.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        avatarPlaceHolder.backgroundColor = UIColor.clear
        roundAvatar()
        dismiss(animated: true, completion: nil)
        avatar = avatarPlaceHolder.image
    }


}
