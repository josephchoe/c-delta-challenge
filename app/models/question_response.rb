class QuestionResponse < ApplicationRecord
  belongs_to :question_choice
  belongs_to :response

  validates :question_choice, presence: true
  validates :response, presence: true

  delegate :question, to: :question_choice

  def impact
    "#{question_choice.creative_quality.name} #{question_choice.score}"
  end

  def impact_class
    return 'text-success' if question_choice.score > 0
    'text-danger'
  end
end
