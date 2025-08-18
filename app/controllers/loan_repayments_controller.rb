class LoanRepaymentsController < ApplicationController
  before_action :set_loan_repayment, only: %i[ show edit update destroy ]

  # GET /loan_repayments or /loan_repayments.json
  def index
    @loan_repayments = LoanRepayment.all
  end

  # GET /loan_repayments/1 or /loan_repayments/1.json
  def show
  end

  # GET /loan_repayments/new
  def new
    @loan_repayment = LoanRepayment.new
    @loan_repayment.loan_id = params[:loan_id] if params[:loan_id].present?
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan_repayment
      @loan_repayment = LoanRepayment.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def loan_repayment_params
      params.expect(loan_repayment: [ :user_id, :loan_id, :member_id, :amount ])
    end
end
