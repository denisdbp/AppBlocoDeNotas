//
//  AnotacoesViewController.swift
//  BlocoDeAnotacoes
//
//  Created by Admin on 11/09/22.
//

import UIKit

class AnotacoesViewController: UIViewController {
    
    let presenter:AnotacoesPresenter = AnotacoesPresenter()
    var model:[AnotacoesModel] = []
    var id:String = ""
    var titulo:String = ""
    var anotacao:String = ""
    
    @IBOutlet weak var tituloAnotacaoTextField: UITextField!
    @IBOutlet weak var anotacaoTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configBackgroundTextFields()
        self.presenter.anotacoesProtocol = self
        self.configAcessibilidade()
        self.tituloAnotacaoTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tituloAnotacaoTextField.text = self.titulo
        self.anotacaoTextField.text = self.anotacao
    }
    
    @IBAction func novaAnotacaoButton(_ sender: UIButton) {
        self.tituloAnotacaoTextField.text = ""
        self.anotacaoTextField.text = ""
        self.id = ""
        self.titulo = ""
        self.anotacao = ""
        self.tituloAnotacaoTextField.becomeFirstResponder()
        UIAccessibility.post(notification: .screenChanged, argument: self.tituloAnotacaoTextField)
    }
    
    @IBAction func salvarAnotacaoButton(_ sender: Any) {
        let data:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let ultimaAtualizacao = dateFormatter.string(from: data)
            self.presenter.alterarAnotacao(id:self.id, titulo: self.tituloAnotacaoTextField.text ?? "", anotacao: self.anotacaoTextField.text ?? "", ultimaAlteracao: ultimaAtualizacao)
        self.id = ""
        self.titulo = ""
        self.anotacao = ""
        self.view.endEditing(true)
        UIAccessibility.post(notification: .screenChanged, argument: self.tituloAnotacaoTextField)
    }
    
    @IBAction func limparAnotacaoButton(_ sender: Any) {
        self.tituloAnotacaoTextField.text?.removeAll()
        self.anotacaoTextField.text.removeAll()
        self.tituloAnotacaoTextField.becomeFirstResponder()
        self.view.endEditing(true)
        UIAccessibility.post(notification: .screenChanged, argument: self.tituloAnotacaoTextField)
    }
    
    private func configAcessibilidade(){
        self.tituloAnotacaoTextField.isAccessibilityElement = true
        self.tituloAnotacaoTextField.accessibilityHint = "Digite o titulo da anotação"
        self.anotacaoTextField.isAccessibilityElement = true
        self.anotacaoTextField.accessibilityHint = "Digite sua anotação"
        self.anotacaoTextField.accessibilityValue = "Anotação"
        self.tituloAnotacaoTextField.adjustsFontForContentSizeCategory = true
        self.anotacaoTextField.adjustsFontForContentSizeCategory = true
    }
    
    private func configBackgroundTextFields(){
        self.tituloAnotacaoTextField.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 225.0/255.0, alpha: 1)
        self.anotacaoTextField.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 225.0/255.0, alpha: 1)
        self.anotacaoTextField.showsVerticalScrollIndicator = false
    }
}

extension AnotacoesViewController:AnotacoesProtocol {
    func verificaDadosVazios() {
        let alert = UIAlertController(title: "Verificacao", message: "Preencha todos os campos", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func limparCamposAnotacoes() {
        self.tituloAnotacaoTextField.text = ""
        self.anotacaoTextField.text = ""
        self.tituloAnotacaoTextField.becomeFirstResponder()
    }
    
    func erroGenerico() {
        Alertas.shared.alertaGenerico(titulo: "Ops...", mensagem: "Ocorreu um erro ao cadastrar ou alterar sua anotação", controller: self)
    }
}

extension AnotacoesViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.anotacaoTextField.becomeFirstResponder()
        return textField.resignFirstResponder()
    }
}
