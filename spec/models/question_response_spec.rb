require 'rails_helper'

describe QuestionResponse do
  context 'associations' do
    it { is_expected.to belong_to(:question_choice) }
    it { is_expected.to belong_to(:response) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :question_choice }
    it { is_expected.to validate_presence_of :response }
  end

  describe '#impact' do
    let(:creative_quality) { create(:creative_quality, name: 'Awesomeness') }
    let(:question) { create(:question) }
    let(:question_choice) { create(:question_choice, question: question, creative_quality: creative_quality, score: 5) }
    let(:response) { create(:response) }

    it 'shows quality and score' do
      question_response = create(:question_response, response: response, question_choice: question_choice)
      expect(question_response.impact).to eql 'Awesomeness 5'
    end
  end

  describe '#impact_class' do
    let(:creative_quality) { create(:creative_quality) }
    let(:question) { create(:question) }
    let(:question_choice_positive) { create(:question_choice, question: question, creative_quality: creative_quality, score: 1) }
    let(:question_choice_negative) { create(:question_choice, question: question, creative_quality: creative_quality, score: -1) }
    let(:response) { create(:response) }

    context 'when impact is positive' do
      it 'is text-success' do
        question_response = create(:question_response, response: response, question_choice: question_choice_positive)
        expect(question_response.impact_class).to eql 'text-success'
      end
    end

    context 'when impact is negative' do
      it 'is text-danger' do
        question_response = create(:question_response, response: response, question_choice: question_choice_negative)
        expect(question_response.impact_class).to eql 'text-danger'
      end
    end
  end
end
