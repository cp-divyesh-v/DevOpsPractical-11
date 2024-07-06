//
//  DictionaryView.swift
//  DevOpsPractical11
//
//  Created by Divyesh Vekariya on 04/05/24.
//

import SwiftUI
import AVFoundation

struct DictionaryView: View {
    @StateObject private var viewModel = DictionaryViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText, onSearch: viewModel.getMeaningOf)
                    .padding()
                if let dictionary = viewModel.dictionary {
                    DictionaryResultView(dictionaries: dictionary)
                } else {
                    Text(viewModel.searchText.isEmpty ? "" : "No results found")
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .navigationBarTitle("Dictionary")
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

struct DictionaryView_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryView()
    }
}

// Search bar
struct SearchBar: View {
    @Binding var text: String
    var onSearch: (String) -> Void
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .disableAutocorrection(true)
            
            Button(action: {
                onSearch(text)
            }) {
                Image(systemName: "magnifyingglass")
            }
            .padding(8)
        }
    }
}

// Result
struct DictionaryResultView: View {
    let dictionaries: [Dictionary]
    
    var body: some View {
        if dictionaries.isEmpty {
            Text("No results found")
                .foregroundColor(.secondary)
        } else {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(dictionaries, id: \.self) { dictionary in
                        DictionaryItemView(dictionary: dictionary)
                    }
                    .padding()
                }
            }
            .padding(.top, 20)
        }
    }
}


struct DictionaryItemView: View {
    let dictionary: Dictionary
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Word: \(dictionary.word)")
                .font(.title)
                .fontWeight(.bold)
            if !dictionary.phonetics.isEmpty {
                ForEach(dictionary.phonetics, id: \.self) { phonetic in
                    PhoneticView(phonetic: phonetic)
                }
            }
            if let meanings = dictionary.meanings {
                ForEach(meanings, id: \.self) { meaning in
                    MeaningView(meaning: meaning)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct PhoneticView: View {
    @State var song1 = false
    @StateObject private var soundManager = SoundManager()
    let phonetic: Phonetic
    
    var body: some View {
        if let audio = phonetic.audio, !audio.isEmpty {
            Button(action: {
                soundManager.playSound(sound: audio)
                song1.toggle()
                
                if song1 {
                    soundManager.audioPlayer?.play()
                } else {
                    soundManager.audioPlayer?.pause()
                }
            }) {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.accentColor)
                    .padding(.top, 4)
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
    }
}


struct MeaningView: View {
    let meaning: Meaning
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Part of Speech: \(meaning.partOfSpeech)")
                .font(.headline)
            ForEach(meaning.definitions, id: \.self) { definition in
                DefinitionView(definition: definition)
            }
        }
        .padding(8)
        .background(Color(.systemGray5))
        .cornerRadius(8)
    }
}

struct DefinitionView: View {
    let definition: Definition
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Definition: \(definition.definition ?? "")")
            if let example = definition.example {
                Text("Example: \(example)")
            }
        }
        .padding(.leading, 20)
    }
}


class SoundManager : ObservableObject {
    var audioPlayer: AVPlayer?

    func playSound(sound: String){
        if let url = URL(string: sound) {
            self.audioPlayer = AVPlayer(url: url)
        }
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
