//
//  ContentView.swift
//  RandPic
//
//  Created by Joona Suhonen on 1.11.2021.
//

import SwiftUI


//Luodaan luokka ViewModel ja sille jatkoksi ObservableObject, jotta sitä voidaan käyttää SwiftUI:n sisällä
class ViewModel: ObservableObject {
    
    //Tällä mahdollistetaan kuvan vienti SwiftUI:n puolelle
    @Published var image: Image?
    
    //Tässä luodaan sivun osoitteesta URL
    func fetchNewImage() {
        guard let url = URL(string:
        "https://random.imagecdn.app/500/500") else {
            return
        }
        
        //Tällä haetaan itse URL:stä tarvittava data. Alaviivojen kohdalle olisi voinut laittaa URL-responsen ja errorin.
        
        let task = URLSession.shared.dataTask(with: url) { data,_,_ in
            guard let data = data else {return}
            
            
            //Tässä luodaan saadusta datasta UIImage
            DispatchQueue.main.async {
                guard let uiImage = UIImage(data: data) else {
                    return
                }
                self.image = Image(uiImage: uiImage)
            }
        }
        task.resume()
    }
}

struct ContentView: View {
    //StateObject huomaa muutokset ViewModelissa, jolloin se osaa piirtää uuden kuvan
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        //Tässä luodaan itse UI ohjelmalle
        
        NavigationView{
            VStack{
                
                Spacer()
                
                //Jos kuva löytyy, niin se printataan näytölle
                if let image = viewModel.image {
                    
                    image
                        .resizable()
                        .foregroundColor(Color.blue)
                        .frame(width: 200, height: 200)
                        .padding()
                    
                } else {
                    
                //Jos kuvaa ei löydy, printtaa se valmiin "photo" kuvan kirjastosta
                    
                Image(systemName: "photo")
                    .resizable()
                    .foregroundColor(Color.blue)
                    .frame(width: 250, height: 250)
                    .padding()
                }
                Spacer()
                
                //Napilla suoritetaan fetchNewImage() -funktio
                
                Button(action: {
                    viewModel.fetchNewImage()
                }, label: {
                    Text("Uusi kuva")
                        .bold()
                        .frame(width: 250, height: 40)
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .cornerRadius(8)
                        .padding()
                })
                Spacer()
            }
            //Otsikko
            .navigationTitle("RandPic")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
