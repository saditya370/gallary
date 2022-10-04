class PicsController < ApplicationController
  before_action :set_pic, only: %i[ show edit update destroy ]

  # GET /pics or /pics.json
  def index
    @pics = Pic.order(created_at: :desc)
  end

  # GET /pics/1 or /pics/1.json
  def show
  end

  # GET /pics/new
  def new
    @pic = Pic.new
  end

  # GET /pics/1/edit
  def edit
  end

  # POST /pics or /pics.json
  def create
    @pic = Pic.new(pic_params)

    respond_to do |format|
      if @pic.save
        format.turbo_stream do
          render turbo_stream: [
                             turbo_stream.update('new_pic', 
                                                partial: "pics/form",
                                                locals: { pic: Pic.new }),

                             turbo_stream.append('pics', 
                                                  partial: "pics/pic",
                                                  locals: { pic: @pic })     
                             ]
        end
        format.html { redirect_to pic_url(@pic), notice: "Pic was successfully created." }
        format.json { render :show, status: :created, location: @pic }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('new_pic', 
                                                partial: "pics/form",
                                                locals: { pic: @pic })
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pics/1 or /pics/1.json
  def update
    respond_to do |format|
      if @pic.update(pic_params)
        format.html { redirect_to pic_url(@pic), notice: "Pic was successfully updated." }
        format.json { render :show, status: :ok, location: @pic }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pics/1 or /pics/1.json
  def destroy
    @pic.destroy

    respond_to do |format|
      format.html { redirect_to pics_url, notice: "Pic was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pic
      @pic = Pic.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pic_params
      params.require(:pic).permit(:name,images: [])
    end
end
