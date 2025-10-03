//
//  FeedView.swift
//  Back4App
//
//  Created by cecetoni on 10/3/25.
//

import Foundation
import SwiftUI
import Parse

struct FeedView: View {
    @State private var posts: [PFObject] = []
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var caption = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List(posts, id: \.objectId) { post in
                    VStack(alignment: .leading) {
                        if let file = post["imageFile"] as? PFFileObject,
                           let urlString = file.url,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        Text(post["caption"] as? String ?? "")
                            .font(.subheadline)
                        Text("by \(post["author"] as? PFUser)?.username ?? "unknown"")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                HStack {
                    Button("Upload Photo") {
                        showingImagePicker = true
                    }
                    Spacer()
                    Button("Logout") {
                        PFUser.logOutInBackground { _ in
                            posts.removeAll()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Feed")
            .onAppear {
                fetchPosts()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, onComplete: {
                    if let img = selectedImage {
                        uploadPost(image: img, caption: caption)
                    }
                    selectedImage = nil
                })
            }
        }
    }
    
    func fetchPosts() {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 10
        query.findObjectsInBackground { results, error in
            if let results = results {
                posts = results
            } else if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
            }
        }
    }
    
    func uploadPost(image: UIImage, caption: String?) {
        guard let data = image.pngData() else { return }
        let file = PFFileObject(name: "photo.png", data: data)
        
        let post = PFObject(className: "Post")
        post["imageFile"] = file
        post["caption"] = caption ?? ""
        post["author"] = PFUser.current()
        
        post.saveInBackground { success, error in
            if success {
                fetchPosts()
            } else if let error = error {
                print("Upload error: \(error.localizedDescription)")
            }
        }
    }
}
