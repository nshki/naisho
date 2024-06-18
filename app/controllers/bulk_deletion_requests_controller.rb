class BulkDeletionRequestsController < ApplicationController
  # @route GET /bulk_deletion_requests/new (new_bulk_deletion_request)
  def new
    @regulation = Region::REGULATIONS.find { |r| r[:id] == params[:regulation] }
    redirect_to root_path if @regulation.blank?
  end

  # @route POST /bulk_deletion_requests (bulk_deletion_requests)
  def create
    @bulk_deletion_request = BulkDeletionRequest.new(params)
    if @bulk_deletion_request.invalid?
      flash.now[:alert] = @bulk_deletion_request.errors
      render(:new, status: :unprocessable_entity) && return
    end

    begin
      @bulk_deletion_request.deliver_emails
    rescue
      flash.now[:alert] = t(".smtp_authentication_alert")
      render(:new, status: :unprocessable_entity) && return
    end

    redirect_to \
      new_bulk_deletion_request_path(regulation: params[:regulation]),
      notice: t(".notice")
  end
end
