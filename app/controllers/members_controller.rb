class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy statement]
  before_action :authenticate_user!

  # GET /members or /members.json
  def index
    @members = Member.all
  end

  # GET /members/1 or /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  def id_card
    @member = Member.find(params[:id])
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: "Member was successfully created." }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: "Member was successfully updated." }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1 or /members/1.json
  def destroy
    @member.destroy!

    respond_to do |format|
      format.html { redirect_to members_path, status: :see_other, notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

   def toggle_status
    @member = Member.find(params[:id])
    new_status = ActiveModel::Type::Boolean.new.cast(params[:status])
    @member.update(status: new_status)
      redirect_to members_path, notice: "Member status updated."
  end

  def available_for_loans
    member = Member.find(params[:id])
      render json: { available_amount: member.available_for_loans }
  end

  def statement
    @savings = @member.savings.order(created_at: :asc)
    @loans = @member.loans.order(created_at: :asc)
    @repayments = @member.loan_repayments.order(created_at: :asc)
    @total_savings = @member.savings.sum(:amount)
    @locked_savings = @total_savings * 0.25
    @available_for_loans = @total_savings - @locked_savings
    @total_loans = @member.loans.sum(:amount)

     # repayments
    @repayments = LoanRepayment.where(loan_id: @member.id)
    @total_repayments = @repayments.sum(:amount)
    @loan_balance = @total_loans - @total_repayments

    # Combine transactions into one list for statement
    @transactions = []

    @savings.each do |s|
      @transactions << { date: s.created_at, type: "Saving", amount: s.amount }
    end

    @loans.each do |l|
      @transactions << { date: l.created_at, type: "Loan", amount: -l.amount }
    end

    @repayments.each do |r|
      @transactions << { date: r.created_at, type: "Repayment", amount: r.amount }
    end

    # Sort by date for proper statement view
    @transactions.sort_by! { |t| t[:date] }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:member_id] || params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.expect(member: [ :membership_number, :name, :id_number, :phone_number, :email, :join_date, :status, :next_of_kin_name, :next_of_kin_contact, :user_id, :next_of_kin_relationship, :passport_photo, :monthly_contribution ])
    end
end
