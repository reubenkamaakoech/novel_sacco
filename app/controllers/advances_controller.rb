class AdvancesController < ApplicationController
  before_action :set_advance, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /advances or /advances.json
  def index
    @advances = Advance.all
  end

  # GET /advances/1 or /advances/1.json
  def show
  end

  # GET /advances/new
  def new
    @advance = Advance.new
  end

  # GET /advances/1/edit
  def edit
  end

  # POST /advances or /advances.json
  def create
    @advance = Advance.new(advance_params)

    respond_to do |format|
      if @advance.save
        format.html { redirect_to @advance, notice: "Advance was successfully created." }
        format.json { render :show, status: :created, location: @advance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @advance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advances/1 or /advances/1.json
  def update
    respond_to do |format|
      if @advance.update(advance_params)
        format.html { redirect_to @advance, notice: "Advance was successfully updated." }
        format.json { render :show, status: :ok, location: @advance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @advance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advances/1 or /advances/1.json
  def destroy
    @advance.destroy!

    respond_to do |format|
      format.html { redirect_to advances_path, status: :see_other, notice: "Advance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advance
      @advance = Advance.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def advance_params
      params.expect(advance: [ :employee_id, :amount, :user_id, :date ])
    end
end
