//
//  EditCandidateView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 12/08/26.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreData

struct EditCandidateView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var candidateViewModel: CandidateViewModel

    let candidate: CandidateEntity

    @State private var name: String
    @State private var role: String
    @State private var email: String
    @State private var phone: String
    @State private var stage: PipelineStage
    @State private var experience: String
    @State private var noticePeriod: String
    @State private var expectedSalary: String
    @State private var about: String
    @State private var location: String
    @State private var website: String
    @State private var matchScore: Int
    @State private var showFileImporter = false
    @State private var resumeData: Data?
    @State private var resumeFileName: String?

    init(candidate: CandidateEntity) {

        self.candidate = candidate

        _name = State(initialValue: candidate.fullName ?? "")
        _role = State(initialValue: candidate.role ?? "")
        _email = State(initialValue: candidate.email ?? "")
        _phone = State(initialValue: candidate.phone ?? "")
        _stage = State(initialValue: candidate.stage)
        _experience = State(initialValue: candidate.experience ?? "")
        _noticePeriod = State(initialValue: candidate.noticePeriod ?? "")
        _expectedSalary = State(initialValue: candidate.expectedSalary ?? "")
        _about = State(initialValue: candidate.about ?? "")
        _location = State(initialValue: candidate.location ?? "")
        _website = State(initialValue: candidate.website ?? "")
        _matchScore = State(initialValue: Int(candidate.matchScore))
    }

    var body: some View {

        Form {

            Section("Basic Details") {

                TextField("Full Name", text: $name)

                TextField("Role", text: $role)
                    .disabled(true)

                TextField("Experience (e.g. 3 Yrs Exp)", text: $experience)

                TextField("Notice Period (e.g. 30 Days)", text: $noticePeriod)

                TextField("Expected Salary (e.g. ₹15 LPA)", text: $expectedSalary)
            }

            Section("Contact Details") {

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)

                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)

                TextField("Location", text: $location)

                TextField("Website", text: $website)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
            }

            Section("About") {

                TextEditor(text: $about)
                    .frame(minHeight: 100)
            }

            Section("Pipeline") {

                Picker("Stage", selection: $stage) {

                    ForEach(PipelineStage.allCases, id: \.self) { stage in
                        Text(stage.title).tag(stage)
                    }
                }

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    HStack {

                        Text("Match Score")
                            .font(.subheadline)

                        Spacer()

                        Text("\(matchScore)%")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color("background"))
                    }

                    Slider(
                        value: Binding(
                            get: { Double(matchScore) },
                            set: { matchScore = Int($0) }
                        ),
                        in: 0...100,
                        step: 1
                    )
                    .tint(Color("background"))
                }
            }

            Section("Resume") {

                Button {
                    showFileImporter = true
                } label: {

                    HStack(spacing: 10) {

                        Image(
                            systemName:
                                (resumeData != nil || !candidate.resume.isEmpty)
                                ? "doc.fill"
                                : "doc.badge.plus"
                        )
                        .font(.body)

                        Text(
                            resumeFileName
                                ?? (!candidate.resume.isEmpty
                                    ? "Resume Attached"
                                    : "Attach Resume (PDF)")
                        )
                        .font(.subheadline)
                        .lineLimit(1)

                        Spacer()

                        if resumeData != nil || !candidate.resume.isEmpty {

                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    .foregroundStyle(
                        Color("background")
                    )
                }
            }

            Section {

                Button {
                    saveCandidate()
                } label: {

                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                }
                .disabled(
                    name.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty
                )
            }
        }
        .navigationTitle("Edit Candidate")
        .navigationBarTitleDisplayMode(.inline)
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.pdf, .plainText],
            allowsMultipleSelection: false
        ) { result in

            switch result {

            case .success(let urls):

                guard let url = urls.first,
                      url.startAccessingSecurityScopedResource() else {
                    return
                }

                defer {
                    url.stopAccessingSecurityScopedResource()
                }

                if let data = try? Data(contentsOf: url) {

                    resumeData = data
                    resumeFileName = url.lastPathComponent
                }

            case .failure:
                break
            }
        }
    }

    private func saveCandidate() {

        candidateViewModel.updateCandidate(
            candidate,
            name: name,
            role: role,
            email: email,
            phone: phone,
            stage: stage,
            experience: experience,
            matchScore: matchScore,
            noticePeriod: noticePeriod,
            expectedSalary: expectedSalary,
            about: about,
            location: location,
            website: website.isEmpty ? nil : website,
            resume: resumeData
        )

        dismiss()
    }
}

#Preview {

    NavigationStack {

        EditCandidateView(
            candidate: {
                let context = PersistenceController.preview.container.viewContext
                let candidate = CandidateEntity(context: context)
                candidate.id = UUID()
                candidate.fullName = "Sophia Carter"
                candidate.role = "Product Designer"
                candidate.email = "sophia@gmail.com"
                candidate.phone = "(415) 123-4567"
                candidate.experience = "3 Yrs Exp"
                candidate.noticePeriod = "30 Days"
                candidate.expectedSalary = "₹15 LPA"
                candidate.location = "San Francisco, CA"
                candidate.website = "https://www.sophiacarter.com"
                candidate.about = "Product Designer with a passion for user-centered design."
                candidate.resumeData = Data()
                candidate.status = PipelineStage.interview.rawValue
                candidate.matchScore = 92
                candidate.appliedDate = "2 days ago"
                return candidate
            }()
        )
        .environmentObject(CandidateViewModel())
    }
}
