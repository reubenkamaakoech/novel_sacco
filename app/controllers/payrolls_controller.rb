class PayrollsController < ApplicationController
  before_action :set_payroll, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /payrolls or /payrolls.json
 def index
  @employees = Employee.all

  # Use selected period or default to current month
  @selected_period = params[:period] || Date.today.strftime("%Y-%m")
  @half = params[:half] # "1" or "2"

  start_date = Date.parse(@selected_period + "-01")
  mid_date = start_date + 14.days
  end_date = start_date.end_of_month

  date_range =
    case @half
    when "1"
      start_date..mid_date
    when "2"
      (mid_date + 1.day)..end_date
    else
      start_date..end_date
    end

  # Pull payrolls for selected period
  @payrolls = Payroll.joins(:employee)
                     .where(employees: { status: "active" })
                     .where(period: @selected_period)
                     .order(period: :desc)

  @payrolls = @payrolls.where(employee_id: params[:employee_id]) if params[:employee_id].present?

  # Filter payrolls whose employee has attendances in selected half
  @payrolls = @payrolls.select do |payroll|
    payroll.employee.attendances.where(work_date: date_range).exists?
  end

  # Totals for filtered range
  @total_pay = @payrolls.sum do |payroll|
    payroll.employee.attendances
           .where(work_date: date_range)
           .count * payroll.employee.daily_pay
  end

  employee_ids = @payrolls.map(&:employee_id)
  @total_advances = Advance.where(employee_id: employee_ids, date: date_range).sum(:amount)
  @total_payable = @total_pay - @total_advances

  # Site summaries (keep this logic unchanged)
  @site_summaries = Site.all.map do |site|
    start_date = Date.parse(@selected_period + "-01")
    mid_date = start_date + 14.days
    end_date = start_date.end_of_month

    current_month_range =
      case @half
      when "1"
      start_date..mid_date
      when "2"
      (mid_date + 1.day)..end_date
      else
      start_date..end_date
      end
    
    current_attendances = Attendance.joins(:employee)
                                    .where(site: site, work_date: current_month_range)
                                    .where(employees: { status: "active" })

    current_employee_ids = current_attendances.pluck(:employee_id).uniq
    current_total_pay = current_attendances.sum { |a| a.employee.daily_pay.to_f }
    current_advances = Advance.where(employee_id: current_employee_ids, date: current_month_range).sum(:amount)

    all_attendances = Attendance.joins(:employee)
                                .where(site: site)
                                .where(employees: { status: "active" })

    all_employee_ids = all_attendances.pluck(:employee_id).uniq
    all_total_pay = all_attendances.sum { |a| a.employee.daily_pay.to_f }
    all_advances = Advance.where(employee_id: all_employee_ids).sum(:amount)

    {
      site: site,
      current: {
        employees_count: current_employee_ids.count,
        worked_days: current_attendances.count,
        total_pay: current_total_pay,
        advances: current_advances,
        payable: current_total_pay - current_advances
      },
      all_time: {
        employees_count: all_employee_ids.count,
        worked_days: all_attendances.count,
        total_pay: all_total_pay,
        advances: all_advances,
        payable: all_total_pay - all_advances
      }
    }
  end.reject { |s| s[:worked_days] == 0 }
end


  # GET /payrolls/1 or /payrolls/1.json
  def show
  end

  # GET /payrolls/new
  def new
    @payroll = Payroll.new
  end

  # GET /payrolls/1/edit
  def edit
  end

  # POST /payrolls or /payrolls.json
  def create
    @payroll = Payroll.new(payroll_params)

    respond_to do |format|
      if @payroll.save
        format.html { redirect_to @payroll, notice: "Payroll was successfully created." }
        format.json { render :show, status: :created, location: @payroll }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payrolls/1 or /payrolls/1.json
  def update
    respond_to do |format|
      if @payroll.update(payroll_params)
        format.html { redirect_to @payroll, notice: "Payroll was successfully updated." }
        format.json { render :show, status: :ok, location: @payroll }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payrolls/1 or /payrolls/1.json
  def destroy
    @payroll.destroy!

    respond_to do |format|
      format.html { redirect_to payrolls_path, status: :see_other, notice: "Payroll was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def generate
    Payroll.generate_for_month(params[:month] || Date.today.strftime("%Y-%m"))
    redirect_to payrolls_path, notice: "Payrolls generated for #{params[:month] || Date.today.strftime('%B %Y')}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def payroll_params
      params.expect(payroll: [ :employee_id, :period, :worked_days, :total_pay, :advance, :payable, :user_id ])
    end
end
