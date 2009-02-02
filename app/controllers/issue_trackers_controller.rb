class IssueTrackersController < ApplicationController
  # GET /issue_trackers
  # GET /issue_trackers.xml
  def index
    @issue_trackers = IssueTracker.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @issue_trackers }
    end
  end

  # GET /issue_trackers/1
  # GET /issue_trackers/1.xml
  def show
    @issue_tracker = IssueTracker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @issue_tracker }
    end
  end

  # GET /issue_trackers/new
  # GET /issue_trackers/new.xml
  def new
    @issue_tracker = IssueTracker.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @issue_tracker }
    end
  end

  # GET /issue_trackers/1/edit
  def edit
    @issue_tracker = IssueTracker.find(params[:id])
  end

  # POST /issue_trackers
  # POST /issue_trackers.xml
  def create
    @issue_tracker = IssueTracker.new(params[:issue_tracker])

    respond_to do |format|
      if @issue_tracker.save
        flash[:notice] = 'IssueTracker was successfully created.'
        format.html { redirect_to(@issue_tracker) }
        format.xml  { render :xml => @issue_tracker, :status => :created, :location => @issue_tracker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @issue_tracker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /issue_trackers/1
  # PUT /issue_trackers/1.xml
  def update
    @issue_tracker = IssueTracker.find(params[:id])

    respond_to do |format|
      if @issue_tracker.update_attributes(params[:issue_tracker])
        flash[:notice] = 'IssueTracker was successfully updated.'
        format.html { redirect_to(@issue_tracker) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @issue_tracker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_trackers/1
  # DELETE /issue_trackers/1.xml
  def destroy
    @issue_tracker = IssueTracker.find(params[:id])
    @issue_tracker.destroy

    respond_to do |format|
      format.html { redirect_to(issue_trackers_url) }
      format.xml  { head :ok }
    end
  end
end
