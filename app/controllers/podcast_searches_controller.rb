class PodcastSearchesController < ApplicationController
  def show
    search = PodcastSearch.find(params[:id])
    related_podcasts = search.fetch_related_podcasts
    render json: { results: related_podcasts }
  end

  def create
    search = PodcastSearch.create
    podcasts = search.podcasts.create(search_params[:itunes_urls])
    redirect_to podcast_search_path(search)
  end

  private

  def search_params
    params.permit(:itunes_urls => [:itunes_url])
  end
end