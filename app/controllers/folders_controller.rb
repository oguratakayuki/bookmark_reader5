class FoldersController < ApplicationController
  before_action :set_folder, only: [:show, :edit, :update, :destroy]


  def root
    @history = History.new
    @folders = Folder.by_layer(1).order(:id).page(params[:page])
    @layer = 0
  end



  # GET /folders
  # GET /folders.json
  def index
    #@history = History.find(params[:history_id])
    @folders = @history.folders.by_layer(1).order(:id).page(params[:page])
    @layer = 0
  end

  def childs
    @folder = Folder.find(params[:id])
    @folders = Folder.where(parent_id: params[:id])
    @layer = @folder.layer
    render layout: nil
  end

  # GET /folders/1
  # GET /folders/1.json
  def show
  end

  # GET /folders/new
  def new
    @folder = Folder.new
  end

  # GET /folders/1/edit
  def edit
    @history = History.find(params[:history_id])
  end

  # POST /folders
  # POST /folders.json
  def create
    @folder = Folder.new(folder_params)

    respond_to do |format|
      if @folder.save
        format.html { redirect_to @folder, notice: 'Folder was successfully created.' }
        format.json { render :show, status: :created, location: @folder }
      else
        format.html { render :new }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /folders/1
  # PATCH/PUT /folders/1.json
  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to @folder, notice: 'Folder was successfully updated.' }
        format.json { render :show, status: :ok, location: @folder }
      else
        format.html { render :edit }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /folders/1
  # DELETE /folders/1.json
  def destroy
    @folder.destroy
    respond_to do |format|
      format.html { redirect_to folders_url, notice: 'Folder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit(:history_id, :layler, :path, :title)
    end
end
