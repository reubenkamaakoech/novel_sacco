class ClosingBooksController < ApplicationController
  before_action :set_closing_book, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /closing_books or /closing_books.json
  def index
    @closing_books = ClosingBook.all
  end

  # GET /closing_books/1 or /closing_books/1.json
  def show
  end

  # GET /closing_books/new
  def new
    @closing_book = ClosingBook.new
    @closing_book.member_id = params[:member_id] if params[:member_id].present?
  end

  # GET /closing_books/1/edit
  def edit
  end

  # POST /closing_books or /closing_books.json
  def create
  @closing_book = ClosingBook.new(closing_book_params)

  if @closing_book.save
    redirect_to @closing_book, notice: "Member closed successfully."
  else
    render :new, status: :unprocessable_entity
  end
end

  # PATCH/PUT /closing_books/1 or /closing_books/1.json
  def update
    respond_to do |format|
      if @closing_book.update(closing_book_params)
        format.html { redirect_to @closing_book, notice: "Closing book was successfully updated." }
        format.json { render :show, status: :ok, location: @closing_book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @closing_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /closing_books/1 or /closing_books/1.json
  def destroy
    @closing_book.destroy!

    respond_to do |format|
      format.html { redirect_to closing_books_path, status: :see_other, notice: "Closing book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def closing_summary
  member = Member.find(params[:id])

  active_loan = member.loans.find_by(status: true)

  render json: {
    loan_id: active_loan&.id,
    bank_charges: active_loan&.bank_charges,
    outstanding_bank_charge: active_loan&.outstanding_bank_charge,
    repayment_count: active_loan&.loan_repayments&.count
  }
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_closing_book
      @closing_book = ClosingBook.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def closing_book_params
      params.expect(closing_book: [ :member_id, :user_id, :closing_date, :total_savings, :loan_balance, :withdrawal_charges, :outstanding_bank_charges, :amount_paid, :remarks ])
    end
end
