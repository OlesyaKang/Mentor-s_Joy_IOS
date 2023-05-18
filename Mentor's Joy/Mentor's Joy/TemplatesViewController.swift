//
//  TemplatesViewController.swift
//  Mentor's Joy
//
//  Created by Ольга on 02.05.2023.
//

import Foundation
import UIKit

final class TemplatesViewComtroller: UIViewController {
        
    private let name = UILabel()
    private var filesButton = UIButton()
    private var tempsButton = UIButton()
    private var editButton = UIButton()
    private var deleteButton = UIButton()
    private var generateButton = UIButton()
    private var stack = UIStackView()
    private var addTempButton = UIButton()
    private var updateButtom = UIButton()
    private var whereIsNow = "templates"
    
    private var accessToken, tokenType: String
    
    var collection = UICollectionView(frame: .infinite, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var ind = 0
    
    private var templatesArray = [Template()]
    
    private var allFiles = FileData() {
        didSet {
            loadFiles()
        }
    }
    private var allTemplates = TemplateData() {
        didSet {
            loadTemplates()
        }
    }
    
    init(accessToken: String, tokenType: String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        collection.dataSource = self
        collection.delegate = self
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) is not supported")
    }
    
    private func setupView() {
        collection.register(TemplateCell.self, forCellWithReuseIdentifier: TemplateCell.reuseIdentifier)
        collection.tag = 1
        
        view.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        setupDecor()
        
        getAllTemplates()
        collection.reloadData()
        
        setupAddButton()
        
        editButton = makeButton(title: "Редактировать", height: 60, width: 330)
        editButton.layer.cornerRadius = 15
        editButton.setTitleColor(UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1), for: .normal)
        editButton.backgroundColor = UIColor(red: 214/255, green: 228/255, blue: 1, alpha: 1)
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
        
