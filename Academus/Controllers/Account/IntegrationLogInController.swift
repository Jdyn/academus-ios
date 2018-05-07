//
//  LogInIntegrationController.swift
//  Academus
//
//  Created by Jaden Moore on 3/2/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import UIKit

class IntegrationLogInController: UIViewController, getStatusDelegate {

    let statusService = StatusService()
    var integrationService: IntegrationService?
    var integration: IntegrationChoice?
    var integrationName: String?
    var coursesController: CoursesController?
    var fields: [UITextField] = []

    var statusAlert: UIView?
    
    let titleLabel = UILabel().setUpLabel(text: "", font: UIFont(name: "AvenirNext-demibold", size: 36)!, fontColor: .navigationsGreen)
    let subtitle = UILabel().setUpLabel(text: "Sign into your", font: UIFont(name: "AvenirNext-medium", size: 24)!, fontColor: .navigationsWhite)
    let button = UIButton(type: .system).setUpButton(title: "SIGN IN", font: UIFont.standard!, fontColor: .navigationsGreen)
    
    @objc func logInPressed() {
        guard let fieldsCounts = integration?.fields.count else {return}
        for i in 0...fieldsCounts - 1 {
            fields[i].resignFirstResponder()
            if (fields[i].text?.isEmpty)! {
                alertMessage(title: "Hey!", message: "Please fill out all fields to continue.")
                return
            }
        }
        
        loadingAlert(title: "Please wait", message: "Attempting to add new integration")
        integrationService?.addIntegration(fields: fields) { (success, error) in
            if success {
                self.dismiss(animated: true, completion: {
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popToRootViewController(animated: true)
                    self.coursesController?.didAddIntegration()
                })
            } else {
                self.dismiss(animated: true, completion: {
                    self.alertMessage(title: "An error has occurred", message: error ?? "Please try again later.")
                })
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusService.statusDelegate = self
        statusService.getStatus { _ in }
        
        hideKeyboard()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func didGetStatus(components: [ComponentModel]) {
        if components.isEmpty {
            statusAlert?.removeFromSuperview()
            statusAlert = nil
        } else {
            if let index = components.index(where: { $0.name == titleLabel.text }),
                let status = components[index].status, status > 1,
                let name = components[index].name, name == titleLabel.text,
                let statusName = components[index].statusName {
                statusAlert = statusBarHeaderView(message: "\(name): \(statusName)", severity: status, selector: #selector(handleStatusAlert))
                view.addSubview(statusAlert!)
                statusAlert!.anchors(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 57)
            } else if let mostSevere = components.max(by: { ($0.status ?? 0) < ($1.status ?? 0) }),
                let status = mostSevere.status, status > 1,
                let name = mostSevere.name,
                let statusName = mostSevere.statusName {
                statusAlert = statusBarHeaderView(message: "\(name): \(statusName)", severity: status, selector: #selector(handleStatusAlert))
                view.addSubview(statusAlert!)
                statusAlert!.anchors(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 57)
            } else {
                statusAlert?.removeFromSuperview()
                statusAlert = nil
            }
        }
    }

    private func setUpUI() {
        self.view.backgroundColor = .tableViewDarkGrey
        
        let screen = UIScreen.main.bounds
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: screen.width, height: screen.height)
        scrollView.isScrollEnabled = true
        scrollView.addSubviews(views: [subtitle, titleLabel, button])
        
        titleLabel.adjustsFontSizeToFitWidth = true
        subtitle.adjustsFontSizeToFitWidth = true
        
        titleLabel.textAlignment = .center
        subtitle.textAlignment = .center
        
        view.addSubview(scrollView)
        scrollView.anchors(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        guard let fieldCount = integration?.fields.count else {return}
        for i in 0...fieldCount - 1 {
            let field = UITextField().setupTextField(bgColor: .tableViewDarkGrey, bottomBorder: true, ghostText: integration?.fields[i].label, isLeftImage: false, isSecure: false)
            field.font = UIFont.standard!
            if integration?.fields[i].id == "password" {
                field.isSecureTextEntry = true
            }
            scrollView.addSubview(field)
            field.anchors(top: fields.last?.topAnchor ?? titleLabel.topAnchor, topPad: (fields.last != nil) ? 54 : 72, leftPad: 32, rightPad: -32, centerX: scrollView.centerXAnchor, width: screen.width - 64, height: fieldHeight)
            fields.append(field)
        }
        
        subtitle.anchors(top: scrollView.topAnchor, topPad: 120, centerX: scrollView.centerXAnchor, width: screen.width - 42)
        titleLabel.anchors(top: subtitle.bottomAnchor, centerX: scrollView.centerXAnchor, width: screen.width - 42)
        button.anchors(top: fields.last?.bottomAnchor, topPad: 32, centerX: scrollView.centerXAnchor, width: 84)
        button.addTarget(self, action: #selector(logInPressed), for: .touchUpInside)
    }
    
    @objc func handleStatusAlert() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.statusAlert?.removeFromSuperview()
        })
    }
}
