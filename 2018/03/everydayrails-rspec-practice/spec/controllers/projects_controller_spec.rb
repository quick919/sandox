require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    # 認証済みユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryGirl.create(:user)
      end

      # 正常にレスポンスを返す
      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_success
      end

      # 200レスポンスを返す
      it "returns a 200 response" do
        sign_in @user
        get :index
        expect(response).to have_http_status "200"
      end
    end

    context "as a guest" do
      # 302レスポンスを返す
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status "302"
      end

      # サインイン画面にリダイレクトする
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do
  
    # 認可されたユーザーとして
    context "as an authorized user" do
      before do
        @user = FactoryGirl.create(:user)
        @project = FactoryGirl.create(:project, owner: @user)  
      end

       # 正常にレスポンスを返す
       it "responds successfully" do
        sign_in @user
        get :show, params: { id: @project.id}
        expect(response).to be_success
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryGirl.create(:user)
        other_user = FactoryGirl.create(:user)
        @project = FactoryGirl.create(:project, owner: other_user)  
      end

      # ダッシュボードにリダイレクトする
      it "redirects to the dashboard" do
        sign_in @user
        get :show, params: {id: @project.id}
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do
    # 認証済みのユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryGirl.create(:user)
      end

      # 有効な属性の場合
      context "with valid attributes" do
        # プロジェクトを追加できる
        it "adds a project" do
          project_params = FactoryGirl.attributes_for(:project)
          sign_in @user
          expect {
            post :create, params: { project: project_params }
          }.to change(@user.projects, :count).by(1)
        end
      end

      # 無効な属性値の場合
      context "with invalid attributes" do
        # プロジェクトが追加できない
        it "dose not add a project" do
          project_params = FactoryGirl.attributes_for(:project, :invalid)
          sign_in @user
          expect {
            post :create, params: { project: project_params }
          }.to_not change(@user.projects, :count)
        end
      end
    end

     # ゲストとして
     context "as an guest" do

      # 302レスポンスを返す
      it "returns a 302 response" do
        project_params = FactoryGirl.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status "302"
      end

      # サインイン画面へリダイレクトする
      it "redirects to the sign-in page" do
        project_params = FactoryGirl.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do
    # 認可されたユーザーとして
    context "as an authorized user" do
      before do
        @user = FactoryGirl.create(:user)
        @project = FactoryGirl.create(:project, owner: @user)
      end

      # プロジェクトを更新できる
      it "updates a project" do
        project_params = FactoryGirl.attributes_for(:project, name: "New Project Name")
        sign_in @user
        patch :update, params: {id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "New Project Name"
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryGirl.create(:user)
        other_user = FactoryGirl.create(:user)
        @project = FactoryGirl.create(:project,
          owner: other_user,
          name: "Same Old Name")
      end

      # プロジェクトを更新できない
      it "dose not update the project" do
        project_params = FactoryGirl.attributes_for(:project, name: "New Name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "Same Old Name"
      end

      # ダッシュボードへリダイレクトする
      it "redirects to the dashboard" do
        project_params = FactoryGirl.attributes_for(:project)
        puts project_params
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end

    # ゲストとして
    context "as a guest" do
      before do
        @project = FactoryGirl.create(:project)
      end

      # 302レスポンスを返す
      it "returns a 302 response" do
        project_params = FactoryGirl.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status "302"
      end
      
      # サインイン画面にリダイレクトする
      it "redirects to the sign-in page" do
        project_params = FactoryGirl.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#destory" do
    # 認可されたユーザーとして
    context "as an authorized user" do
      before do
        @user = FactoryGirl.create(:user)
        @project = FactoryGirl.create(:project, owner: @user)
      end

      # プロジェクトを削除できる
      it "deletes a project" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project }
        }.to change(@user.projects, :count).by(-1)
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryGirl.create(:user)
        other_user = FactoryGirl.create(:user)
        @project = FactoryGirl.create(:project, owner: other_user)
      end

      # プロジェクトを削除できない
      it "dose not delete the project" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end

      # ダッシュボードへリダイレクトする
      it "redirects to the dashboard" do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end

    # ゲストとして
    context "as a guest" do
      before do
        @project = FactoryGirl.create(:project)
      end

      # 302レスポンスを返す
      it "returns a 302 response" do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status "302"
      end
      
      # サインイン画面にリダイレクトする
      it "redirects to the sign-in page" do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end

      # プロジェクトを削除できない
      it "dose not delete the project" do
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end
    end
  end
end
