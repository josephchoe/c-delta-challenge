class Response < ApplicationRecord
  has_many :question_responses

  validates :first_name, presence: true
  validates :last_name, presence: true

  delegate :count, to: :question_responses, prefix: true

  def display_name
    "#{first_name} #{last_name}"
  end

  def completed?
    question_responses_count == Question.count
  end

  def raw_score(creative_quality)
    score_accumulator(creative_quality) do |question_response|
      question_response.question_choice.score
    end
  end

  def max_score(creative_quality)
    score_accumulator(creative_quality) do |question_response|
      question_response.question.question_choices.maximum(:score)
    end
  end

  private

  def score_accumulator(creative_quality)
    question_responses_for_creative_quality = question_responses.joins(:question_choice).merge(creative_quality.question_choices)

    question_responses_for_creative_quality.inject(0) do |accumulator, question_response|
      value = yield question_response
      accumulator + value
    end
  end
end
