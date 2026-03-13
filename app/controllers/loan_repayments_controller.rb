class LoanRepaymentsController < ApplicationController
  before_action :set_loan_repayment, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /loan_repayments or /loan_repayments.json
  def index
    @loan_repayments = LoanRepayment.all
  end

  # GET /loan_repayments/1 or /loan_repayments/1.json
  def show
  end

  # GET /loan_repayments/new
  def new
    if params[:loan_id].present?
      @loan_repayment = LoanRepayment.new(loan_id: params[:loan_id])
     else
      @loan_repayment = LoanRepayment.new
    end
  end

  # GET /loan_repayments/1/edit
  def edit
  end

  # POST /loan_repayments or /loan_repayments.json
  def create
    @loan_repayment = LoanRepayment.new(loan_repayment_params)

    respond_to do |format|
      if @loan_repayment.save
        format.html { redirect_to @loan_repayment, notice: "Loan repayment was successfully created." }
        format.json { render :show, status: :created, location: @loan_repayment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan_repayment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loan_repayments/1 or /loan_repayments/1.json
  def update
    respond_to do |format|
      if @loan_repayment.update(loan_repayment_params)
        format.html { redirect_to @loan_repayment, notice: "Loan repayment was successfully updated." }
        format.json { render :show, status: :ok, location: @loan_repayment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loan_repayment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loan_repayments/1 or /loan_repayments/1.json
  def destroy
    @loan_repayment.destroy!

    respond_to do |format|
      format.html { redirect_to loan_repayments_path, status: :see_other, notice: "Loan repayment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

def generate_monthly
  # Get selected month/year, default to current
  month = params[:month].presence || Date.today.month
  year  = params[:year].presence  || Date.today.year
  selected_date = Date.new(year.to_i, month.to_i, 1)

  created_members = []
  skipped_members = []

  Member.where(status: true).find_each do |member|
    # Skip if already has ordinary loan repayment for selected month/year
    if Saving.where(member_id: member.id)
             .where("strftime('%m', month) = ? AND strftime('%Y', month) = ?", selected_date.strftime('%m'), selected_date.strftime('%Y'))
             .exists?
      skipped_members << member.name
      next
    end

    LoanRepayment.create!(
      loan_id: member.loans.active_with_balance.first&.id,
      amount: loan.repayment_amount,
      month: selected_date,
      user_id: current_user.id
    )
    created_members << member.name
  end

  message = []
  message << "#{created_members.count} ordinary loan repayments created for #{selected_date.strftime('%B %Y')}." if created_members.any?
  message << "Skipped: #{skipped_members.sort.join(', ')}" if skipped_members.any?

  redirect_to loan_repayments_path, notice: message.join(" ")
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan_repayment
      @loan_repayment = LoanRepayment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def loan_repayment_params
      params.expect(loan_repayment: [ :user_id, :loan_id, :amount, :repayment_month, ])
    end
end
