//
//  EditCandidateView.swift
//  HRDesk
//
//  Created by iPHTech 34 on 12/08/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct EditCandidateView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var candidateViewModel: CandidateViewModel

    let candidate: Candidate

    @State private var name: String
    @State private var role: String
    @State private var email: String
    @State private var phone: String
    @State private var stage: PipelineStage
    @State private var experience: String
    @State private var matchScore: Int
    @State private var showFileImporter = false
    @State private var resumeData: Data?
    @State private var resumeFileName: String?

    init(candidate: Candidate) {

        self.candidate = candidate

        _name = State(initialValue: candidate.name)
        _role = State(initialValue: candidate.role)
        _email = State(initialValue: candidate.email)
        _phone = State(initialValue: candidate.phone)
        _stage = State(initialValue: candidate.stage)
        _experience = State(initialValue: candidate.experience)
        _matchScore = State(initialValue: candidate.matchScore)
    }

    var body: some View {

        Form {

            Section("Basic Details") {

                TextField("Full Name", text: $name)

                TextField("Role", text: $role)

                TextField("Experience (e.g. 3 Yrs Exp)", text: $experience)
            }

            Section("Contact Details") {

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)

                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
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
                            .foregroundStyle(Color("textSecondary"))
                    }

                    Slider(
                        value: Binding(
                            get: { Double(matchScore) },
                            set: { matchScore = Int($0) }
                        ),
                        in: 0...100,
                        step: 1
                    )
                    .tint(Color("textSecondary"))
                }
            }

            Section("Resume") {

                Button {
                    showFileImporter = true
                } label: {

                    HStack(spacing: 10) {

                        Image(
                            systemName:
                                (resumeData != nil || candidate.hasResume)
                                ? "doc.fill"
                                : "doc.badge.plus"
                        )
                        .font(.body)

                        Text(
                            resumeFileName
                                ?? (candidate.hasResume
                                    ? "Resume Attached"
                                    : "Attach Resume (PDF)")
                        )
                        .font(.subheadline)
                        .lineLimit(1)

                        Spacer()

                        if resumeData != nil || candidate.hasResume {

                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    .foregroundStyle(
                        Color("textSecondary")
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
            resume: resumeData
        )

        dismiss()
    }
}

#Preview {

    NavigationStack {

        EditCandidateView(
            candidate: Candidate(
                id: UUID(),
                name: "Sophia Carter",
                role: "Product Designer",
                stage: .interview,
                experience: "3 Yrs Exp",
                matchScore: 92,
                appliedDate: "2 days ago",
                email: "sophia@gmail.com",
                phone: "(415) 123-4567",
                jobID: nil,
                hasResume: true
            )
        )
        .environmentObject(CandidateViewModel())
    }
}
