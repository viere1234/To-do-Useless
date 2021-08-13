//
//  SettingView.swift
//  To-be Useless
//
//  Created by 張智堯 on 2021/7/19.
//

import SwiftUI
import StoreKit
import SafariServices

struct SettingView: View {
    
    @Environment(\.openURL) var openURL
    @AppStorage("First") var first = true
    @AppStorage("HapticActivated") var hapticActivated = true
    @AppStorage("MissionStartTime") var missionStartTime = Calendar.current.nextDate(after: Date(), matching: .init(hour: 8), matchingPolicy: .strict)!
    @AppStorage("GetMossionTime") var getMissionTime = 1
    @AppStorage("DeveloperActivated") var developerActivated = false
    @AppStorage("IsGetDalyMission") var isGetDalyMission = false
    @AppStorage("Version") var version = ""
    @State private var developerCounter = 0
    @State private var changeMissionTime = false
    @State private var showAlert = false
    @State var showSafari = false
    var body: some View {
        ZStack {
            Form {
                if developerActivated {
                    Section(header: Text("Developer")) {
                        NavigationLink(destination: DeveloperView(), label: {
                            Label(
                                title: { Text("Developer Setting") },
                                icon: { Image(systemName: "questionmark.diamond").foregroundColor(.red) }
                            )
                        })
                    }
                }
                
                
                Section (header: Text("General")) {
                    
                    /*
                    NavigationLink (
                        destination: LoginView(),
                        label: {
                            Label(
                                title: { Text("Account") },
                                icon: { Image(systemName: "person.fill").foregroundColor(.red) }
                            )
                        }) */
                    
                    ZStack {
                        HStack {
                            Label(
                                title: { Text("Daly Mission Time") },
                                icon: { Image(systemName: "calendar.badge.clock").foregroundColor(.red) }
                            )
                            
                            Spacer()
                        }
                        
                        DatePicker("", selection: $missionStartTime, displayedComponents: .hourAndMinute)
                    }
                    
                    Toggle(isOn: $hapticActivated) {
                        Label(
                            title: { Text("Haptic Touch") },
                            icon: { Image(systemName: "hand.tap").foregroundColor(.red) }
                        )
                    }
                }
                
                Section (header: Text("Support")) {
                    Button(action: {
                        self.first.toggle()
                    }, label: {
                        Label(
                            title: { Text("Start Menu").foregroundColor(.black) },
                            icon: { Image(systemName: "filemenu.and.selection").renderingMode(.original)}
                        )
                    })
                    
                    Button(action: {
                        self.showSafari.toggle()
                    }, label: {
                        Label(
                            title: { Text("Information Center").foregroundColor(.black) },
                            icon: { Image(systemName: "info.circle.fill").renderingMode(.original) }
                        )
                    })
                    .sheet(isPresented: $showSafari) {
                        SafariView(url:URL(string: "https://to-be-useless.notion.site/to-be-useless/To-be-Useless-c78abcd5caba493bb9bce50ae093c9c1")!)
                    }
                    
                    /*
                    NavigationLink(destination: SupportView()) {
                        Label(
                            title: { Text("Information Center") },
                            icon: { Image(systemName: "info.circle.fill").renderingMode(.original) }
                        )
                    }*/
                    
                    Button(action: {
                        openURL(URL(string: "https://forms.gle/6yws6CirUUb8nk919")!)
                    }, label: {
                        Label(
                            title: { Text("Mission Proposal").foregroundColor(.black) },
                            icon: { Image(systemName: "macwindow.badge.plus").renderingMode(.original) }
                        )
                    })
                    
                    Button(action: {
                        openURL(URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfucyu0HHT4mudHFv1xNnr0G0pnOhDTHG6zpx3j-57A6zhPBA/viewform")!)
                    }, label: {
                        Label(
                            title: { Text("Sent Feedback").foregroundColor(.black) },
                            icon: { Image(systemName: "paperplane.circle.fill").renderingMode(.original) }
                        )
                    })
                    
                }
                
                Section (header: Text("To-be Useless")) {
                    Button(action: {
                        if let windowScene = UIApplication.shared.windows.first?.windowScene { SKStoreReviewController.requestReview(in: windowScene)
                        }
                    }, label: {
                        Label(
                            title: { Text("Rate This App").foregroundColor(.black) },
                            icon: { Image(systemName: "star.fill").renderingMode(.original) }
                        )
                    })
                    
                    Button(action: {
                        guard let data = URL(string: "https://testflight.apple.com/join/zYXqFRmM") else { return }
                        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                    }, label: {
                        Label(
                            title: { Text("Share With Friends").foregroundColor(.black) },
                            icon: { Image(systemName: "square.and.arrow.up").foregroundColor(.orange) }
                        )
                    })
                    
                    NavigationLink(
                        destination: AboutView(),
                        label: {
                            Label(
                                title: { Text("About Us").foregroundColor(.black) },
                                icon: { Image(systemName: "leaf.fill").renderingMode(.original) }
                            )
                        })
                }
                
                HStack {
                    Spacer()
                    
                    Text("To-be Useless Version Beta \(version)")
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    self.developerCounter += 1
                    if developerCounter == 20 {
                        developerCounter = 0
                        showAlert.toggle()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "square.and.arrow.up.on.square").foregroundColor(.gray.opacity(0))
                            .padding()
                    }
                })
                .alert(isPresented: $showAlert, content: {
                    return Alert(title: Text("Activate Developer Mode?"),
                                 message: Text("Wrong use will lead to serious errors"),
                                 primaryButton: .default(Text("Yes"), action: {
                                    developerActivated.toggle()
                                 }),
                                 secondaryButton: .destructive(Text("No"))
                    
                    )
                })
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}


extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }

}