        deleteButton = makeButton(title: "Удалить", height: 60, width: 330)
        deleteButton.layer.cornerRadius = 15
        deleteButton.setTitleColor(UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1), for: .normal)
        deleteButton.backgroundColor = UIColor(red: 214/255, green: 228/255, blue: 1, alpha: 1)
        deleteButton.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        
        generateButton = makeButton(title: "Генерация файла", height: 60, width: 330)
        generateButton.layer.cornerRadius = 15
        generateButton.setTitleColor(UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1), for: .normal)
        generateButton.backgroundColor = UIColor(red: 214/255, green: 228/255, blue: 1, alpha: 1)
        generateButton.addTarget(self, action: #selector(genButPressed), for: .touchUpInside)
        
        stack = UIStackView(arrangedSubviews: [editButton, generateButton, deleteButton])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .fill
        
        view.addSubview(stack)
        stack.pinCenter(to: view)
        
        stack.isHidden = true
        
        setupButtons()
        
    }
    
    @objc
    private func updatePressed() {
        getAllTemplates()
    }
    
    private func loadTemplates() {
        var temporary = [Template()]
        temporary.remove(at: 0)
        //print(allTemplates)
        if allTemplates.count == 0 && templatesArray.count == 1  {
            templatesArray.remove(at: 0)
        }
        for template in allTemplates {
            temporary.append(Template(name: (template.programShortName == "" ? "ТЗ" : template.programShortName)!, id: template.sampleID!))
            print(template.sampleID!)
            //print(template.sampleID!)
        }
        templatesArray = temporary
        collection.reloadData()
    }
    
    private func loadFiles() {
        var temporary = [Template()]
        //print(allFiles)
        temporary.remove(at: 0)
        //print(allTemplates)
        if allFiles.count == 0  && templatesArray.count == 1{
            templatesArray.remove(at: 0)
        }
        for file in allFiles {
            temporary.append(Template(name: (file.sample?.programShortName == "" ? "ТЗ" : file.sample?.programShortName)!, id: file.techAssigmentId == nil ? 0 : file.techAssigmentId))
            print(file.techAssigmentId!)
            //print(template.sampleID!)
        }
        templatesArray = temporary
        collection.reloadData()
    }
    
    private func getAllTemplates() {
        
        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/app/sample/get-all")!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let templateData = try? JSONDecoder().decode(TemplateData.self, from: data) {
                DispatchQueue.main.async {
                    self.allTemplates = templateData
                }
            }
        }
        task.resume()
    }
    
    private func getAllFiles() {
        
        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/app/technical_assignment/get-all")!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let fileData = try? JSONDecoder().decode(FileData.self, from: data) {
                DispatchQueue.main.async {
                    self.allFiles = fileData
                    //print(fileData)
                }
            }
        }
        task.resume()
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
    
    private func setupDecor() {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        let window = UIApplication.shared.windows.first
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        let topPadding = (window?.safeAreaInsets.top)!
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: 154, height: 210)
        layout.minimumInteritemSpacing = (bounds.size.width - 154) / 3
        layout.minimumLineSpacing = 41
        
        collection.collectionViewLayout = layout
        collection.backgroundColor = .white
        view.addSubview(collection)
        collection.setWidth(to: width)
        
        name.text = "Шаблоны"
        name.font = .systemFont(ofSize: 30, weight: .semibold)
        name.textColor = .white
        
        view.addSubview(name)
        name.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 8)
        name.pinCenterX(to: view.centerXAnchor)
        
        self.navigationController?.navigationBar.isHidden = true
        
        filesButton = makeButton(title: "Файлы", height: 60, width: width / 2 + 1.5)
        filesButton.layer.borderWidth = 3
        filesButton.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        filesButton.addTarget(self, action: #selector(filesPressed), for: .touchUpInside)
        
        tempsButton = makeButton(title: "Шаблоны", height: 60, width: width / 2 + 1.5)
        tempsButton.layer.borderWidth = 3
        tempsButton.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        tempsButton.addTarget(self, action: #selector(templatesPressed), for: .touchUpInside)

        view.addSubview(filesButton)
        view.addSubview(tempsButton)
        
        filesButton.pinRight(to: view)
        filesButton.pinTop(to: view.topAnchor, Int(height) - 63 - Int(bottomPadding))
        
        tempsButton.pinLeft(to: view)
        tempsButton.pinTop(to: view.topAnchor, Int(height) - 63 - Int(bottomPadding))
        
        collection.pinTop(to: name.bottomAnchor, 15)
        collection.pinBottom(to: tempsButton.topAnchor)
        
        updateButtom = makeButton(title: "Обновить", height: 57, width: 100)
        updateButtom.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        view.addSubview(updateButtom)
        updateButtom.pinTop(to: view.topAnchor, Int(topPadding))
        updateButtom.pinRight(to: view, 20)
        updateButtom.addTarget(self, action: #selector(updatePressed), for: .touchUpInside)
    }
    
    private func setupAddButton() {
        addTempButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        addTempButton.setWidth(to: 74)
        addTempButton.setHeight(to: 74)
        addTempButton.layer.cornerRadius = 37
        addTempButton.setTitle("+", for: .normal)
        addTempButton.setTitleColor(.white, for: .normal)
        addTempButton.titleLabel?.font = .systemFont(ofSize: 60, weight: .bold)
        addTempButton.setImage(UIImage(systemName: "Group 5"), for: .normal)
        view.addSubview(addTempButton)
        addTempButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -27).isActive = true
        addTempButton.pinBottom(to: filesButton.topAnchor, 27)
        addTempButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func addButtonTapped() {
        UIView.animate(withDuration: 0.2, delay: 0.07, animations: {
            self.addTempButton.backgroundColor = UIColor(red: 62/255, green: 103/255, blue: 182/255, alpha: 1)
        })

        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/app/sample/create")!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let templateData = try? JSONDecoder().decode(TemplateDatum.self, from: data) {
                DispatchQueue.main.async {
                    self.allTemplates.append(templateData)
                    print(self.allTemplates.count)
                }
            } else {
                print("aboba")
            }
        }
        task.resume()
        UIView.animate(withDuration: 0.1, animations: {
            self.addTempButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        })
    }
    
    @objc
    private func editPressed() {
        let editor = EditTemplateViewController(template: allTemplates, ind: ind, tokenType: tokenType, accessToken: accessToken)
        stack.isHidden = true
        self.navigationController?.pushViewController(editor, animated: true)
    }
    
    var really = UIButton()
    var no = UIButton()
    var delStack = UIStackView()
    
    private func setupButtons() {
        really = makeButton(title: "Удалить безвозвратно", height: 60, width: 330)
        really.layer.cornerRadius = 15
        really.backgroundColor = UIColor(red: 214/255, green: 228/255, blue: 1, alpha: 1)
        really.setTitleColor(UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1), for: .normal)
        really.addTarget(self, action: #selector(reallyDelete), for: .touchUpInside)
        
        no = makeButton(title: "Не удалять", height: 60, width: 330)
        no.layer.cornerRadius = 15
        no.backgroundColor = UIColor(red: 214/255, green: 228/255, blue: 1, alpha: 1)
        no.setTitleColor(UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1), for: .normal)
        no.addTarget(self, action: #selector(noDelete), for: .touchUpInside)
        
        delStack = UIStackView(arrangedSubviews: [really, no])
        delStack.axis = .vertical
        delStack.alignment = .fill
        delStack.spacing = 2
        
        view.addSubview(delStack)
        delStack.pinCenter(to: view)
        delStack.isHidden = true
    }
    
    @objc
    private func templatesPressed() {
        UIView.animate(withDuration: 0.2, delay: 0.07, animations: {
            self.tempsButton.backgroundColor = UIColor(red: 62/255, green: 103/255, blue: 182/255, alpha: 1)
        })
        if whereIsNow == "files" {
            whereIsNow = "templates"
            templatesArray = [Template()]
            stack.isHidden = true
            delStack.isHidden = true
            editButton.isHidden = false
            updateButtom.isHidden = false
            addTempButton.isHidden = false
            generateButton.setTitle("Генерация файла", for: .normal)
            name.text = "Шаблоны"
            getAllTemplates()
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.tempsButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        })
    }
    
    @objc
    private func filesPressed() {
        UIView.animate(withDuration: 0.2, delay: 0.07, animations: {
            self.filesButton.backgroundColor = UIColor(red: 62/255, green: 103/255, blue: 182/255, alpha: 1)
        })
        if whereIsNow == "templates" {
            name.text = "Файлы"
            templatesArray = [Template()]
            whereIsNow = "files"
            stack.isHidden = true
            delStack.isHidden = true
            editButton.isHidden = true
            updateButtom.isHidden = true
            generateButton.setTitle("Скачать тз", for: .normal)
            addTempButton.isHidden = true
            getAllFiles()
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.filesButton.backgroundColor = UIColor(red: 97/255, green: 140/255, blue: 223/255, alpha: 1)
        })
    }
    
    @objc
    private func deletePressed() {
        stack.isHidden = true
        delStack.isHidden = false
    }
    
    @objc
    private func noDelete() {
        delStack.isHidden = true
    }
    
    private func deleteTemplate() {
        delStack.isHidden = true
        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/app/sample/delete")!)
        
        let params: [String: Int] = ["sampleId": templatesArray[ind].id!]
        let body = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let string = String(bytes: data!, encoding: .utf8) {
                if string == "Success" {
                    DispatchQueue.main.async {
                        self.allTemplates.remove(at: self.ind)
                        //print(self.allTemplates.count)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func deleteFile() {
        delStack.isHidden = true
        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/app/technical_assignment/delete")!)
        
        let params: [String: Int] = ["technicalAssignmentId": allFiles[ind].techAssigmentId!]
        let body = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let string = String(bytes: data!, encoding: .utf8) {
                if string == "Success" {
                    DispatchQueue.main.async {
                        self.allFiles.remove(at: self.ind)
                        //print(self.allFiles.count)
                    }
                }
            }
        }
        task.resume()
    }
    
    @objc
    private func reallyDelete() {
        switch whereIsNow {
        case "templates":
            deleteTemplate()
        default:
            deleteFile()
        }
    }
    
    private func genFile() {
        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/app/technical_assignment/generate")!)
        
        let params: [String: Int] = ["sampleId": allTemplates[ind].sampleID!]
        let body = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //print(response)
        }
        task.resume()
    }
        
    private func downloadFile() {
        var request = URLRequest(url: URL(string: "http://158.160.13.158:8081/api/app/technical_assignment/get-file/\(templatesArray[ind].id!)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tokenType + " " + accessToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        /*print(templatesArray[ind].id!)
        let alarm = URL(string: "http://158.160.13.158:8081/api/app/technical_assignment/get-file/\(templatesArray[ind].id!)")!
                do {
                    try alarm.download(to: .documentDirectory, using: "\(String(describing: templatesArray[ind].name!)).docx") { url, error in
                        print(url!)
                    }
                } catch {
                    print(error)
                }*/

        do {
            try request.download(to: .documentDirectory, using: "\(String(describing: templatesArray[ind].name!)).docx") { url, error in
                print(url!)
            }
        } catch {
            print(error)
        }
        
        
        /*let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(response!)
        }
        task.resume()*/
    }
    
    private func export() {
        
    }
    
    @objc
    private func genButPressed() {
        switch whereIsNow {
        case "templates":
            genFile()
        default:
            downloadFile()
        }
        stack.isHidden = true
    }
}





extension TemplatesViewComtroller: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templatesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: TemplateCell.reuseIdentifier, for: indexPath) as? TemplateCell {
            
            tempCell.template = templatesArray[indexPath.row]
            tempCell.button.tag = indexPath.item
            tempCell.button.addTarget(self, action: #selector(cellPressed), for: .touchUpInside)
            
            return tempCell
        }
        
        return UICollectionViewCell()
    }
    
    @objc
    private func cellPressed(_ sender: UIButton) {
        stack.isHidden = !stack.isHidden
        ind = sender.tag
        /*print(ind)
        print(allTemplates[ind])*/
    }
    
}
