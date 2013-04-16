require 'spec_helper'

describe MicropostsController do
  render_views

  describe "access control" do
    it "should deny access to create" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to destroy" do
      post :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do

    before(:each) {
      @user = controller.sign_in(FactoryGirl.create(:user))
    }

    describe "success" do
      before(:each) do
        @attr = { :content => "some content" }
      end

      it "should create a new micropost" do
        lambda do
          post(:create, :micropost => @attr)
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect to the root path" do
        post(:create, :micropost => @attr)
        flash[:success].should =~ /created/i
        response.should redirect_to(root_path)
      end

    end

    describe "failure" do

      before(:each) do
        @attr = { :content => "" }
      end
      #it "should have the right title" do
      #  post(:create, :user => @attr)
      #  response.should have_selector('title', :content => "Sign up")
      #end

      it "should render the new page" do
        post(:create, :micropost => @attr)
        response.should render_template('pages/home')
      end

      it "should not create a new micropost" do
        lambda do
          post(:create, :micropost => @attr)
        end.should_not change(Micropost, :count)

      end

    end
  end

  describe "DELETE 'destroy'" do

    before(:each) {
      @user = FactoryGirl.create(:user)
      @micropost = FactoryGirl.create(:micropost, :user => @user)
    }

    describe "for an unauthorized user" do

      before(:each) do
        wrong_user = FactoryGirl.create(:user, :email => FactoryGirl.generate(:email))
        controller.sign_in(wrong_user)
      end

      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        controller.sign_in(@user)
      end

      it "should destroy the post" do
        lambda do
          delete :destroy, :id => @micropost
          flash[:success].should =~ /deleted/i
          response.should redirect_to(root_path)
        end.should change(Micropost, :count).by(-1)
      end
    end
  end
end
