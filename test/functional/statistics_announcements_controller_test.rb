require 'test_helper'

class StatisticsAnnouncementsControllerTest < ActionController::TestCase
  test "when locale is english it redirects to research and statistics" do
    get :index
    assert_response :redirect
  end

  test "when locale is english it redirects with params for finder-frontend" do
    get :index, params: {
      keywords: "one two",
      taxons: %w[one],
      people: %w[one two],
      departments: %w[one two],
      from_date: '01/01/2014',
      to_date: '01/01/2014'
    }

    redirect_params_query = {
      content_store_document_type: 'statistics_upcoming',
      keywords: "one two",
      level_one_taxon: 'one',
      people: %w[one two],
      organisations: %w[one two],
      public_timestamp: { from: '01/01/2014', to: '01/01/2014' }
    }.to_query

    assert_redirected_to "#{Plek.new.website_root}/search/research-and-statistics?#{redirect_params_query}"
  end
end
