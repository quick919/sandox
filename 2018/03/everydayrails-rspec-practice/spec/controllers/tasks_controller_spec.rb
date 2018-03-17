require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  before do
    @user = FactoryGirl.create(:user)
    @project = FactoryGirl.create(:project, owner: @user)
    @task = @project.tasks.create!(name: "Test task")
  end

  describe "#show" do
    #JSON形式でレスポンスを返す
    it "responds with JSON formatted output" do
      sign_in @user
      get :show, format: :json,
      params: { project_id: @project.id, id: @task.id }
      expect(response.content_type).to eq "application/json"
    end
  end

  describe "#create" do
    #JSON形式でレスポンスを返す
    it "responds with JSON formatted output" do
      new_task = { name: "New test task" }
      sign_in @user
      post :create, format: :json,
      params: { project_id: @project.id, task: new_task }
      expect(response.content_type).to eq "application/json"
    end

    # 新しいタスクをプロジェクトに追加する
    it "adds a new task to the project" do
      new_task = { name: "New test task" }
      sign_in @user
      expect {
        post :create, format: :json,
        params: { project_id: @project.id, task: new_task }
      }.to change(@project.tasks, :count).by(1)
    end

    # 承認を要求する
    it "requires authentication" do
      new_task = { name: "New test task" }
      # ここではあえてログインしない
      expect {
        post :create, format: :json,
        params: { project_id: @project.id, task: new_task }
      }.to_not change(@project.tasks, :count)
      expect(response).to_not be_success
    end
  end
end
