class ReservationsController < ApplicationController
  before_filter :check_user_signed_in
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  def check_user_signed_in
    if !admin_signed_in?
      authenticate_user!
    end
  end

  # GET /reservations
  # GET /reservations.json
  def index
    authenticate_admin!
    @loan_length = Setting.get_loan_time
    column = sort_column
    @reservations = Reservation.all
    @reservations = sort_reservations(column, @reservations)
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    @book = Book.search_by_czu_number(params[:book_id])
    @user_name_surname = User.get_name(params[:user_id]).to_s + " " + User.get_surname(params[:user_id]).to_s
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
    @book_id = params[:id]
    @book = Book.search_by_czu_number(@book_id)
    @users = User.approved_users.order(:surname)
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    respond_to do |format|
      if @reservation.save
        if admin_signed_in?
          format.html { redirect_to loans_user_all_path(:id => @reservation.user_id), notice: 'Rezervace byla úspěšně uložena.' }
        else
          format.html { redirect_to reservation_path(:id => @reservation.id, :book_id => @reservation.book_id, :user_id => @reservation.user_id), notice: 'Rezervace byla úspěšně uložena.' }
       end
        format.json { render :show, status: :created, location: @reservation }
      elsif admin_signed_in?
        flash.now[:error] = @reservation.errors.full_messages
        @users = User.all.order(:surname)
        @book_id = @reservation.book_id
        @book = Book.search_by_czu_number(@book_id)
        format.html { render :new}
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      else
        format.html { redirect_to books_detail_path(:id => @reservation.book_id), error: 'Rezervaci se nepodařilo úspěšně uložit.'}
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  # def update
  #   respond_to do |format|
  #     if @reservation.update(reservation_params)
  #       format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @reservation }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @reservation.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    user_id = @reservation.user_id
    @reservation.destroy
    respond_to do |format|
      if admin_signed_in?
        format.html { redirect_to loans_user_all_path(:id => user_id), notice: 'Rezervace byla úspěšně smazána.' }
      else
        format.html { redirect_to reservations_user_path(:id => params[:user_id]), notice: 'Rezervace byla úspěšně smazána.' }
      end
      format.json { head :no_content }
    end
  end

  def user
    user_id = params[:id]
    @reservations = Reservation.get_users_reservations(user_id)
    if params[:sort] == "author_name"
      @reservations =  @reservations.includes(:book).order("books.name " + sort_direction)
    elsif params[:sort] == "name"
      @reservations =  @reservations.includes(:book).order("books.name " + sort_direction)
    else
      @reservations = @reservations.order(sort_column + " " + sort_direction)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.require(:reservation).permit(:book_id, :user_id)
    end

    def sort_column
      !params[:sort].nil? ? params[:sort] : "created_at"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
