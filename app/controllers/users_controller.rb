class UsersController < ApplicationController
  before_action :set_user, only: [:profile]

  def profile
    @borrowings = current_user.borrowings.where(returned: false)
    # Any additional logic for the profile action
  end

  private

  def set_user
    @user = current_user
  end
end
