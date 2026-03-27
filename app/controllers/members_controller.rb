class MembersController < ApplicationController
  before_action :set_member, only: %i[show edit update destroy statement toggle_status]
  before_action :authenticate_user!
  before_action :authorize_resource!, except: [:index]

  def authorize_resource!(resource = @member)
    return unless current_user # skip if not signed in
    
    unless allowed?(current_user, resource, current_action_type)
      redirect_to root_path, alert: "Not authorized"
    end
  end

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

  def loans
  member = Member.find(params[:member_id])
  render json: member.loans.map { |loan|
    {
      id: loan.id,
      amount: loan.amount,
      repaid: loan.loan_repayments.sum(:amount),
      balance: loan.amount - loan.loan_repayments.sum(:amount)
    }
  }.select { |loan| loan[:balance] > 0 }  # only loans with remaining balance
end

  # PATCH /members/:id/toggle_status
  def toggle_status
    new_status = ActiveModel::Type::Boolean.new.cast(params[:status])

    if !new_status && @member.loans.where(status: true).exists?
      # cannot deactivate member with active loan
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@member, :status), partial: "members/status_toggle", locals: { member: @member }) }
        format.html { redirect_to members_path, alert: "Cannot deactivate member with an active loan." }
      end
      return
    end

    @member.update(status: new_status)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@member, :status), partial: "members/status_toggle", locals: { member: @member }) }
      format.html { redirect_to members_path, notice: "Member status updated." }
    end
  end

  
  def available_for_loans
    member = Member.find(params[:id])
      render json: { available_amount: member.available_for_loans }
  end

  def statement
  @member = Member.find(params[:id])

  @savings = @member.savings.order(:created_at)
  @loans = @member.loans.order(:created_at)

  # get all repayments via loans
  @repayments = LoanRepayment.where(loan_id: @member.loans.pluck(:id)).order(:created_at)

  @total_savings = @savings.sum(:amount)
  @locked_savings = @total_savings * Member.locked_ratio
  @available_for_loans = @total_savings - @locked_savings
  @total_loans = @loans.sum(:amount)
  @total_repayments = @repayments.sum(:amount)
  @loan_balance = @total_loans - @total_repayments

  # Combine transactions into one array
  @transactions = []

  @savings.each do |s|
    @transactions << { date: s.created_at, type: "Saving", amount: s.amount, deposit_type: s.deposit_type, record: s }
  end

  @loans.each do |l|
    @transactions << { date: l.created_at, type: "Loan", amount: -l.amount, record: l }
  end

  @repayments.each do |r|
    @transactions << { date: r.created_at, type: "Repayment", amount: r.amount, record: r }
  end

  # Sort by date
  @transactions.sort_by! { |t| t[:date] }
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
  @member = Member.find_by(id: params[:id])

  unless @member
    redirect_to members_path, alert: "Member not found"
  end
end

    # Only allow a list of trusted parameters through.
    def member_params
      params.expect(member: [ :membership_number, :name, :id_number, :phone_number, :email, :join_date, :status, :next_of_kin_name, :next_of_kin_contact, :user_id, :next_of_kin_relationship, :passport_photo, :monthly_contribution ])
    end
end
