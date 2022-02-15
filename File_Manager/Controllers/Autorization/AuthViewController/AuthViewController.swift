//
//  AuthViewController.swift
//  File_Manager
//
//  Created by Артем Калинкин on 08.02.2022.
//

import UIKit
import WebKit
import Combine
import KeychainSwift

class AuthViewController: UIViewController, WKNavigationDelegate
{
  
  private var webView = WKWebView()
  private var subscriber: AnyCancellable?
  
  private struct DropboxURL {
    static let authURL = "https://www.dropbox.com/oauth2/authorize?"
    static let clientID = "688rvrlb7upz9jb"
    static let redirectURI = "http://localhost"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.navigationDelegate = self
    view.addSubview(webView)
    let url = URL(string: DropboxURL.authURL +
                  "client_id=\(DropboxURL.clientID)" +
                  "&response_type=code" +
                  "&redirect_uri=\(DropboxURL.redirectURI)")
    webView.load(URLRequest(url: url!))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    webView.frame = view.bounds
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    guard let url = webView.url else { return }
    guard let code = getCodeFrom(url: url) else { return }
    print("CURRENT URL: \(url.absoluteString)")
    print("CODE ACESS TO DROPBOX: \(code)")
    
    guard let request = RequestConfigurator.token(code).setRequest() else { return }
    
    subscriber = URLSession.shared.dataTaskPublisher  (
      for: request)
      .map { $0.data }
      .decode(type: TokenResponse.self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
      .sink { completion in
        switch completion {
        case .finished:
          print("Token achieved")
        case .failure(let error):
          print("Error in token request due to: \(error.localizedDescription)")
        }
      } receiveValue: {[weak self] tokenResponse in
        print("ACCESS TOKEN : \(tokenResponse.accessToken)")
        if let data = try? JSONEncoder().encode(tokenResponse) {
          KeychainSwift().set(data, forKey: "\(DropboxAPI.tokenKey)", withAccess: .accessibleWhenUnlocked)
        }
       self?.dismiss(animated: true)
      }
  }
  
  private func getCodeFrom(url: URL) -> String? {
    let components = URLComponents(string: url.absoluteString)
    guard let code = components?.queryItems?
            .first(where: {$0.name == "code"})?.value
    else { return nil }
    return code
  }
}

