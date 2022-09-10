class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  skip_before_action :verify_authenticity_token

  THUMBS = '1F44D'
  ROCK = '1F918'
  HANG = '1F919'
  OK = '1F44C' 
  RESPONSES = [THUMBS, ROCK, HANG, OK]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    phone = Phoner::Phone.parse(params[:From])

    @number = Number.find_by_number("#{phone.area_code}#{phone.number}")
    
    head :not_found unless @number
    Rails.logger.info("Found number: #{@number.number}")

    @lines = item_params[:Body].split("\n")

    if @lines.size > 1
      handle_multiple_lines
    else
      handle_one_line
    end

    items = @number.items.not_complete.map { |item| "#{item.code} #{item.text}" }.join("\n")

    ItemNotification
      .with(message: "#{Twemoji.render_unicode(RESPONSES.sample)}\n#{items}")
      .deliver(@number)

    head :created
  end

  def handle_one_line
    if item = @number.items.find_by_code(@lines.first)
      return item.update(complete: true)
    end

    return if @lines.first == '?'

    @number.items.create!(text: @lines.first, code: rand(0000..9999))
  end

  def save_multiple_items
    Item.transaction do
      @lines.each do |line|
        item = @number.items.create!(text: line, code: rand(0000..9999))
        Rails.logger.info("New item: #{item.inspect}")
      end
    end
  end

  def emoji
    Twemoji.render_unicode(RESPONSES.sample)
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.permit(:Body)
    end
end
