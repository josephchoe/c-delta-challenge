class CreativeQuality < ApplicationRecord
  has_many :question_choices

  validates :name, :description, :color, presence: true

  def score
    question_responses_for_creative_quality = QuestionResponse.joins(:question_choice).merge(self.question_choices)
    score = question_responses_for_creative_quality.inject(Hash.new(0.0)) do |accumulator, question_response|
      accumulator.tap do |acc|
        acc[:raw_score] += question_response.question_choice.score
        acc[:max_score] += question_response.question.question_choices.maximum(:score)
      end
    end

    ((score[:raw_score] / score[:max_score]) * 100).to_i
  end
end
