require 'open-uri'

class HacksController < ApplicationController
  def index
    @q = Hack.ransack(params[:q])
    @pagy, @hacks = pagy(@q.result.distinct.order(created_at: :desc), items: 50, size: [1, 3, 3, 1])
  end

  def show
    # @articles = current_user.channels.where(id: params[:article_id]).first
    @hack = Hack.find(params[:id])
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  def download_pdf
    @hack = Hack.find(params[:id])
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Hack_#{@hack.id}",
               template: 'hacks/pdf'
      end
    end
  end

  private

  def convert_dates_to_yyyymmdd(params, *keys)
    keys.each do |key|
      next unless params&.dig(key).present?

      begin
        params[key] = Date.strptime(params[key], '%m/%d/%Y').strftime('%Y-%m-%d')
      rescue ArgumentError
        flash[:alert] = 'Invalid date format'
      end
    end
  end

  def valid_hacks_ransack(query_params)
    current_user.hacks.joins(:hack_structured_info, :hack_validation)
                .where(hack_validations: { status: true })
                .ransack(query_params)
  end

  def not_valid_hacks_ransack(query_params)
    current_user.hacks
                .left_joins(:hack_structured_info, :hack_validation)
                .where('hack_structured_infos.id IS NULL OR hack_validations.status = false OR hack_validations.status IS NULL')
                .ransack(query_params)
  end

  def hack_params
    params.permit(:page, :filter, q: %i[video_channel_id_eq created_at_gteq created_at_lteq])
  end
end
