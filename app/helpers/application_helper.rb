module ApplicationHelper
  def current_url(new_params={})
    url = request.url
    if url.include? '?'
      "#{request.url}&#{new_params.to_query}"
    else
      "#{request.url}?#{new_params.to_query}"
    end
  end
end
