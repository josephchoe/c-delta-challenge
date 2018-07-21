require 'rails_helper'

describe Response do
  context 'associations' do
    it { is_expected.to have_many(:question_responses) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
  end

  describe '#display_name' do
    let(:response) { Response.new(first_name: 'Tal', last_name: 'Safran') }

    it 'concatenates the first and last name' do
      expect(response.display_name).to eql('Tal Safran')
    end
  end

  describe '#completed?' do
    let(:response) { Response.new }

    before do
      allow(Question).to receive(:count).and_return(3)
      allow(response).to receive_message_chain(:question_responses, :count)
        .and_return(response_count)
    end

    context 'when no responses exist' do
      let(:response_count) { 0 }
      it 'is false' do
        expect(response.completed?).to be(false)
      end
    end

    context 'when some responses exist' do
      let(:response_count) { 1 }
      it 'is false' do
        expect(response.completed?).to be(false)
      end
    end

    context 'when responses exist for all questions' do
      let(:response_count) { 3 }
      it 'is true' do
        expect(response.completed?).to be(true)
      end
    end
  end

  context 'scores' do
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
    let(:response) { create(:response) }

    describe '#raw_score' do
      it 'adds choice scores to total' do
        create(:question_response, response: response, question_choice: question1_choice2)
        create(:question_response, response: response, question_choice: question2_choice2)
        create(:question_response, response: response, question_choice: question3_choice2)
        expect(response.raw_score(creative_quality)).to eql -3
      end

      context 'when question is not answered' do
        it 'is not added to raw_score' do
          create(:question_response, response: response, question_choice: question1_choice2)
          create(:question_response, response: response, question_choice: question2_choice2)
          expect(response.raw_score(creative_quality)).to eql -2
        end
      end
    end

    describe '#max_score' do
      it 'adds max scores to total' do
        create(:question_response, response: response, question_choice: question1_choice2)
        create(:question_response, response: response, question_choice: question2_choice2)
        create(:question_response, response: response, question_choice: question3_choice2)
        expect(response.max_score(creative_quality)).to eql 12
      end

      context 'when question is not answered' do
        let(:question3) { create(:question) }
        let!(:question3_choice1) { create(:question_choice, question: question3, creative_quality: creative_quality, score: 1) }
        let!(:question3_choice2) { create(:question_choice, question: question3, creative_quality: creative_quality, score: -1) }
        let!(:question3_choice3) { create(:question_choice, question: question3, creative_quality: creative_quality, score: 4) }

        it 'is not added to max_score' do
          create(:question_response, response: response, question_choice: question1_choice2)
          create(:question_response, response: response, question_choice: question2_choice2)
          expect(response.max_score(creative_quality)).to eql 8
        end
      end
    end
  end
end
