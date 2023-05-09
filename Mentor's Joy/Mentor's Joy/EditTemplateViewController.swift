//
//  EditTemplateViewController.swift
//  Mentor's Joy
//
//  Created by Ольга on 05.05.2023.
//

import Foundation
import UIKit

final class EditTemplateViewController: UIViewController {
    private var tokenType, accessToken: String
    private var facID = 0
    private var depID = 0
    private var clazCode = ""
    private var clasID = 0
    private var clasCode = ""
    private var facInd = 0
    private var codeInd = 0
    private var classDesc = ""
    
    private var facName = ""
    private var dep = ""
    private var templ: TemplateDatum
    
    private var scroll = UIScrollView()
    private var stack = UIStackView()
    private var template = TemplateData()
    private var name = UILabel()
    private var saveButton = UIButton()
    private var ind = 0
    
    private var teacherName = UITextView()
    private var teacherSecName = UITextView()
    private var teacherLastName = UITextView()
    private var teacherStatus = UITextView()
    private var headTeacherName = UITextView()
    private var headTeacherSecName = UITextView()
    private var headTeacherLastName = UITextView()
    private var headTeacherStatus = UITextView()
    private var faculcy = UIPickerView()
    private var year = UITextView()
    private var progName = UITextView()
    private var progShortName = UITextView()
    private var progEngName = UITextView()
    private var descript = UITextView()
    
    private var claz = UIPickerView()
    private var depart = UIPickerView()
    private var clas = UIPickerView()
    
    private var facs: Faculties {
        didSet {
            setupFaculties()
        }
    }
    
    private var codes: Codes {
        didSet {
            setupCodes()
            
        }
    }
    private var classes: [Class] {
        didSet {
            setupClasses()
            clas.reloadAllComponents()
        }
    }
    private var departs: [Depart] {
        didSet {
            setupDeparts()
            depart.reloadAllComponents()
        }
    }
    
    private var textfield1 = UITextView()
    private var textfield2 = UITextView()
    private var textfield3 = UITextView()
    private var textfield4 = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupView() {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        view.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        
        setupStack()
        setupDecor()
    }
    
