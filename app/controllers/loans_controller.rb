class LoansController < ApplicationController
  before_filter :check_user_signed_in
  before_action :set_loan, only: [:show, :edit, :update, :destroy, :prolong, :return_book]
  helper_method :sort_column,:sort_direction

  def check_user_signed_in
    if !admin_signed_in?
      authenticate_user!
    end
  end

  # GET /loans
  # GET /loans.json
  def index
    authenticate_admin!
    @loans = Loan.get_actual_loans
    @loans = sort_loans(@loans, sort_column, sort_direction)  
  end

  # GET /loans/1
  # GET /loans/1.json
  def show
    @book = Book.search_by_czu_number(params[:book_id])
    @user_name_surname = User.get_name(params[:user_id]).to_s + " " + User.get_surname(params[:user_id]).to_s
  end

  # GET /loans/new
  def new
    authenticate_admin!
    @loan = Loan.new
    @loan_length = Setting.get_loan_time
    @book_id = params[:id]
    @book = Book.search_by_czu_number(@book_id)
    @users = User.approved_users.order(:surname)
    @all_reservations = Reservation.get_all_book_reservations(@book_id).order("created_at ASC")
    @reservation_count = @all_reservations.count
    @prev_loan = params[:prev_loan]
    @previous_user_id = nil
    if !@prev_loan.nil?
      @previous_user_id= params[:user_id]
      @users = @users.where.not(id: @previous_user_id)
    end
  end

  # GET /loans/1/edit
  # def edit
  # end

  # POST /loans
  # POST /loans.json
  def create
    @loan = Loan.new(loan_params)
    respond_to do |format|
      if @loan.save
        Reservation.check_and_delete_reservation(@loan.user_id, @loan.book_id)
        if !params[:loan][:prev_loan_id].blank?
          prev_loan_id = params[:loan][:prev_loan_id]
          Loan.return_book(Loan.get_loan_by_id(prev_loan_id))
        end
        format.html { redirect_to loans_user_all_path(:id => @loan.user_id), notice: 'Výpůjčka byla úspěšně uložena do databáze.' }
        format.json { render :show, status: :created, location: @loan }
      else
        flash.now[:error] = @loan.errors.full_messages
        @users = User.all.order(:surname)
        @book_id = @loan.book_id
        @book = Book.search_by_czu_number(@book_id)
        @loan_length = Setting.get_loan_time
        @all_reservations = Reservation.get_all_book_reservations(@book_id).order("created_at ASC")
        @reservation_count = @all_reservations.count
        format.html { render :new, error: 'Výpůjčka nebyla uložena do databáze.'}
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loans/1
  # PATCH/PUT /loans/1.json
  # def update
  #   respond_to do |format|
  #     if @loan.update(loan_params)
  #       format.html { redirect_to @loan, notice: 'Loan was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @loan }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @loan.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /loans/1
  # DELETE /loans/1.json
  def destroy
    authenticate_admin!
    @loan.destroy
    respond_to do |format|
      format.html { redirect_to loans_url, notice: 'Výpůjčka byla úspěšně smazána.' }
      format.json { head :no_content }
    end
  end

  def user 
    all_loans = Loan.get_users_loan(params[:id])
    @loans = all_loans.get_actual_loans
    @loans = sort_loans(@loans, sort_column, sort_direction)  
  end

  def prolong
     prolong_length = Setting.get_loan_prolong_time
     max_loan_length = Setting.get_max_loan_time
     if !Loan.prolong(@loan, prolong_length, max_loan_length)
        flash[:notice] = "Výpůjčku lze prodloužit nejdéle do " + @loan.to.to_s
     else
        flash[:notice] = "Výpůjčka byla úspěšně prodloužena do " + @loan.to.to_s
     end

    if admin_signed_in?
      redirect_to loans_user_all_path(:id => @loan.user_id)
    else
      redirect_to loans_user_path(:id => @loan.user_id)
    end

  end

  def return_book
    authenticate_admin!
    user_id = @loan.user_id
    if Loan.return_book(@loan)
      flash[:notice] = "Výpůjčka byla úspěšně vrácena."
    else
      flash[:error] = "Výpůjčku se nepodařilo úspešně vrátit."
     end  
     redirect_to loans_user_all_path(:id => user_id)
  end

  def history
    authenticate_admin!
    @history_loans = Loan.get_loans_history
    @history_loans = sort_loans(@history_loans, sort_column, sort_direction)  
  end

  def user_all
    authenticate_admin!
    @user_id = params[:id]
    @loan_length = Setting.get_loan_time
    all_users_loans  = Loan.get_users_loan(@user_id)
    @loans = all_users_loans.get_actual_loans
    @history_loans = all_users_loans.get_loans_history
    @reservations = Reservation.get_users_reservations(@user_id)
    sort_c = sort_column
    if sort_c.include?"actual"
      sort_c =sort_c.gsub("actual_", "")
      @loans = sort_loans(@loans, sort_c, sort_direction)  
    elsif sort_c.include?"history"
      sort_c =sort_c.gsub("history_", "")
      @history_loans = sort_loans(@history_loans, sort_c, sort_direction)        
    else
      sort_c =sort_c.gsub("reservation_", "")
      @reservations = sort_reservations(sort_c, @reservations)
    end
  end

  def user_history
    all_loans = Loan.get_users_loan(params[:id])
    @loans = all_loans.get_loans_history
    @loans = sort_loans(@loans, sort_column, sort_direction)  
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params[:id])
    end

    def sort_loans(loans, param_sort, param_direction)
      if param_sort == "user_id"
         loans =  loans.includes(:user).order("users.surname " + sort_direction)
      elsif param_sort == "from"
            loans = (loans).order(from: param_direction.parameterize.underscore.to_sym)
      elsif param_sort == "to"
            loans = (loans).order(to: param_direction.parameterize.underscore.to_sym)
      elsif param_sort == "name"
         loans =  loans.includes(:book).order("books.name " + sort_direction)
      elsif param_sort == "author_name"
          loans =  loans.includes(:book).order("books.author_name " + sort_direction)
      elsif param_sort == "returned"
          loans =  loans.order(returned: param_direction.parameterize.underscore.to_sym)
      end
      return loans
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loan_params
      params.require(:loan).permit(:book_id, :user_id, :from, :to)
    end

    def sort_column
      !params[:sort].nil? ? params[:sort] : "from"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

end
