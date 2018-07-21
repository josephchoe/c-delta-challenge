require 'rails_helper'

describe CreativeQuality do
  context 'associations' do
    it { is_expected.to have_many(:question_choices) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe '#score' do
    let(:creative_quality) { create(:creative_quality) }
    let(:question1) { create(:question) }
    let!(:question1_choice1) { create(:question_choice, question: question1, creative_quality: creative_quality, score: 1) }
    let!(:question1_choice2) { create(:question_choice, question: question1, creative_quality: creative_quality, score: -1) }
    let!(:question1_choice3) { create(:question_choice, question: question1, creative_quality: creative_quality, score: 4) }
    let(:question2) { create(:question) }
    let!(:question2_choice1) { create(:question_choice, question: question2, creative_quality: creative_quality, score: 1) }
    let!(:question2_choice2) { create(:question_choice, question: question2, creative_quality: creative_quality, score: -1) }
    let!(:question2_choice3) { create(:question_choice, question: question2, creative_quality: creative_quality, score: 4) }
    let(:question3) { create(:question) }
    let!(:question3_choice1) { create(:question_choice, question: question3, creative_quality: creative_quality, score: 1) }
    let!(:question3_choice2) { create(:question_choice, question: question3, creative_quality: creative_quality, score: -1) }
    let!(:question3_choice3) { create(:question_choice, question: question3, creative_quality: creative_quality, score: 4) }
    let(:response1) { create(:response) }
    let(:response2) { create(:response) }
    let(:response3) { create(:response) }

    it 'adds choice scores to total' do
      create(:question_response, response: response1, question_choice: question1_choice2)
      create(:question_response, response: response2, question_choice: question2_choice1)
      create(:question_response, response: response3, question_choice: question3_choice3)
      expect(creative_quality.score).to eql 33
    end
  end
end
