class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all - current_user.beer_clubs
    # @beer_clubs = BeerClub.all.reject{ |club| current_user.in? club.members }
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user
    club = BeerClub.find membership_params[:beer_club_id]
    name = (User.find_by id: @membership.user_id).username

    # Save membership for current user only if there is one (someone has to signed in).
    respond_to do |format|
      # if not current_user.in? club.members and @membership.save
      if not current_user.beer_clubs.include? @membership.beer_club and @membership.save
        current_user.memberships << @membership
        # redirect_to current_user
        format.html { redirect_to beer_club_path(club), notice: "#{name}, welcome to the #{@membership.beer_club.name}!" }
        format.json { render :show, status: :created, location: @membership }
      else
        @beer_clubs = BeerClub.all - current_user.beer_clubs
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    byebug
    @membership = Membership.user_id
    user = User.find_by id: @membership.user_id

    if current_user.beer_clubs.include? @membership.beer_club
      @membership.destroy
      respond_to do |format|
        format.html { redirect_to user_path(user), notice: "Membership in #{@membership.beer_club.name} is ended." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