    init(template: TemplateData, ind: Int, tokenType: String, accessToken: String) {
        self.template = template
        self.ind = ind
        self.accessToken = accessToken
        self.tokenType = tokenType
        facs = Faculties()
        codes = Codes()
        departs = [Depart(departmentID: 0, title: "...")]
        departs.remove(at: 0)
        classes = [Class(classID: 0, title: "...", description: "...", code: "...")]
        classes.remove(at: 0)
        templ = template[ind]


        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStack() {
        getFaculties()
        getCodes()
        if facs.count == 1 {
            departs = facs[0].departments!
        }
        //setupFaculties()
        
        stack = UIStackView(arrangedSubviews: [
                                makeField(title: "С кем согласован проект? (Имя)", height: 48, text: teacherName, contains: (templ.teacher?.firstname == "" ? "Имя" : templ.teacher?.firstname)!),
                                makeField(title: "С кем согласован проект? (Фамилия)", height: 48, text: teacherSecName, contains: (templ.teacher?.surname == "" ? "Фамилия" : templ.teacher?.surname)!),
                                makeField(title: "С кем согласован проект? (Отчество)", height: 48, text: teacherLastName, contains: (templ.teacher?.lastname == "" ? "Отчество" : templ.teacher?.lastname)!),
                                makeField(title: "Статус согласовавшего проект", height: 117, text: teacherStatus, contains: (templ.teacher?.status == "" ? "Статус" : templ.teacher?.status)!),
                                makeField(title: "Кто утвердил проект? (Имя)", height: 48, text: headTeacherName, contains: (templ.headTeacher?.firstname == "" ? "Имя" : templ.headTeacher?.firstname)!),
                                makeField(title: "Кто утвердил проект? (Фамилия)", height: 48, text: headTeacherSecName, contains: (templ.headTeacher?.surname == "" ? "Фамилия" : templ.headTeacher?.surname)!),
                                makeField(title: "Уто утвердил проект? (Отчество)", height: 48, text: headTeacherLastName, contains: (templ.headTeacher?.lastname == "" ? "Отчество" : templ.headTeacher?.lastname)!),
                                makeField(title: "Статус утвердившего проект", height: 117, text: headTeacherStatus, contains: (templ.headTeacher?.status == "" ? "Статус" : templ.headTeacher?.status)!),
                                makeField(title: "Год", height: 48, text: year, contains: "\(templ.year!)"),
                                makeField(title: "Наименование программы", height: 117, text: progName, contains: (templ.programName == "" ? "" : templ.programName)!),
                                makeField(title: "Краткое наименование программы", height: 48, text: progShortName, contains: (templ.programShortName == "" ? "" : templ.programShortName)!),
                                makeField(title: "Наименование программы (англ.)", height: 117, text: progEngName, contains: (templ.programNameEnglish == "" ? "" : templ.programNameEnglish)!),
                                makeField(title: "Крат. описание области применения", height: 117, text: descript, contains: (templ.description == "" ? "" : templ.description)!), faculcy, depart, claz, clas])
    }
    
    private func setupFaculties() {
        if departs.count == 0 {
            departs = facs[0].departments!
        }
        faculcy.tag = 1
        faculcy.delegate = self
        faculcy.dataSource = self
        textfield1.inputView = faculcy
        faculcy.setWidth(to: 360)
        faculcy.setHeight(to: 100)
        faculcy.backgroundColor = .white
        faculcy.layer.cornerRadius = 15
        faculcy.layer.borderWidth = 3
        faculcy.layer.borderColor = .init(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        
    }
    
    private func setupCodes() {
        if classes.count == 0 {
            classes = codes[0].classes!
        }
        claz.tag = 2
        claz.delegate = self
        claz.dataSource = self
        textfield2.inputView = claz
        claz.setWidth(to: 360)
        claz.setHeight(to: 100)
        claz.backgroundColor = .white
        claz.layer.cornerRadius = 15
        claz.layer.borderWidth = 3
        claz.layer.borderColor = .init(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
    }
    
    private func setupDeparts() {
        
        depart.tag = 3
        depart.delegate = self
        depart.dataSource = self
        textfield3.inputView = depart
        depart.setWidth(to: 360)
        depart.setHeight(to: 100)
        depart.backgroundColor = .white
        depart.layer.cornerRadius = 15
        depart.layer.borderWidth = 3
        depart.layer.borderColor = .init(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
    }
    private func setupClasses() {
        clas.tag = 4
        clas.delegate = self
        clas.dataSource = self
        textfield4.inputView = clas
        clas.setWidth(to: 360)
        clas.setHeight(to: 100)
        clas.backgroundColor = .white
        clas.layer.cornerRadius = 15
        clas.layer.borderWidth = 3
        clas.layer.borderColor = .init(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
    }
    
    private func getFaculties() {
        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/extra/get-all-faculties")!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let facults = try? JSONDecoder().decode(Faculties.self, from: data) {
                DispatchQueue.main.async {
                    self.facs = facults
                    self.facID = facults[0].facultyID!
                    self.depID = facults[0].departments![0].departmentID!
                }
            }
        }
        task.resume()
    }
    
    private func getCodes() {
        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/extra/get-all-chapters")!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let cos = try? JSONDecoder().decode(Codes.self, from: data) {
                DispatchQueue.main.async {
                    self.clazCode = cos[0].code!
                    self.clasID = cos[0].classes![0].classID!
                    self.clasCode = cos[0].classes![0].code!
                    self.codes = cos
                    self.classDesc = cos[0].classes![0].description!
                    //print(facults)
                }
            }
        }
        task.resume()
    }
    
    @objc
    private func savePressed() {
        postSaves()
    }
    
    private func postSaves() {
        UIView.animate(withDuration: 0.2, delay: 0.07, animations: {
            self.saveButton.backgroundColor = UIColor(red: 62/255, green: 103/255, blue: 182/255, alpha: 1)
        })
        
        var temporary: [[String: Any?]] = [[String(): Any?(nilLiteral: ())]]
        temporary.remove(at: 0)
        for item in (templ.user?.roles)! {
            let temporary2: [String: Any?] = ["id": item.id!,
                              "name": item.name!]
            temporary.append(temporary2)
        }
        
        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/app/sample/save")!)
        let params: [String: Any] = ["sampleId": templ.sampleID!,
                                     "user": [
                                        "userId": (templ.user?.userID)!,
                                         "person": [
                                            "personId": (templ.user?.person?.personID)!,
                                            "firstname": (templ.user?.person?.firstname)!,
                                            "surname": (templ.user?.person?.surname)!,
                                            "lastname": (templ.user?.person?.lastname)!,
                                            "status": (templ.user?.person?.status)!
                                         ],
                                        "email": (templ.user?.email)!,
                                        "username": (templ.user?.username)!,
                                         "roles": temporary
                                     ],
                                     "teacher": [
                                        "personId": (templ.teacher?.personID)!,
                                        "firstname": (teacherName.text)!,
                                        "surname": (teacherSecName.text)!,
                                        "lastname": (teacherLastName.text)!,
                                        "status": (teacherStatus.text)!
                                     ],
                                     "headTeacher": [
                                        "personId": (templ.headTeacher?.personID)!,
                                        "firstname": (headTeacherName.text)!,
                                        "surname": (headTeacherSecName.text)!,
                                        "lastname": (headTeacherLastName.text)!,
                                        "status": (headTeacherStatus.text)!
                                     ],
                                     "department": [
                                         "departmentId": depID,
                                        "title": (textfield3.text)!
                                     ],
                                     "year": year.text == "" ? 2023 : Int(year.text!)!,
                                     "programName": progName.text!,
                                     "programShortName": progShortName.text!,
                                     "programNameEnglish": progEngName.text!,
                                     "description": descript.text!,
                                     "byDocument": (templ.byDocument)!,
                                     "clazz": [
                                         "classId": clasID,
                                        "title": textfield4.text!,
                                         "description": classDesc,
                                         "code": clasCode
                                     ]]
        let body = try? JSONSerialization.data(withJSONObject: params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = body
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(response)
        }
        task.resume()
        
                
        UIView.animate(withDuration: 0.1, animations: {
            self.saveButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        })
    }
    
    
    
    // MARK: Decorations and helper methods
    private func setupDecor() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        let window = UIApplication.shared.windows.first
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        let topPadding = (window?.safeAreaInsets.top)!
        
        scroll.backgroundColor = .white
        view.addSubview(scroll)
        stack.setWidth(to: width)
        scroll.addSubview(stack)
        
        name.font = .systemFont(ofSize: 30, weight: .semibold)
        name.textColor = .white
        name.text = templ.programShortName
        if let navigationBar = navigationController?.navigationBar {
            let firstFrame = CGRect(x: (navigationBar.bounds.width - 260) / 2, y: 0, width: 260, height: navigationBar.frame.height)

            name = UILabel(frame: firstFrame)
            name.font = .systemFont(ofSize: 30, weight: .semibold)
            name.textColor = .white
            name.text = templ.programShortName
            name.textAlignment = .center

            navigationBar.addSubview(name)
        }

                        
        saveButton = makeButton(title: "Сохранить", height: 60, width: width)
        saveButton.layer.borderWidth = 3
        saveButton.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(saveButton)
        saveButton.pinCenterX(to: view)
        saveButton.pinTop(to: view.topAnchor, Int(height) - 60 - Int(bottomPadding))
        saveButton.addTarget(self, action: #selector(savePressed), for: .touchUpInside)
        
        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scroll.pinTop(to: view.topAnchor, Int(topPadding))
        scroll.pinBottom(to: saveButton.topAnchor)
        scroll.setWidth(to: width)
        
        stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor).isActive = true
        stack.pinTop(to: scroll)
        stack.pinBottom(to: scroll)
        stack.setWidth(to: width)
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 20
        stack.distribution = .equalSpacing
        
    }
    
