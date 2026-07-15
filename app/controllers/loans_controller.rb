class LoansController < ApplicationController
  before_action :set_loan, only: %i[ show edit update destroy ]
  before_action :prevent_edit_if_closed, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_resource!, except: [:index]

  def authorize_resource!(resource = @loan)
    return unless current_user # skip if not signed in
    
    unless allowed?(current_user, resource, current_action_type)
      redirect_to root_path, alert: "Not authorized"
    end
  end

  # GET /loans or /loans.json
  def index
    @loans = Loan.includes(:member).all
    @total_loans = Loan.sum(:amount) + Loan.sum(:bank_charges)
    @repayments = LoanRepayment.all
    @total_repayments = @repayments.sum(:amount)
    @loan_balance = @total_loans - @total_repayments
  end

  # GET /loans/1 or /loans/1.json
  def show
    @loan = Loan.find(params[:id])
    @member = @loan.member
  end

  # GET /loans/new
  def new
    @loan = Loan.new
    @loan.member_id = params[:member_id] if params[:member_id].present?
    @members = Member.where(status: true)
    @available_for_loans = nil # only set after selecting member
  end

  # GET /loans/1/edit
  def edit
  end

  # POST /loans or /loans.json
  def create
  @loan = Loan.new(loan_params)

    respond_to do |format|
      begin
        Loan.transaction do
          # Save the new loan first
          @loan.save!

         # If this is a refinance, settle the old loan
        if @loan.is_refinance?
          old_loan = @loan.refinanced_from

          LoanRepayment.create!(
            loan: old_loan,
            user: current_user,
            amount: old_loan.balance,
            repayment_month: Date.current,
            repayment_date: Date.current,
            bank_charge_paid: true,
            is_refinance_settlement: true )
        
          unless old_loan.bank_charge_paid?
            Saving.create!(
              member: old_loan.member,
              user: current_user,
              amount: old_loan.bank_charges,
              transaction_type: "deposit",
              deposit_type: "Bank Charge Paid",
              month: Date.current)

          old_loan.update!(bank_charge_paid: true)
            
        end
      end
    end

        format.html do
          redirect_to @loan, notice: "Loan was successfully created."
      end

        format.json do
          render :show, status: :created, location: @loan
      end

      rescue ActiveRecord::RecordInvalid
        format.html do
          render :new, status: :unprocessable_entity
        end

        format.json do
          render json: @loan.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def refinance
    @old_loan = Loan.find(params[:id])

    unless @old_loan.can_refinance?
      redirect_to loans_path, alert: "Loan cannot be refinanced."
      return
    end

    @loan = Loan.new(
            member: @old_loan.member,
            member_id: @old_loan.member_id,
            user_id: current_user.id,
            is_refinance: true,
            refinanced_from: @old_loan,
            refinanced_from_id: @old_loan.id)
            
    render :new
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

  def toggle_status
  @loan = Loan.find(params[:id])
  new_status = ActiveModel::Type::Boolean.new.cast(params[:status])

  # Only allow toggle if fully repaid
  total_repaid = @loan.loan_repayments.sum(:amount)
  if total_repaid < @loan.amount
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          dom_id(@loan, :status),
          partial: "loans/status_toggle",
          locals: { loan: @loan, alert: "Cannot toggle: loan not fully repaid" }
        )
      end
      format.html { redirect_to loans_path, alert: "Cannot update status: loan not fully repaid." }
    end
    return
  end

  # Loan fully paid → update status
  @loan.update(status: new_status)

  respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        dom_id(@loan, :status),
        partial: "loans/status_toggle",
        locals: { loan: @loan }
      )
    end
    format.html { redirect_to loans_path, notice: "Loan status updated." }
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

  def prevent_edit_if_closed
  if @loan.nil? || !@loan.status || @loan.balance <= 0
    redirect_to loans_path,
      alert: "This loan is closed or fully paid. You cannot modify it."
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def loan_params
      params.expect(loan: [ :member_id, :available_amount, :amount, :payment_period_months, :repayment_amount_per_month, :user_id, :status, :bank_charges, :first_installment, :refinanced_from_id, :is_refinance, :bank_charge_paid ])
    end
end
