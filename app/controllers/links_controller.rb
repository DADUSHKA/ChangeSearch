# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @link = Link.find(params[:id])
    @link.destroy if current_user&.author_of?(@link.linkable)
  end
end
