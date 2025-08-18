class LoansController < ApplicationController
  before_action :set_loan, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /loans or /loans.json
  def index
    @loans = Loan.includes(:member).all
    @total_loans = Loan.sum(:amount)
    @repayments = LoanRepayment.all
    @total_repayments = @repayments.sum(:amount)
    @loan_balance = @total_loans - @total_repayments
  end

  # GET /loans/1 or /loans/1.json
  def show
  end

  # GET /loans/new
  def new
    @loan = Loan.new
    @loan.member_id = params[:member_id] if params[:member_id].present?
    @members = Member.all
    @available_for_loans = nil # only set after selecting member
  end

  # GET /loans/1/edit
  def edit
  end

  # POST /loans or /loans.json
  def create
    @loan = Loan.new(loan_params)

    respond_to do |format|
      if @loan.save
        format.html { redirect_to @loan, notice: "Loan was successfully created." }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loans/1 or /loans/1.json
  def update
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to @loan, notice: "Loan was successfully updated." }
        format.json { render :show, status: :ok, location: @loan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1 or /loans/1.json
  def destroy
    @loan.destroy!

    respond_to do |format|
      format.html { redirect_to loans_path, status: :see_other, notice: "Loan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def loan_params
      params.expect(loan: [ :member_id, :available_amount, :amount, :payment_period_months, :repayment_amount_per_month, :user_id ])
    end
end
