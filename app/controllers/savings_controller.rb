class SavingsController < ApplicationController
  before_action :set_saving, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /savings or /savings.json
  def index
    @savings = Saving.includes(:member).all
    @total_savings = Saving.sum(:amount)
    @locked_savings = @total_savings * 0.25
    @available_for_loans = @total_savings - @locked_savings

    @savings_summary = Member
      .where(status: true) # only active members
      .left_joins(:savings) # include deposits if they exist
      .select(
        "members.id AS member_id,
         members.name AS member_name,
         COALESCE(SUM(savings.amount), 0) AS amount"
       )
      .group("members.id, members.name")
  end


  # GET /savings/1 or /savings/1.json
  def show
  end

  def member_statements
    @members = Member.all 
    @member = Member.find(params[:member_id])
    @member_statements = @member.savings.order(created_at: :asc)
    @repayments = @member.loans.includes(:loan_repayments).flat_map(&:loan_repayments)

    @total_savings = @member.total_savings
    @locked_savings = @member.locked_savings
    @available_for_loans = @member.available_for_loans

    @total_loans = @member.loans.sum(:amount)
    @total_repayments = @member.loan_repayments.sum(:amount)
    @loan_balance = @total_loans - @total_repayments
    @available_loans_to_member = @available_for_loans - @total_loans
  end

  # GET /savings/new
  def new
    @saving = Saving.new
    @saving.member_id = params[:member_id] if params[:member_id].present?
  end

  # GET /savings/1/edit
  def edit
  end

  # POST /savings or /savings.json
  def create
    @saving = Saving.new(saving_params)

    respond_to do |format|
      if @saving.save
        format.html { redirect_to @saving, notice: "Saving was successfully created." }
        format.json { render :show, status: :created, location: @saving }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @saving.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /savings/1 or /savings/1.json
  def update
    respond_to do |format|
      if @saving.update(saving_params)
        format.html { redirect_to @saving, notice: "Saving was successfully updated." }
        format.json { render :show, status: :ok, location: @saving }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @saving.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /savings/1 or /savings/1.json
  def destroy
    @saving.destroy!

    respond_to do |format|
      format.html { redirect_to savings_path, status: :see_other, notice: "Saving was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def create_monthly
  # Get selected month/year, default to current
  month = params[:month].presence || Date.today.month
  year  = params[:year].presence  || Date.today.year
  selected_date = Date.new(year.to_i, month.to_i, 1)

  created_members = []
  skipped_members = []

  Member.where(status: true).find_each do |member|
    # Skip if already has ordinary saving for selected month/year
    if Saving.where(member_id: member.id, deposit_type: "ordinary")
             .where("strftime('%m', month) = ? AND strftime('%Y', month) = ?", selected_date.strftime('%m'), selected_date.strftime('%Y'))
             .exists?
      skipped_members << member.name
      next
    end

    Saving.create!(
      member_id: member.id,
      amount: member.monthly_contribution,
      deposit_type: "ordinary",
      month: selected_date,
      user_id: current_user.id
    )
    created_members << member.name
  end

  message = []
  message << "#{created_members.count} ordinary savings created for #{selected_date.strftime('%B %Y')}." if created_members.any?
  message << "Skipped: #{skipped_members.sort.join(', ')}" if skipped_members.any?

  redirect_to savings_path, notice: message.join(" ")
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_saving
      @saving = Saving.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def saving_params
      params.expect(saving: [ :member_id, :amount, :deposit_type, :month, :user_id ])
    end
end
