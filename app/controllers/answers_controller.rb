# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_answer, only: %i[destroy update assigning_as_best]

  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    flash[:notice] = "Your answer successfully created." if @answer.save
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    flash[:notice] = "Answer was successfully deleted"
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    flash.now[:notice] = "The answer was updated successfully."
  end

  def assigning_as_best
    @answer.assign_best if current_user.author_of?(@answer.question)
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id _destroy name url])
  end
end
