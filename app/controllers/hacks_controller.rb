require 'open-uri'

class HacksController < ApplicationController
  def index
    filters = combined_filters
    @q = Hack.ransack(filters)
    @pagy, @hacks = pagy(@q.result.distinct.order(created_at: :desc), items: 50, size: [1, 3, 3, 1])
    @q = Hack.ransack(params[:q])
  end

  def show
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

  def combined_filters
    combined_filter_ids = [
      params.dig(:q, :with_scale_ids),
      params.dig(:q, :with_popularity_ids),
      params.dig(:q, :with_financial_topic_ids),
      params.dig(:q, :with_audience_ids),
      params.dig(:q, :with_horizon_ids),
      params.dig(:q, :with_risk_ids),
      params.dig(:q, :with_implementation_ids),
      params.dig(:q, :with_financial_ids),
      params.dig(:q, :with_knowledge_ids)
    ].compact.flatten.uniq

    {
      is_advice_eq: params[:q][:is_advice_eq],
      source_id_eq: params[:q][:source_id_eq],
      hack_categories_category_id_in: combined_filter_ids
    }
  end
end
