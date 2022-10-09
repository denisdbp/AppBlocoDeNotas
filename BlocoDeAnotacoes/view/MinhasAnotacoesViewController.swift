//
//  ViewController.swift
//  BlocoDeAnotacoes
//
//  Created by Admin on 11/09/22.
//

import UIKit

class MinhasAnotacoesViewController: UIViewController {
    
    let presenter:AnotacoesPresenter = AnotacoesPresenter()
    let anotacoesViewController:AnotacoesViewController = AnotacoesViewController()
    var model:[AnotacoesModel] = []
    
    @IBOutlet weak var minhasAnotacoesTableView: UITableView!
    @IBOutlet weak var pesquisarAnotacoesSearchBar: UISearchBar!
    let progressoCarregamento:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configProgressoCarregamento()
        self.progressoCarregamento.startAnimating()
        self.presenter.minhasAnotacoesProtocol = self
        self.configTableView()
        self.configAcessibilidade()
        self.pesquisarAnotacoesSearchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter.mostrarAnotacoes()
    }
    
    private func configProgressoCarregamento(){
        self.progressoCarregamento.center = self.view.center
        self.progressoCarregamento.hidesWhenStopped = true
        self.progressoCarregamento.color = .black
        self.progressoCarregamento.style = .large
        self.view.addSubview(self.progressoCarregamento)
    }
    
    private func configAcessibilidade(){
        self.minhasAnotacoesTableView.isAccessibilityElement = true
        self.minhasAnotacoesTableView.accessibilityLabel = "Lista das minhas anotações"
        self.pesquisarAnotacoesSearchBar.isAccessibilityElement = true
        self.pesquisarAnotacoesSearchBar.accessibilityLabel = "Digite uma pesquisa de anotação"
    }
    
    private func configTableView(){
        self.minhasAnotacoesTableView.register(UINib(nibName: "MostraAnotacoesTableViewCell", bundle: nil), forCellReuseIdentifier: MostraAnotacoesTableViewCell.identifier)
        self.minhasAnotacoesTableView.delegate = self
        self.minhasAnotacoesTableView.dataSource = self
        self.minhasAnotacoesTableView.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 225.0/255.0, alpha: 1)
        self.minhasAnotacoesTableView.showsVerticalScrollIndicator = false
    }
}

extension MinhasAnotacoesViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MostraAnotacoesTableViewCell.identifier, for: indexPath) as? MostraAnotacoesTableViewCell
        cell?.tituloAnotacaoLabel.text = "Título: \(self.model[indexPath.row].titulo)"
        cell?.anotacaoLabel.text = "Anotação: \(self.model[indexPath.row].anotacao)"
        cell?.ultimaAlteracaoLabel.text = self.model[indexPath.row].ultimaAlteracao
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let anotacoes = self.tabBarController?.viewControllers![1] as? AnotacoesViewController {
            anotacoes.id = self.presenter.model[indexPath.row].id
            anotacoes.titulo = self.presenter.model[indexPath.row].titulo
            anotacoes.anotacao = self.presenter.model[indexPath.row].anotacao
        self.tabBarController?.selectedIndex = 1
        }
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remover Anotação"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Alertas.shared.alertaParaRemover(titulo: "Remover", mensagem: "Deseja remover a anotação ?", controller: self) { _ in
                self.presenter.apagarAnotacoes(id: self.model[indexPath.row].id)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}

extension MinhasAnotacoesViewController:MinhasAnotacoesProtocol {
    func mostraAnotacoes(model: [AnotacoesModel]) {
        self.model = model
        self.minhasAnotacoesTableView.reloadData()
        self.progressoCarregamento.stopAnimating()
    }
    
    func erroGenerico() {
        Alertas.shared.alertaGenerico(titulo: "Ops...", mensagem: "Houve um erro para carregar suas anotações", controller: self)
    }
}

extension MinhasAnotacoesViewController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter.pesquisarAnotacao(pesquisa: searchText)
    }
}
