class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /attendances or /attendances.json
  def index
  @attendances = Attendance.includes(:site, :employee).order(:work_date, 'sites.name', 'employees.full_name')
  @grouped_attendances = @attendances.group_by(&:work_date)
end


  # GET /attendances/1 or /attendances/1.json
  def show
  end

  # GET /attendances/new
  def new
    @employees = Employee.where(status: true)
    @sites = Site.all
    @dates = (Date.current.beginning_of_month..Date.current.end_of_month).to_a
    @attendances_lookup = Attendance.all.index_by { |a| [a.employee_id, a.work_date] }

  # 📅 1. Parse the start date or default to current week's beginning
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today.beginning_of_week

  # 📅 2. Define the 7-day range
    @end_date = @start_date.end_of_week
    @dates = (@start_date..@end_date).to_a

  # 👷‍♂️ 3. Load active employees
    @employees = Employee.where(status: "active")  # or use Employee.active if you have a scope

  # 🏗 4. Load all sites
    @sites = Site.all

  # 📊 5. Preload existing attendances for the selected week
    @attendances_lookup = Attendance
      .where(work_date: @dates, employee_id: @employees.map(&:id))
      .index_by { |a| [a.employee_id, a.work_date] }
  end


  def quick_create
  attendance = Attendance.find_or_initialize_by(
    employee_id: params[:employee_id],
    work_date: params[:work_date]
  )
  attendance.site_id = params[:site_id]

  if attendance.save
    head :ok
  else
    render json: attendance.errors.full_messages, status: :unprocessable_entity
  end
end


  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances or /attendances.json
  def create
  if params[:attendances]
    params[:attendances].each do |att|
      site_id = att[:site_id].presence

      if att[:existing_id].present?
        next unless att[:edited] == "true"  # only update if explicitly edited

        attendance = Attendance.find_by(id: att[:existing_id])
        next unless attendance

        attendance.site_id = site_id
        attendance.save
      else
        next if site_id.blank?  # skip new rows without site

        Attendance.create(
          employee_id: att[:employee_id],
          work_date: att[:work_date],
          site_id: site_id
        )
      end
    end
  end

  redirect_to new_attendance_path, notice: "Attendance saved successfully."
end


  # PATCH/PUT /attendances/1 or /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to @attendance, notice: "Attendance was successfully updated." }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1 or /attendances/1.json
  def destroy
    @attendance.destroy!

    respond_to do |format|
      format.html { redirect_to attendances_path, status: :see_other, notice: "Attendance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def attendance_params
      params.expect(attendance: [ :employee_id, :site_id, :work_date, :user_id ])
    end
end