    private func makeButton(title: String, height: Int, width: CGFloat) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        button.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        button.setWidth(to: width)
        button.setHeight(to: height)
        
        return button
    }
    private func makeField(title: String, height: Int, text: UITextView, contains: String) -> UIView {
        let tempView = UIView()
        tempView.setWidth(to: 360)
        tempView.setHeight(to: height + 36)
        
        let name = UILabel()
        name.font = .systemFont(ofSize: 20, weight: .semibold)
        name.text = title
        name.textColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        
        tempView.addSubview(name)
        
        text.setHeight(to: height)
        text.setWidth(to: 360)
        text.text = contains
        text.textAlignment = .natural
        text.backgroundColor = UIColor(red: 214/255, green: 228/255, blue: 1, alpha: 1)
        text.layer.cornerRadius = 15
        text.textColor = .black
        text.font = .systemFont(ofSize: 17, weight: .regular)
        
        tempView.addSubview(text)
        name.pinTop(to: tempView.topAnchor)
        text.pinTop(to: name.bottomAnchor, 16)
        name.leftAnchor.constraint(equalTo: text.leftAnchor, constant: 15).isActive = true
        text.pinCenterX(to: tempView.centerXAnchor)
        text.leftAnchor.constraint(equalTo: tempView.leftAnchor, constant: 15).isActive = true
        return tempView
    }
}


extension EditTemplateViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return facs.count
        } else if pickerView.tag == 2 {
            return codes.count
        } else if pickerView.tag == 3 {
            return departs.count
        } else {
            return classes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return facs[row].title
        } else if pickerView.tag == 2 {
            return codes[row].title
        } else if pickerView.tag == 3 {
            return departs[row].title
        } else {
            return classes[row].title
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            facInd = row
            facID = facs[row].facultyID!
            textfield1.text = facs[row].title
            facName = facs[component].title!
            departs = facs[row].departments!
        } else if pickerView.tag == 2 {
            codeInd = row
            clazCode = codes[row].code!
            textfield2.text = codes[row].title
            classes = codes[row].classes!
        } else if pickerView.tag == 3 {
            textfield3.text = departs[row].title
            depID = departs[row].departmentID!
        } else {
            textfield4.text = classes[row].title
            clasID = classes[row].classID!
            clasCode = classes[row].code!
            classDesc = classes[row].description!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {        return 360
    }
}
