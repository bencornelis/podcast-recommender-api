class PodcastSearch < ApplicationRecord
  has_many :podcasts

  def fetch_related_podcasts
    # scrape the related podcasts for each podcast in the search
    # there will be repetitions across podcasts
    podcasts = scrape_related_podcasts

    # do not include related podcasts already in the search
    search_ids = itunes_podcast_ids
    podcasts = podcasts.reject { |pod| search_ids.include?(pod[:itunes_id]) }

    # count the appearances of each related podcast
    podcast_to_count = podcasts.map { |pod| [pod, podcasts.count(pod)] }.to_h

    # sort podcasts by number of appearances
    podcasts
      .uniq
      .sort_by { |pod| -podcast_to_count[pod] }
      .take(5)
  end

  def scrape_related_podcasts
    fetch_itunes_podcast_pages.flat_map do |page|
      page.css('.lockup.small.podcast.audio').map do |podcast_node|
        itunes_id = podcast_node.attributes['adam-id'].value
        title     = podcast_node.attributes['preview-title'].value
        image_url = podcast_node.css('div.artwork img')
                      .first.attributes['src-swap-high-dpi'].value

        {
          itunes_id: itunes_id, # so we can remove podcasts that were entered in the search
          title:     title,
          image_url: image_url
        }
      end
    end
  end

  def fetch_itunes_podcast_pages
    hydra = Typhoeus::Hydra.new
    responses = []

    itunes_podcast_urls.each do |url|
      request = Typhoeus::Request.new(url)

      request.on_complete do |response|
        responses << response
      end

      hydra.queue(request)
    end

    hydra.run
    responses.map { |response| Nokogiri::HTML(response.body) }
  end

  def itunes_podcast_ids
    podcasts.pluck(:itunes_id)
  end

  def itunes_podcast_urls
    podcasts.pluck(:itunes_url)
  end
end
