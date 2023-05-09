//
//  ViewController.swift
//  Mentor's Joy
//
//  Created by Ольга on 20.04.2023.
//

import UIKit

class SignInViewController: UIViewController {
    
    let startLabel = UILabel()
    let regButton = UIButton()
    let enterButton = UIButton()
    let authorization = UIView()
    let registration = UIView()
    let finalRegButton = UIButton()
    
    var nickAuth = UITextView()
    var passAuth = UITextView()
    
    var mailText = UITextView()
    var nickText = UITextView()
    var passText = UITextView()
    var nameText = UITextView()
    var secNameText = UITextView()
    var lastNameText = UITextView()
    var stateText = UITextView()
    
    public let errorText = UILabel()
    let errorText2 = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        view.addSubview(startLabel)
        startLabel.font = .systemFont(ofSize: 40, weight: .semibold)
        startLabel.text = "Авторизация"
        startLabel.textColor = .white
        startLabel.pinCenterX(to: view.centerXAnchor)
        startLabel.pinTop(to: view.topAnchor, 217)
                
        authorizeWindow()
        registrationWinow()
    }
    
    private func makeField(title: String, height: Int, text: UITextView) -> UIView {
        let tempView = UIView()
        tempView.setWidth(to: 330)
        tempView.setHeight(to: 66)
        
        let name = UILabel()
        name.font = .systemFont(ofSize: 20, weight: .semibold)
        name.text = title
        name.textColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        
        tempView.addSubview(name)
        
        text.setHeight(to: height)
        text.setWidth(to: 330)
        text.textAlignment = .natural
        text.backgroundColor = UIColor(red: 214/255, green: 228/255, blue: 1, alpha: 1)
        text.layer.cornerRadius = 15
        text.textColor = .black
        text.font = .systemFont(ofSize: 20, weight: .regular)
        
        tempView.addSubview(text)
        name.pinTop(to: tempView.topAnchor)
        text.pinTop(to: name.bottomAnchor, 1)
        name.leftAnchor.constraint(equalTo: text.leftAnchor, constant: 15).isActive = true
        text.pinCenterX(to: tempView.centerXAnchor)
        text.leftAnchor.constraint(equalTo: tempView.leftAnchor, constant: 15).isActive = true
        return tempView
    }
    
    private func authorizeWindow() {
        authorization.layer.cornerRadius = 30
        authorization.backgroundColor = .white
        self.view.addSubview(authorization)
        authorization.pinCenterX(to: view.centerXAnchor)
        authorization.pinCenterY(to: view.centerYAnchor)
        authorization.setHeight(to: 300)
        authorization.setWidth(to: 350)
        
        let fields = [makeField(title: "Никнейм*", height: 45, text: nickAuth), makeField(title: "Пароль*", height: 45, text: passAuth)]
        let strokeSV = UIStackView(arrangedSubviews: fields)
        strokeSV.setWidth(to: 330)
        
        strokeSV.axis = .vertical
        strokeSV.alignment = .center
        strokeSV.spacing = 16
        strokeSV.distribution = .fillEqually
        
        authorization.addSubview(strokeSV)
        strokeSV.pinTop(to: authorization.topAnchor, 11)
        strokeSV.pinCenterX(to: authorization.centerXAnchor)
        
        setRegButton()
        setEnterButton()
        regButton.addTarget(self, action: #selector(regButtonPressed), for: .touchUpInside)
        enterButton.addTarget(self, action: #selector(enterButtonPressed), for: .touchUpInside)
        let buttonsSV = UIStackView(arrangedSubviews: [enterButton, regButton])
        buttonsSV.axis = .horizontal
        buttonsSV.alignment = .center
        buttonsSV.spacing = 15
        buttonsSV.distribution = .fill
        
        authorization.addSubview(buttonsSV)
        buttonsSV.pinCenterX(to: authorization.centerXAnchor)
        buttonsSV.bottomAnchor.constraint(equalTo: authorization.bottomAnchor, constant: -13).isActive = true
        
        authorization.addSubview(errorText)
        errorText.font = .systemFont(ofSize: 20, weight: .semibold)
        errorText.text = "Неверные логин или пароль"
        errorText.textColor = .red
        errorText.pinCenterX(to: authorization.centerXAnchor)
        errorText.bottomAnchor.constraint(equalTo: regButton.topAnchor, constant: -16).isActive = true
        errorText.isHidden = true
        
    }
    
    private func registrationWinow() {
        registration.isHidden = true
        registration.layer.cornerRadius = 30
        registration.backgroundColor = .white
        self.view.addSubview(registration)
        registration.pinCenterX(to: view.centerXAnchor)
        registration.pinCenterY(to: view.centerYAnchor, 65)
        registration.setHeight(to: 666)
        registration.setWidth(to: 350)
        
        let fields = [makeField(title: "Никнейм*", height: 45, text: nickText),
                      makeField(title: "Почта*", height: 45, text: mailText),
                      makeField(title: "Пароль*", height: 45, text: passText),
                      makeField(title: "Имя*", height: 45, text: nameText),
                      makeField(title: "Фамилия*", height: 45, text: secNameText),
                      makeField(title: "Отчество", height: 45, text: lastNameText),
                      makeField(title: "Статус*", height: 45, text: stateText)]
        let strokeSV = UIStackView(arrangedSubviews: fields)
        
        strokeSV.axis = .vertical
        strokeSV.alignment = .center
        strokeSV.spacing = 16
        strokeSV.distribution = .fill
        
        registration.addSubview(strokeSV)
        strokeSV.pinTop(to: registration.topAnchor, 11)
        strokeSV.pinCenterX(to: registration.centerXAnchor)
        
        setFinRegButton()
        finalRegButton.addTarget(self, action: #selector(finRegButtonPressed), for: .touchUpInside)
        
        let buttonsSV = UIStackView(arrangedSubviews: [finalRegButton])
        buttonsSV.axis = .horizontal
        buttonsSV.alignment = .center
        buttonsSV.spacing = 15
        buttonsSV.distribution = .fill
        
        registration.addSubview(buttonsSV)
        buttonsSV.pinCenterX(to: registration.centerXAnchor)
        buttonsSV.bottomAnchor.constraint(equalTo: registration.bottomAnchor, constant: -13).isActive = true
        
        registration.addSubview(errorText2)
        errorText2.setHeight(to: 44)
        errorText2.setWidth(to: 350)
        errorText2.font = .systemFont(ofSize: 20, weight: .semibold)
        errorText2.text = "Введенные данные некорректные,\nили в пароле менее 6 символов"
        errorText2.textColor = .red
        errorText2.pinCenterX(to: authorization.centerXAnchor)
        errorText2.bottomAnchor.constraint(equalTo: finalRegButton.topAnchor, constant: -16).isActive = true
        errorText2.isHidden = true
        
    }
    
    private func setRegButton() {
        regButton.setTitle("Регистрация", for: .normal)
        regButton.setTitleColor(.white, for: .normal)
        regButton.layer.cornerRadius = 15
        regButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        regButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        regButton.setWidth(to: 150)
        regButton.setHeight(to: 45)
    }
    
    private func setEnterButton() {
        enterButton.setTitle("Войти", for: .normal)
        enterButton.setTitleColor(.white, for: .normal)
        enterButton.layer.cornerRadius = 15
        enterButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        enterButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        enterButton.setWidth(to: 150)
        enterButton.setHeight(to: 45)
    }
    
    private func setFinRegButton() {
        finalRegButton.setTitle("Зарегестрироваться", for: .normal)
        finalRegButton.setTitleColor(.white, for: .normal)
        finalRegButton.layer.cornerRadius = 15
        finalRegButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        finalRegButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        finalRegButton.setWidth(to: 300)
        finalRegButton.setHeight(to: 45)
    }
    
    @objc
    private func regButtonPressed() {
        UIView.animate(withDuration: 0.2, delay: 0.07, animations: {
            self.regButton.backgroundColor = UIColor(red: 62/255, green: 103/255, blue: 182/255, alpha: 1)
        })
        UIView.animate(withDuration: 0.1, animations: {
            self.errorText.isHidden = true
            self.startLabel.text = "Регистрация"
            self.startLabel.pinTop(to: self.view.topAnchor, 135)
            self.authorization.isHidden = true
            self.registration.isHidden = !self.registration.isHidden
            self.regButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        })
    }
    
    @objc
    private func finRegButtonPressed() {
        UIView.animate(withDuration: 0.2, delay: 0.07, animations: {
            self.finalRegButton.backgroundColor = UIColor(red: 62/255, green: 103/255, blue: 182/255, alpha: 1)
        })
        if mailText.text == "" || nickText.text == "" || passText.text == "" || stateText.text == ""
            || nameText.text == "" || secNameText.text == "" {
            errorText2.isHidden = false
        } else {
            var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/auth/signup")!)
            let params: [String: Any] = ["username": nickText.text!,
                                         "email": mailText.text!,
                                         "password": passText.text!,
                                         "person": [
                                            "firstname": nameText.text!,
                                            "surname": secNameText.text!,
                                            "lastname": lastNameText.text!,
                                            "status": stateText.text!
                                         ]]
            let body = try? JSONSerialization.data(withJSONObject: params)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            request.httpBody = body
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let joke = try? JSONDecoder().decode(UserData.self, from: data) {
                    if (joke.status == 401) {
                        DispatchQueue.main.async {
                            print(joke.message!)
                            self.errorText2.isHidden = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 5, animations: {
                                self.errorText2.text = "Регистрация прошла успешно"
                                self.errorText2.textColor = .blue
                                self.errorText2.isHidden = false
                                self.registration.isHidden = true
                                self.authorization.isHidden = false
                                self.startLabel.text = "Авторизация"
                            })
                        }
                    }
                }
            }
            task.resume()
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.finalRegButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        })
    }
    
    
    @objc
    private func enterButtonPressed() {
        UIView.animate(withDuration: 0.2, delay: 0.07, animations: {
            self.enterButton.backgroundColor = UIColor(red: 62/255, green: 103/255, blue: 182/255, alpha: 1)
        })
        
        if nickAuth.text == "" || passAuth.text == "" {
            errorText.isHidden = false
        } else {
            var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/auth/signin")!)
            let params: [String: String] = ["username": nickAuth.text,
                                         "password": passAuth.text]
            let body = try? JSONSerialization.data(withJSONObject: params)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            request.httpBody = body
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let joke = try? JSONDecoder().decode(UserData.self, from: data) {
                    if (joke.status == 401) {
                        DispatchQueue.main.async {
                            self.errorText.isHidden = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorText.isHidden = true
                            let templates = TemplatesViewComtroller(accessToken: joke.accessToken!, tokenType: joke.tokenType!)
                            self.navigationController?.pushViewController(templates, animated: false)
                        }
                    }
                }
            }
            task.resume()
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.enterButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
            self.registration.isHidden = true
        })
    }
}

