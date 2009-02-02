require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../spec_controller_helper')

describe NewsItemsController do
  include AuthenticateSpecHelper

  def mock_news_item(stubs={})
    @mock_news_item ||= mock_model(NewsItem, stubs)
  end
  
  describe "when user" do
    describe "not logged in" do
      it "all actions except :index and :show should fail" do
        controller_actions_should_fail_if_not_logged_in :except => ['index', 'show']
      end  
    end

    describe "not a site administrator" do
      before(:each) do
        NewsItem.stub!(:find).and_return(mock_news_item)
      end

      it "all actions except :index and :show should fail" do
        controller_actions_should_fail_if_not_site_admin :except => ['index', 'show']
      end  
    end
  end

  describe "responding to GET index" do
    it "should expose all news_items as @news_items" do
      NewsItem.should_receive(:all).and_return([mock_news_item])
      get :index 
      assigns[:news_items].should == [mock_news_item]
    end

    it "should render index template'" do
      get :index 
      response.should render_template(:index)
    end
  end

  describe "responding to GET new" do
    it "should expose a new news_item as @news_item" do
      NewsItem.should_receive(:new).and_return(mock_news_item)
      do_action_with_site_admin :get, :new, {}
      assigns[:news_item].should equal(mock_news_item)
    end

    it "should render new template'" do
      do_action_with_site_admin :get, :new, {} 
      response.should render_template(:new)
    end
  end

  describe "responding to GET edit" do
    before(:each) do
      NewsItem.stub!(:find).and_return(mock_news_item)
    end

    it "should expose the requested news_item as @news_item" do
      NewsItem.should_receive(:find).with("37").and_return(mock_news_item)
      do_action_with_site_admin :get, :edit, { :id => "37" } 
      assigns[:news_item].should equal(mock_news_item)
    end

    it "should render edit template'" do
      do_action_with_site_admin :get, :edit, { :id => "37" } 
      response.should render_template(:edit)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created news_item as @news_item" do
        NewsItem.should_receive(:new).with({'these' => 'params'}).and_return(mock_news_item(:save => true))
        do_action_with_site_admin :post, :create, { :news_item => { :these => 'params' } }
        assigns(:news_item).should equal(mock_news_item)
      end

      it "should redirect to the created news_item" do
        NewsItem.stub!(:new).and_return(mock_news_item(:save => true))
        do_action_with_site_admin :post, :create, { :news_item => {} }
        response.should redirect_to(news_item_url(mock_news_item))
      end
    end

    describe "with invalid params" do
      it "should expose a newly created but unsaved news_item as @news_item" do
        NewsItem.stub!(:new).with({'these' => 'params'}).and_return(mock_news_item(:save => false))
        do_action_with_site_admin :post, :create, { :news_item => { :these => 'params' } }
        assigns(:news_item).should equal(mock_news_item)
      end

      it "should re-render the 'new' template" do
        NewsItem.stub!(:new).and_return(mock_news_item(:save => false))
        do_action_with_site_admin :post, :create, { :news_item => {} }
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      before(:each) do
        NewsItem.stub!(:find).and_return(mock_news_item(:update_attributes => true))
      end
      
      it "should update the requested news_item" do
        NewsItem.should_receive(:find).with("37").and_return(mock_news_item)
        mock_news_item.should_receive(:update_attributes).with({ 'these' => 'params' })
        do_action_with_site_admin :put, :update, { :id => "37", :news_item => { :these => 'params' } }
      end

      it "should expose the requested news_item as @news_item" do
        do_action_with_site_admin :put, :update, { :id => "37" }
        assigns(:news_item).should equal(mock_news_item)
      end

      it "should redirect to the news_item" do
         do_action_with_site_admin :put, :update, { :id => "37" }
        response.should redirect_to(news_item_url(mock_news_item))
      end
    end

    describe "with invalid params" do
      before(:each) do
        NewsItem.stub!(:find).and_return(mock_news_item(:update_attributes => false))
      end
      
      it "should update the requested news_item" do
        NewsItem.should_receive(:find).with("37").and_return(mock_news_item)
        mock_news_item.should_receive(:update_attributes).with({'these' => 'params'})
        do_action_with_site_admin :put, :update, { :id => "37", :news_item => {:these => 'params'} }
      end

      it "should expose the news_item as @news_item" do
        do_action_with_site_admin :put, :update, { :id => "37" }
        assigns(:news_item).should equal(mock_news_item)
      end

      it "should re-render the 'edit' template" do
        do_action_with_site_admin :put, :update, { :id => "37" }
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested news_item" do
      NewsItem.should_receive(:find).with("37").and_return(mock_news_item)
      mock_news_item.should_receive(:destroy)
      do_action_with_site_admin :delete, :destroy, { :id => "37" }
    end

    it "should redirect to the news_items list" do
      NewsItem.stub!(:find).and_return(mock_news_item(:destroy => true))
      do_action_with_site_admin :delete, :destroy, { :id => "37" }
      response.should redirect_to(news_items_url)
    end
  end
end
