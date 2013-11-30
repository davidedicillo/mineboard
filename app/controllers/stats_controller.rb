class StatsController < ApplicationController
  before_action :set_stat, only: [:show, :edit, :update, :destroy]

  # GET /stats
  # GET /stats.json
  def index

    @stat_ids = []

    Server.all.each do |server|
       ids =  server.stats.order('date desc').limit(30).pluck(:id)
       @stat_ids += ids
    end

    @stats = Stat.where(id: @stat_ids).order('date desc')


    @avgdaychains = (@stats.collect(&:chains).sum.to_f/@stats.length).round(3)

    @paststat_ids = []

    Server.all.each do |server|
       ids =  server.stats.order('date desc').limit(30).offset(30).pluck(:id)
       @paststat_ids += ids
    end

    @paststats = Stat.where(id: @paststat_ids).order('date desc')

    @pastavgdaychains = (@paststats.collect(&:chains).sum.to_f/@paststats.length).round(3)

    @changedaychains = (@avgdaychains-@pastavgdaychains).round(3)
  end

  # GET /stats/1
  # GET /stats/1.json
  def show
  end

  # GET /stats/new
  def new
    @stat = Stat.new
  end

  # GET /stats/1/edit
  def edit
  end

  # POST /stats
  # POST /stats.json
  def create
    @stat = Stat.new(stat_params)

    respond_to do |format|
      if @stat.save
        format.html { redirect_to @stat, notice: 'Stat was successfully created.' }
        format.json { render action: 'show', status: :created, location: @stat }
      else
        format.html { render action: 'new' }
        format.json { render json: @stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stats/1
  # PATCH/PUT /stats/1.json
  def update
    respond_to do |format|
      if @stat.update(stat_params)
        format.html { redirect_to @stat, notice: 'Stat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stats/1
  # DELETE /stats/1.json
  def destroy
    @stat.destroy
    respond_to do |format|
      format.html { redirect_to stats_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stat
      @stat = Stat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stat_params
      params[:stat]
    end
end
