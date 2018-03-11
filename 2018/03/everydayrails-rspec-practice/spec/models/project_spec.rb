require 'rails_helper'

RSpec.describe Project, type: :model do
  # ユーザー単位では重複したプロジェクト名を許可しない
  it "does not allow duplicate project names per user" do
    user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    user.projects.create(
      name: "Test Project",
    )
    new_project = user.projects.build(
      name: "Test Project",
    )
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可する
  it "allows two users to share a project name" do
    user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    user.projects.create(
      name: "Test Project",
    )

    other_user = User.create(
      first_name: "Jane",
      last_name:  "Tester",
      email:      "janetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    other_project = other_user.projects.build(
      name: "Test Project",
    )
    expect(other_project).to be_valid
  end

  # たくさんのメモがついている
  it "can have many notes" do
    project = FactoryGirl.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

  describe "late status" do
    # 締切が過ぎていれば遅延している
    it "is late when the due is past today" do
      project = FactoryGirl.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    # 締切が今日ならスケジュールどおりである
    it "is on time when the due date is today" do
      project = FactoryGirl.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締切が未来ならスケジュールどおりである
    it "is on time when the due date is in future" do
      project = FactoryGirl.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
