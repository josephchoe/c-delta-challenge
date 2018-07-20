require 'rails_helper'

describe 'impact on Creative Quality scores', type: :feature do
  let(:creative_quality) { create(:creative_quality) }
  let(:question) { create(:question) }
  let(:question_choice_positive) { create(:question_choice, question: question, creative_quality: creative_quality, score: 1) }
  let(:question_choice_negative) { create(:question_choice, question: question, creative_quality: creative_quality, score: -1) }
  let(:response) { create(:response) }

  context 'when impact is positive' do
    it 'shows in green' do
      create(:question_response, response: response, question_choice: question_choice_positive)
      visit "/responses/#{response.id}"
      expect(page).to have_css('div.text-success', text: "#{creative_quality.name} #{question_choice_positive.score}")
    end
  end

  context 'when impact is negative' do
    it 'shows in red' do
      create(:question_response, response: response, question_choice: question_choice_negative)
      visit "/responses/#{response.id}"
      expect(page).to have_css('div.text-danger', text: "#{creative_quality.name} #{question_choice_negative.score}")
    end
  end
end
