class UserEventsController < ApplicationController
  before_action :set_user_event, only: [:show, :edit, :update, :destroy]
  before_filter :get_event, :get_users, :get_all_events

  def get_user
    @user = current_user
  end

  def get_users
    @users = User.all.order(:name)
  end

  def get_event
    @event = Event.find(params[:event_id])
  end

  def get_all_events
    @events = Event.all.order(:start).order(:name)
  end

  # GET /user_events
  # GET /user_events.json
  def index
    @user_events = @event.user_events
  end

  # GET /user_events/1
  # GET /user_events/1.json
  def show
  end

  # GET /user_events/new
  def new
    if current_user.admin?
      @user_event = UserEvent.new({:event => @event})
    else
      @user_event = UserEvent.new({:user => current_user, :event => @event})
    end
  end

  # GET /user_events/1/edit
  def edit
  end

  # POST /user_events
  # POST /user_events.json
  def create
    # this one is trickier, due to users needing to be able to do it.
    # here, we want to use the current user -- but we might have a way to have an admin register someone?
    # Note: we also don't want to create a user event if one already exists
    @user_event = @event.user_events.create(user_event_params)
    unless current_user.admin?
      @user_event.user = current_user
    end

    respond_to do |format|
      if @user_event.save
        # on the notice add the event name
        format.html { redirect_to [@event, @user_event], notice: 'User was successfully registered.' }
        format.json { render :show, status: :created, location: [@event, @user_event] }
      else
        format.html { render :new }
        format.json { render json: @user_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_events/1
  # PATCH/PUT /user_events/1.json
  def update
    respond_to do |format|
      if @user_event.update(user_event_params)
        format.html { redirect_to [@event, @user_event], notice: 'User event was successfully updated.' }
        format.json { render :show, status: :ok, location: [@event, @user_event] }
      else
        format.html { render :edit }
        format.json { render json: @user_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_events/1
  # DELETE /user_events/1.json
  def destroy
    # TODO - force to current user if not admin.
    # TODO - if not admin, redirect to home.
    @user_event.destroy
    respond_to do |format|
      format.html { redirect_to events_path, notice: 'User event was successfully unregistered.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_event
    @user_event = UserEvent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_event_params
    params.require(:user_event).permit(:user_id, :event_id, :paid)
  end
end
