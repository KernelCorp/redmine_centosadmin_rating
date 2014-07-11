require File.dirname(__FILE__) + '/../spec_helper'

describe RatingsController do
  fixtures :users, :issues

  let(:evaluated) {User.first}
  let(:evaluator) {User.last}

  let(:valid_attributes) do
    {evaluated_id: User.first.id, evaluator_id: User.last.id, mark: 1, comments: 'ok', issue_id: Issue.first.id}
  end

  describe 'GET index' do
    before :each do
      @ratings = [create(:rating, evaluated: evaluated, evaluator: evaluator)]
      #puts Rating.count
    end

    it 'assigns all ratings as @ratings' do
      get :index
      expect(assigns(:ratings)).to eq(@ratings)
    end
  end

  describe 'GET show' do
    before :each do
      @rating = create(:rating, evaluated: evaluated, evaluator: evaluator)
      get :show, id: @rating
    end

    it 'assigns rating as @rating' do
      expect(assigns :rating).to eq(@rating)
    end
  end

  describe 'GET new' do
    it 'assigns a new rating as @raiting' do
      get :new
      assigns(:rating).should be_a_new(Rating)
    end

    describe 'as subresource of issue' do
      before :each do
        @issue = Issue.first
        get :new, issue_id: @issue
      end

      it 'set issue for @rating' do
        expect(assigns(:rating).issue).to eq(@issue)
      end

      it 'set evaluated as @issue.assigned_to' do
        expect(assigns(:rating).evaluated).to eq(@issue.assigned_to)
      end
    end

    describe 'as subresource of users' do
      before :each do
        @user = User.first
        get :new, user_id: @user
      end

      it 'set evaluated as @user' do
        expect(assigns(:rating).evaluated).to eq(@user)
      end
    end
  end

  describe 'POST create' do
    describe 'with valid attributes' do
      before :all do
        User.current = evaluated
      end

      it 'creates a new CentosRating' do
        expect {
          post :create, rating: valid_attributes
        }.to change{Rating.count}.by(1)
      end
      it 'assigns a newly created rating as @rating' do
        post :create, rating: valid_attributes
        expect(assigns :rating).to be_a(Rating)
        expect(assigns :rating).to be_persisted
      end

      it 'redirects to the created rating' do
        post :create, rating: valid_attributes
        response.should redirect_to(Rating.last)
      end
    end
  end

  describe 'GET edit' do
    it 'assigns the requested rating as @rating' do
      @rating = create(:rating, evaluated: evaluated, evaluator: evaluator)
      get :edit, id: @rating.to_param
      expect(assigns :rating).to eq(@rating)
    end
  end

  describe 'PUT update' do
    before :each do
      @rating = create(:rating, evaluated: evaluated, evaluator: evaluator)
      put :update, id: @rating.to_param, rating: {mark: 3}
    end
    it 'redirects to the created rating' do
      response.should redirect_to(Rating.last)
    end

    it 'update mark' do
      expect(@rating.reload.mark).to eq(3)
    end
  end

  describe 'DELETE destroy' do
    it 'destroy the requested rating' do
      @rating = create(:rating, evaluated: evaluated, evaluator: evaluator)
      expect {
        delete :destroy, id: @rating.to_param
      }.to change{Rating.count}.by(-1)
    end
  end
end